import 'dart:async';

import 'package:flutterflow_debug_panel/src/utils/ff_utils.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// A widget that displays a link text with an optional icon.
class LinkText extends StatelessWidget {
  /// Creates a widget that displays a text having an URL.
  ///
  /// - [text] parameter is required and specifies the text to be displayed.
  /// - [url] parameter specifies the URL to be opened when the link is tapped.
  /// - [iconSize] parameter specifies the size of the icon.
  /// - [textStyle] parameter specifies the style of the text.
  /// - [maxLines] parameter specifies the maximum number of lines for the text.
  /// - [textOverflow] parameter specifies the text overflow behavior.
  /// - [idleContainerColor] parameter specifies the color of the container when it is idle.
  /// - [hoverContainerColor] parameter specifies the color of the container when it is hovered.
  /// - [isIconAlwaysVisible] parameter specifies whether the icon should always be visible.
  /// - [onOpen] parameter specifies the callback function to be called when the link is opened.
  const LinkText(
    this.text, {
    super.key,
    required this.url,
    this.iconSize = 13.0,
    this.textStyle,
    this.maxLines,
    this.textOverflow,
    this.idleContainerColor,
    this.hoverContainerColor,
    this.isIconAlwaysVisible = true,
    this.onOpen,
  });

  final String text;
  final String? url;
  final double iconSize;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final Color? idleContainerColor;
  final Color? hoverContainerColor;
  final bool isIconAlwaysVisible;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) => ActionText(
        text,
        maxLines: maxLines,
        textOverflow: textOverflow,
        hasActionText: url != null,
        iconData: Icons.open_in_new_rounded,
        iconSize: iconSize,
        textStyle: textStyle,
        idleContainerColor: idleContainerColor,
        hoverContainerColor: hoverContainerColor,
        isIconAlwaysVisible: isIconAlwaysVisible,
        onTap: () {
          openUrl(url!);
          onOpen?.call();
        },
      );
}

/// A widget that displays a copyable text with an optional icon.
class CopyText extends StatelessWidget {
  /// Creates a widget that displays a copyable text.
  ///
  /// - [text] parameter is required and specifies the text to be displayed.
  /// - [copyText] parameter specifies the text to be copied when the copy icon is tapped.
  /// - [iconSize] parameter specifies the size of the icon.
  /// - [textStyle] parameter specifies the style of the text.
  /// - [maxLines] parameter specifies the maximum number of lines for the text.
  /// - [textOverflow] parameter specifies the text overflow behavior.
  /// - [copySnackbarMessage] parameter specifies the message to be shown in the snackbar after copying.
  /// - [idleContainerColor] parameter specifies the color of the container when it is idle.
  /// - [hoverContainerColor] parameter specifies the color of the container when it is hovered.
  /// - [isIconAlwaysVisible] parameter specifies whether the icon should always be visible.
  /// - [onCopy] parameter specifies the callback function to be called when the action is performed.
  const CopyText(
    this.text, {
    super.key,
    required this.copyText,
    this.iconSize = 13.0,
    this.textStyle,
    this.maxLines,
    this.textOverflow,
    this.copySnackbarMessage,
    this.idleContainerColor,
    this.hoverContainerColor,
    this.isIconAlwaysVisible = true,
    this.onCopy,
  });

  final String text;
  final String? copyText;
  final double iconSize;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final String? copySnackbarMessage;
  final Color? idleContainerColor;
  final Color? hoverContainerColor;
  final bool isIconAlwaysVisible;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) => ActionText(
        text,
        maxLines: maxLines,
        showCheckMark: true,
        textOverflow: textOverflow,
        hasActionText: copyText != null,
        iconData: Icons.copy_rounded,
        iconSize: iconSize,
        textStyle: textStyle,
        idleContainerColor: idleContainerColor,
        hoverContainerColor: hoverContainerColor,
        isIconAlwaysVisible: isIconAlwaysVisible,
        onTap: () {
          Clipboard.setData(ClipboardData(text: copyText!));
          onCopy?.call();
          showSnackbar(context, copySnackbarMessage!);
          // showSnackBar(
          //   context: context,
          //   message: copySnackbarMessage!,
          //   type: SnackBarType.success,
          // );
        },
      );
}

