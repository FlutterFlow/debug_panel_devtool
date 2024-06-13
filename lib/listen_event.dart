
import 'package:devtools_extensions/api.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';

class ListeningForDevToolsEventExample extends StatefulWidget {
  const ListeningForDevToolsEventExample({super.key});

  @override
  State<ListeningForDevToolsEventExample> createState() =>
      _ListeningForDevToolsEventExampleState();
}

class _ListeningForDevToolsEventExampleState
    extends State<ListeningForDevToolsEventExample> {
  String? message;

  @override
  void initState() {
    super.initState();
    // Example of the devtools extension registering a custom handler for an
    // event coming from DevTools.
    extensionManager.registerEventHandler(
      DevToolsExtensionEventType.unknown,
      // This callback will be called when the DevTools extension receives an
      // event of type [DevToolsExtensionEventType.unknown] from DevTools.
      (event) {
        setState(() {
          message = event.data?.toString() ?? 'unknown event';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text('Received an unknown event from DevTools: $message');
  }
}