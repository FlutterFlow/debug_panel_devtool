import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/utils/ff_icons.dart';
import 'package:debug_panel_devtool/src/utils/ff_utils.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';

class PanelSearchWidget extends StatefulWidget {
  const PanelSearchWidget({
    super.key,
    required this.focusNode,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.fieldKey,
    this.width,
    this.autofocus = false,
    this.forPanelSearch = true,
    this.isDense = false,
    this.textInputAction = TextInputAction.done,
    this.contentPadding,
    this.height,
    this.focusColor,
    this.suffixIcons = const [],
  });

  final FocusNode? focusNode;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final GlobalKey? fieldKey;
  final double? width;
  final bool autofocus;
  final bool forPanelSearch;
  final bool isDense;
  final TextInputAction textInputAction;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final Color? focusColor;
  final List<Widget> suffixIcons;

  @override
  State<PanelSearchWidget> createState() => _PanelSearchWidgetState();
}

class _PanelSearchWidgetState extends State<PanelSearchWidget> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          height: widget.height ?? 42,
          color: context.theme.dark400,
          child: TextField(
            onTap: null,
            textInputAction: widget.textInputAction,
            key: widget.fieldKey,
            autofocus: widget.autofocus,
            focusNode: widget.focusNode,
            controller: widget.controller,
            cursorColor: context.theme.primary,
            cursorWidth: 2.0,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding ??
                  EdgeInsets.only(
                    left: kPadding16px,
                    bottom: widget.isDense ? 0 : kPadding8px,
                  ),
              hintText: widget.hintText,
              hintStyle: context.theme.panelTextStyle2.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: kFontSize14px,
              ),
              isDense: widget.isDense,
              border: widget.forPanelSearch
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
              focusedBorder: widget.forPanelSearch
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.focusColor ?? context.theme.primary,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.zero,
                    )
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: widget.focusColor ?? context.theme.primary,
                        width: 3.0,
                      ),
                    ),
              filled: true,
              fillColor: (widget.forPanelSearch &&
                      (widget.focusNode?.hasFocus ?? false))
                  ? widget.focusColor ?? context.theme.primary.withOpacity(0.15)
                  : context.theme.dark400,
              focusColor: Colors.white,
              prefixIcon: Icon(
                FFIcons.search,
                color: (widget.focusNode?.hasFocus ?? false)
                    ? context.theme.white
                    : context.theme.panelTextColor2,
                size: kIconSize16px,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: widget.controller.text.isNotEmpty
                        ? () => setState(() {
                              widget.controller.clear();
                              widget.onChanged('');
                            })
                        : null,
                    child: Icon(
                      Icons.close_rounded,
                      color: widget.controller.text.isNotEmpty
                          ? context.theme.panelTextColor2
                          : Colors.transparent,
                      size: kIconSize20px,
                    ),
                  ),
                  ...widget.suffixIcons,
                  const SizedBox(),
                ].divide(const SizedBox(width: kPadding8px)),
              ),
            ),
            style: context.theme.panelTextStyle2.copyWith(
              color: context.theme.white,
              fontSize: kFontSize14px,
            ),
            onChanged: widget.onChanged,
          ),
        ),
      );
}
