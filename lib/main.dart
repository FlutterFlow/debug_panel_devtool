import 'package:debug_panel_devtool/pages/debug_panel_page.dart';
import 'package:debug_panel_devtool/src/utils/debug_utils.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevToolsExtension(
      child: ChangeNotifierProvider(
        create: (context) => variableDebugData,
        child: DebugVariablesPanel(
          onEvent: (name, params) {
            if (kDebugMode) {
              debugPrint('$name, $params');
            }
          },
        ),
      ),
    );
  }
}
