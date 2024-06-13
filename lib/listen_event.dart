import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:devtools_app_shared/service.dart';
import 'package:devtools_app_shared/utils.dart';
import 'package:vm_service/vm_service.dart';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

Future<String> _retrieveFullStringValue(
  VmService? service,
  IsolateRef isolateRef,
  InstanceRef stringRef,
) {
  final fallback = '${stringRef.valueAsString}...';

  return service
          ?.retrieveFullStringValue(
            isolateRef.id!,
            stringRef,
            onUnavailable: (truncatedValue) => fallback,
          )
          .then((value) => value ?? fallback) ??
      Future.value(fallback);
}

class LoggingControllerV2 extends DisposableController
    with AutoDisposeControllerMixin {
  LoggingControllerV2() {
    addAutoDisposeListener(serviceManager.connectedState, () {
      if (serviceManager.connectedState.value.connected) {
        _handleConnectionStart(serviceManager.service!);
      }
    });
    if (serviceManager.connectedAppInitialized) {
      _handleConnectionStart(serviceManager.service!);
    }
  }

  final _logStatusController = StreamController<String>.broadcast();

  /// A stream of events for the textual description of the log contents.
  ///
  /// See also [statusText].
  Stream<String> get onLogStatusChanged => _logStatusController.stream;

  List<LogDataV2> data = <LogDataV2>[];

  final selectedLog = ValueNotifier<LogDataV2?>(null);

  void _updateData(List<LogDataV2> logs) {
    data = logs;
  }

  void clear() {
    _updateData([]);
  }

  void _handleConnectionStart(VmService service) {
    // Log `dart:developer` `log` events.
    autoDisposeStreamSubscription(
      service.onLoggingEvent.listen(_handleDeveloperLogEvent),
    );
  }

  void _handleDeveloperLogEvent(Event e) {
    final service = serviceManager.service;

    final logRecord = _LogRecord(e.json!['logRecord']);

    String? loggerName =
        _valueAsString(InstanceRef.parse(logRecord.loggerName));
    if (loggerName == null || loggerName.isEmpty) {
      loggerName = 'log';
    }
    final level = logRecord.level;
    final messageRef = InstanceRef.parse(logRecord.message)!;
    String? summary = _valueAsString(messageRef);
    if (messageRef.valueAsStringIsTruncated == true) {
      summary = '${summary!}...';
    }
    final error = InstanceRef.parse(logRecord.error);
    final stackTrace = InstanceRef.parse(logRecord.stackTrace);

    final details = summary;
    Future<String> Function()? detailsComputer;

    // If the message string was truncated by the VM, or the error object or
    // stackTrace objects were non-null, we need to ask the VM for more
    // information in order to render the log entry. We do this asynchronously
    // on-demand using the `detailsComputer` Future.
    if (messageRef.valueAsStringIsTruncated == true ||
        _isNotNull(error) ||
        _isNotNull(stackTrace)) {
      detailsComputer = () async {
        // Get the full string value of the message.
        String result =
            await _retrieveFullStringValue(service, e.isolate!, messageRef);

        // Get information about the error object. Some users of the
        // dart:developer log call may pass a data payload in the `error`
        // field, encoded as a json encoded string, so handle that case.
        if (_isNotNull(error)) {
          if (error!.valueAsString != null) {
            final errorString =
                await _retrieveFullStringValue(service, e.isolate!, error);
            result += '\n\n$errorString';
          } else {
            // Call `toString()` on the error object and display that.
            final toStringResult = await service!.invoke(
              e.isolate!.id!,
              error.id!,
              'toString',
              <String>[],
              disableBreakpoints: true,
            );

            if (toStringResult is ErrorRef) {
              final errorString = _valueAsString(error);
              result += '\n\n$errorString';
            } else if (toStringResult is InstanceRef) {
              final str = await _retrieveFullStringValue(
                service,
                e.isolate!,
                toStringResult,
              );
              result += '\n\n$str';
            }
          }
        }

        // Get info about the stackTrace object.
        if (_isNotNull(stackTrace)) {
          result += '\n\n${_valueAsString(stackTrace)}';
        }

        return result;
      };
    }

    const severeIssue = 1000;
    final isError = level != null && level >= severeIssue ? true : false;

    log(
      LogDataV2(
        loggerName,
        details,
        e.timestamp,
        isError: isError,
        summary: summary,
        detailsComputer: detailsComputer,
      ),
    );
  }

  void log(LogDataV2 log) {
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

bool _isNotNull(InstanceRef? serviceRef) {
  return serviceRef != null && serviceRef.kind != 'Null';
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
///
/// The details can optionally be loaded lazily on first use. If this is the
/// case, this log entry will have a non-null `detailsComputer` field. After the
/// data is calculated, the log entry will be modified to contain the calculated
/// `details` data.
class LogDataV2 {
  LogDataV2(
    this.kind,
    this._details,
    this.timestamp, {
    this.summary,
    this.isError = false,
    this.detailsComputer,
  });

  final String kind;
  final int? timestamp;
  final bool isError;
  final String? summary;

  String? _details;
  Future<String> Function()? detailsComputer;

  static const prettyPrinter = JsonEncoder.withIndent('  ');

  String? get details => _details;

  bool get needsComputing => detailsComputer != null;

  Future<void> compute() async {
    _details = await detailsComputer!();
    detailsComputer = null;
  }

  String? prettyPrinted() {
    if (needsComputing) {
      return details;
    }

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

class LoggingScreenV2 extends StatelessWidget {
  const LoggingScreenV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => LoggingControllerV2(),
      child: const LoggingScreenBodyV2(),
    );
  }
}

class LoggingScreenBodyV2 extends StatefulWidget {
  const LoggingScreenBodyV2({super.key});

  @override
  State<LoggingScreenBodyV2> createState() => _LoggingScreenBodyV2State();
}

class _LoggingScreenBodyV2State extends State<LoggingScreenBodyV2>
    with AutoDisposeMixin {
  List<String> items = [];
  late List<LogDataV2> filteredLogs;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoggingControllerV2>(context);
    filteredLogs = controller.data;

    return LogsTableV2(filteredLogs);
  }
}

class LogsTableV2 extends StatelessWidget {
  LogsTableV2(this.filteredLogs, {super.key});

  final _verticalController = ScrollController();
  final List<LogDataV2> filteredLogs;

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
