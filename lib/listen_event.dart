import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:devtools_app_shared/utils.dart';
import 'package:vm_service/vm_service.dart';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class DebugLoggingController extends DisposableController
    with AutoDisposeControllerMixin {
  DebugLoggingController() {
    addAutoDisposeListener(serviceManager.connectedState, () {
      if (serviceManager.connectedState.value.connected) {
        _handleConnectionStart(serviceManager.service!);
      }
    });
    if (serviceManager.connectedAppInitialized) {
      _handleConnectionStart(serviceManager.service!);
    }
  }

  final data = ListValueNotifier<LogData>([]);

  void _handleConnectionStart(VmService service) {
    // Log `dart:developer` `log` events.
    autoDisposeStreamSubscription(
      service.onLoggingEvent.listen(_handleDeveloperLogEvent),
    );
  }

  void _handleDeveloperLogEvent(Event e) {
    final logRecord = _LogRecord(e.json!['logRecord']);

    String? loggerName =
        _valueAsString(InstanceRef.parse(logRecord.loggerName));
    if (loggerName == 'DebugLogging') {
      final level = logRecord.level;
      final messageRef = InstanceRef.parse(logRecord.message)!;
      String? summary = _valueAsString(messageRef);
      if (messageRef.valueAsStringIsTruncated == true) {
        summary = '${summary!}...';
      }

      final details = summary;
      const severeIssue = 1000;
      final isError = level != null && level >= severeIssue ? true : false;

      log(
        LogData(
          'DebugLogging',
          details,
          e.timestamp,
          isError: isError,
          summary: summary,
        ),
      );
    }
  }

  void log(LogData log) {
    data.add(log);
  }
}

extension type _LogRecord(Map<String, dynamic> json) {
  int? get level => json['level'];

  Map<String, Object?> get loggerName => json['loggerName'];

  Map<String, Object?> get message => json['message'];

  Map<String, Object?> get error => json['error'];

  Map<String, Object?> get stackTrace => json['stackTrace'];
}

String? _valueAsString(InstanceRef? ref) {
  if (ref == null) {
    return null;
  }

  if (ref.valueAsString == null) {
    return ref.valueAsString;
  }

  return ref.valueAsStringIsTruncated == true
      ? '${ref.valueAsString}...'
      : ref.valueAsString;
}

/// A log data object that includes optional summary information about whether
/// the log entry represents an error entry, the log entry kind, and more
/// detailed data for the entry.
class LogData {
  LogData(
    this.kind,
    this.details,
    this.timestamp, {
    this.summary,
    this.isError = false,
  });

  final String kind;
  final int? timestamp;
  final bool isError;
  final String? summary;
  final String? details;

  static const prettyPrinter = JsonEncoder.withIndent('  ');

  String? prettyPrinted() {
    try {
      return prettyPrinter
          .convert(jsonDecode(details!))
          .replaceAll(r'\n', '\n');
    } catch (_) {
      return details;
    }
  }

  @override
  String toString() => 'LogData($kind, $timestamp)';
}

class LoggingScreen extends StatelessWidget {
  const LoggingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => DebugLoggingController(),
      child: const LoggingScreenBody(),
    );
  }
}

class LoggingScreenBody extends StatefulWidget {
  const LoggingScreenBody({super.key});

  @override
  State<LoggingScreenBody> createState() => _LoggingScreenBodyState();
}

class _LoggingScreenBodyState extends State<LoggingScreenBody>
    with
        AutoDisposeMixin,
        ProvidedControllerMixin<DebugLoggingController, LoggingScreenBody> {
  List<String> items = [];
  late List<LogData> logs;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initController()) return;

    cancelListeners();
    logs = controller.data.value;
    addAutoDisposeListener(controller.data, () {
      setState(() {
        logs = controller.data.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LogsTableV2(logs);
  }
}

class LogsTableV2 extends StatelessWidget {
  LogsTableV2(this.filteredLogs, {super.key});

  final _verticalController = ScrollController();
  final List<LogData> filteredLogs;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _verticalController,
      child: CustomScrollView(
        controller: _verticalController,
        slivers: <Widget>[
          SliverVariedExtentList.builder(
            itemCount: filteredLogs.length,
            itemBuilder: _buildRow,
            itemExtentBuilder: _calculateRowHeight,
          ),
        ],
      ),
    );
  }

  Widget? _buildRow(BuildContext context, int index) {
    return Text('Row ${filteredLogs[index].summary}');
  }

  double _calculateRowHeight(int index, SliverLayoutDimensions dimensions) {
    return 15.0;
  }
}

typedef ProvidedControllerCallback<T> = void Function(T);

mixin ProvidedControllerMixin<T, V extends StatefulWidget> on State<V> {
  T get controller => _controller!;

  T? _controller;

  final _callWhenReady = <ProvidedControllerCallback>[];

  /// Calls the provided [callback] once [_controller] has been initialized.
  ///
  /// The [callback] will be called immediately if [_controller] has already
  /// been initialized.
  void callWhenControllerReady(ProvidedControllerCallback callback) {
    if (_controller != null) {
      callback(_controller!);
    } else {
      _callWhenReady.add(callback);
    }
  }

  /// Initializes [_controller] from package:provider.
  ///
  /// This method should be called in [didChangeDependencies]. Returns whether
  /// or not a new controller was provided upon subsequent calls to
  /// [initController].
  ///
  /// This method will commonly be used to return early from
  /// [didChangeDependencies] when initialization code should not be run again
  /// if the provided controller has not changed.
  ///
  /// E.g. `if (!initController()) return;`
  bool initController() {
    final newController = Provider.of<T>(context);
    if (newController == _controller) return false;
    final firstInitialization = _controller == null;
    _controller = newController;
    if (firstInitialization) {
      for (final callback in _callWhenReady) {
        callback(_controller!);
      }
      _callWhenReady.clear();
    }
    return true;
  }
}
