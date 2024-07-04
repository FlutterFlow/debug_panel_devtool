import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutterflow_debug_panel/src/utils/debug_utils.dart';
import 'package:flutterflow_debug_panel/src/widgets/debug_variables_panel.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vm_service/vm_service.dart';

class DebugPanelPage extends StatefulWidget {
  const DebugPanelPage({super.key});

  @override
  State<DebugPanelPage> createState() => _DebugPanelPageState();
}

class _DebugPanelPageState extends State<DebugPanelPage> {
  late final StreamSubscription extensionEventSubscription;
  late final VmService vmService;

  /// Handles the application event.
  Future<void> _appEventHandler() async {
    vmService = await serviceManager.onServiceAvailable;
    extensionEventSubscription = vmService.onExtensionEvent.listen((event) {
      // Check whether it's a FlutterFlow debug data event.
      final isUpdateEvent =
          event.extensionKind == 'ext.flutterflow_debug_panel.updateDebugData';
      if (!isUpdateEvent) return;

      deserializeDebugEvent(event.extensionData!.data['data'] as String);
    });
  }

  @override
  void initState() {
    super.initState();
    // Disable the browser's default context menu, so that we can show our
    // custom right-click menu on the variables.
    BrowserContextMenu.disableContextMenu();
    _appEventHandler();
  }

  @override
  void dispose() {
    extensionEventSubscription.cancel();
    vmService.dispose();
    // Re-enable the browser's default context menu.
    BrowserContextMenu.enableContextMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => variableDebugData,
        child: DebugVariablesPanel(
          listGradientColor: Theme.of(context).scaffoldBackgroundColor,
          onEvent: (name, params) {
            if (kDebugMode) {
              debugPrint('$name, $params');
            }
          },
        ),
      );
}