/// A widget that represents an action text with optional icon, when clicked
/// can show a checkmark.
///
/// The [ActionText] widget is used to display a text that can be tapped to trigger an action.
/// It can also have an optional icon and checkmark to provide additional visual cues.
///
/// Example usage:
/// ```dart
/// ActionText(
///   'Click me',
///   onTap: () {
///     // Perform action
///   },
///   iconData: Icons.arrow_forward,
///   showCheckMark: true,
/// )
/// ```
class ActionText extends StatefulWidget {
  /// Creates a [ActionText] widget.
  ///
  /// - [text] is required and represents the text to be displayed.
  /// - [onTap] is required and represents the callback function to be called when the text is tapped.
  /// - [hasActionText] is optional and determines whether the text is displayed as an action text.
  /// - [iconData] is optional and represents the icon to be displayed alongside the text.
  /// - [iconSize] is optional and represents the size of the icon.
  /// - [textStyle] is optional and represents the style of the text.
  /// - [maxLines] is optional and represents the maximum number of lines for the text.
  /// - [textOverflow] is optional and determines how the text should be handled if it overflows.
  /// - [idleContainerColor] is optional and represents the color of the container when it is idle.
  /// - [hoverContainerColor] is optional and represents the color of the container when it is hovered.
  /// - [isIconAlwaysVisible] is optional and determines whether the icon is always visible.
  /// - [showCheckMark] is optional and determines whether to show a checkmark icon.
  const ActionText(
    this.text, {
    super.key,
    required this.onTap,
    this.hasActionText = true,
    this.iconData,
    this.iconSize = 13.0,
    this.textStyle,
    this.maxLines,
    this.textOverflow,
    this.idleContainerColor,
    this.hoverContainerColor,
    this.isIconAlwaysVisible = true,
    this.showCheckMark = false,
  });

  /// The text to be displayed.
  final String text;

  /// The callback function to be called when the text is tapped.
  final VoidCallback onTap;

  /// Determines whether there's a text to be used as in the action.
  final bool hasActionText;

  /// The icon to be displayed alongside the text.
  ///
  /// If set to `null`, no icon will be displayed.
  /// If set to a valid [IconData], the specified icon will be displayed.
  final IconData? iconData;

  /// The size of the icon.
  ///
  /// The default value is `13.0`.
  final double iconSize;

  /// The style of the text.
  ///
  /// If set to `null`, the default text style will be used.
  final TextStyle? textStyle;

  /// The maximum number of lines for the text.
  ///
  /// If set to `null`, the text will be displayed in a single line.
  final int? maxLines;

  /// Determines how the text should be handled if it overflows.
  ///
  /// If set to `null`, the text will be clipped if it overflows.
  /// - If set to [TextOverflow.ellipsis], the text will be truncated with an ellipsis if it overflows.
  /// - If set to [TextOverflow.fade], the text will be faded out if it overflows.
  final TextOverflow? textOverflow;

  /// The color of the container when it is idle.
  ///
  /// If set to `null`, the default container color will be used.
  final Color? idleContainerColor;

  /// The color of the container when it is hovered.
  ///
  /// If set to `null`, the default hover container color will be used.
  final Color? hoverContainerColor;

  /// Determines whether the icon is always visible.
  ///
  /// If set to `true`, the icon will always be visible.
  /// If set to `false`, the icon will be hidden when the text is not hovered.
  final bool isIconAlwaysVisible;

  /// Determines whether to show a checkmark icon for a certain short duration
  /// after the action is performed.
  ///
  /// If set to `true`, a checkmark icon will be displayed.
  /// If set to `false`, no checkmark icon will be displayed.
  final bool showCheckMark;

  @override
  State<ActionText> createState() => _ActionTextState();
}

class _ActionTextState extends State<ActionText> {
  bool _isHovering = false;

  Timer? _timer;
  int _start = 1;

  void startTimer() => _timer = Timer.periodic(
        1.seconds,
        (timer) => _start == 0 ? setState(() => timer.cancel()) : _start--,
      );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idleContainerColor = widget.idleContainerColor;
    final hoverContainerColor =
        widget.hoverContainerColor ?? widget.idleContainerColor;
    final containerColor =
        _isHovering ? hoverContainerColor : idleContainerColor;
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: widget.hasActionText
          ? () {
              if (widget.showCheckMark) {
                setState(startTimer);
              }
              widget.onTap();
            }
          : null,
      onHover: (value) => setState(() => _isHovering = value),
      child: Container(
        decoration: BoxDecoration(
          color: containerColor?.withOpacity(0.4),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(
            color: containerColor ?? Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 1,
            horizontal: 4,
          ),
          child: AnimatedSize(
            alignment: Alignment.centerLeft,
            duration: 300.millis,
            curve: Curves.easeInOut,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    widget.text,
                    overflow: widget.textOverflow,
                    maxLines: widget.maxLines,
                    style: widget.textStyle ??
                        productSans(
                          context,
                          size: 12,
                          weight: FontWeight.w400,
                          color: context.theme.white,
                        ),
                  ),
                ),
                if (widget.hasActionText &&
                    (_isHovering || widget.isIconAlwaysVisible)) ...[
                  const SizedBox(width: 4.0),
                  Icon(
                    (_timer?.isActive ?? false)
                        ? Icons.check_rounded
                        : widget.iconData,
                    size: widget.iconSize,
                    color: (_timer?.isActive ?? false)
                        ? context.theme.greenAccent
                        : context.theme.white
                            .withOpacity(_isHovering ? 0.8 : 0.5),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens a URL in a new tab. Use Navigator if navigating within FF.
Future<void> openUrl(String url) async {
  var uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
    );
  }
}
