import 'dart:math';

import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/utils/ff_utils.dart';
import 'package:debug_panel_devtool/src/widgets/flutter_flow_button.dart';
import 'package:debug_panel_devtool/src/widgets/panel_search.dart';
import 'package:debug_panel_devtool/src/widgets/property_name.dart';
import 'package:debug_panel_devtool/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_search/text_search.dart';

const _kDefaultPanelSearchHeight = 42.0;
const _kDefaultItemHeight = 48.0;
const _kDefaultNumItemsToShow = 5;
const _kDefaultDividerHeight = 2.0;

/// A widget for searchable multiselect dropdown.
class SearchableMultiselectDropdownProperty<T> extends StatefulWidget {
  const SearchableMultiselectDropdownProperty(
    this.onUpdate, {
    super.key,
    required this.currentValue,
    required this.nameToValue,
    required this.propertyLabel,
    this.buttonBuilder,
    this.nameToDisplayItemBuilder,
    this.defaultValue,
    this.selectableOptions,
    this.emptyItemsBuilder,
    this.tooltipText,
    this.addLabel = true,
    this.searchHintText,
    this.noItemSelectedText,
    this.noItemsFoundText,
    this.optionItemHeight,
    this.textWidgetBuilder,
    this.width,
    this.height,
    this.buttonOptions,
    this.numItemsToShow,
    this.showSearchPanel = true,
    this.displayItemAlignment = AxisDirection.right,
  });

  final Function(List<dynamic>) onUpdate;
  final List<T> currentValue;
  final Map<String, T> nameToValue;
  final String propertyLabel;
  final Widget Function(BuildContext, VoidCallback onTap, Function(T) onRemove)?
      buttonBuilder;
  final Map<String, Widget Function(BuildContext)>? nameToDisplayItemBuilder;
  final String? defaultValue;
  final Set<String>? selectableOptions;
  final WidgetBuilder? emptyItemsBuilder;
  final String? tooltipText;
  final bool addLabel;
  final String? searchHintText;
  final String? noItemSelectedText;
  final String? noItemsFoundText;
  final double? optionItemHeight;
  final double? width;
  final double? height;
  final Widget Function(String name)? textWidgetBuilder;
  final int? numItemsToShow;
  final bool showSearchPanel;
  final AxisDirection displayItemAlignment;
  final FlutterFlowButtonOptions? buttonOptions;

  @override
  State<SearchableMultiselectDropdownProperty> createState() =>
      _SearchableMultiselectDropdownPropertyState();
}

class _SearchableMultiselectDropdownPropertyState<T>
    extends State<SearchableMultiselectDropdownProperty<T>> {
  final layerLink = LayerLink();
  late OverlayEntry entry;

  double get listHeight =>
      (widget.showSearchPanel ? _kDefaultPanelSearchHeight : 0.01) +
      ((widget.optionItemHeight ?? _kDefaultItemHeight) +
              _kDefaultDividerHeight) *
          (widget.numItemsToShow ??
              min(widget.nameToValue.length, _kDefaultNumItemsToShow));

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // Show menu in direction with the minimum overflow (aka most space).
    // If both have overflow, prefer to show below so search bar is showing.
    final screenHeight = MediaQuery.sizeOf(context).height;
    final yButtonPosition = renderBox.localToGlobal(Offset.zero).dy;
    final buttonHeightEstimate =
        widget.buttonOptions?.height ?? widget.height ?? 34.0;
    final showMenuAboveButton =
        yButtonPosition + buttonHeightEstimate + 8 + listHeight >
                screenHeight &&
            yButtonPosition - listHeight - 8 > 0;
    final menuYOffset =
        showMenuAboveButton ? -(listHeight + 8) : size.height - 16;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, menuYOffset),
          child: buildOverlay(),
        ),
      ),
    );
    overlay.insert(entry);
  }

  void onItemRemove(T removedValue) {
    final updatedList = (widget.currentValue as List)
        .map((val) => val as T)
        .toList()
      ..remove(removedValue);
    widget.onUpdate(updatedList);
  }

  Widget buildOverlay() => TextFieldTapRegion(
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8.0),
          color: context.theme.panelColor,
          child: OptionSelectorOverlay<T>(
            overlayEntry: entry,
            onSelected: (val) {
              final updatedList =
                  (widget.currentValue as List).map((val) => val as T).toList();
              updatedList.contains(val)
                  ? updatedList.remove(val)
                  : updatedList.add(val);
              widget.onUpdate(updatedList);
            },
            nameToValue: widget.nameToValue,
            selectedValues: widget.currentValue,
            selectableOptions: widget.selectableOptions,
            defaultValue: widget.defaultValue,
            searchHintText: widget.searchHintText,
            noItemsFoundText: widget.noItemsFoundText,
            optionItemHeight: widget.optionItemHeight,
            textWidgetBuilder: widget.textWidgetBuilder,
            numItemsToShow: widget.numItemsToShow,
            emptyItemsBuilder: widget.emptyItemsBuilder,
            nameToDisplayItemBuilder: widget.nameToDisplayItemBuilder,
            showSearchPanel: widget.showSearchPanel,
            displayItemAlignment: widget.displayItemAlignment,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final buttonBuilder = widget.buttonBuilder ??
        (context, onTap, onRemove) {
          final selectedValues = widget.currentValue as List;
          return GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              // height: kHeight36px,
              decoration: BoxDecoration(
                color: context.theme.dark800,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.theme.panelBorderColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    const SizedBox(width: kPadding8px),
                    selectedValues.isNotEmpty
                        ? Expanded(
                            child: Wrap(
                              runSpacing: 4,
                              children: selectedValues.listMap(
                                (t) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  margin: const EdgeInsets.only(right: 4),
                                  decoration: BoxDecoration(
                                    color: context.theme.dark300,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.nameToValue.entries
                                        .firstWhere(
                                          (e) => e.value == t,
                                        )
                                        .key,
                                    style: productSans(
                                      context,
                                      size: kFontSize12px,
                                      color: context.theme.primaryText,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(
                            widget.noItemSelectedText ?? 'Select an item...',
                            style: productSans(
                              context,
                              size: kFontSize14px,
                              color: context.theme.panelTextColor1,
                            ),
                          ),
                    if (selectedValues.isEmpty) const Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: context.theme.panelTextColor1,
                    ),
                    const SizedBox(width: kPadding4px),
                  ],
                ),
              ),
            ),
          );
        };
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.addLabel)
          PropertyNameWidget(
            name: widget.propertyLabel,
            tooltipText: widget.tooltipText,
          ),
        CompositedTransformTarget(
          link: layerLink,
          child: InkWell(
            onTap: showOverlay,
            child: buttonBuilder(context, showOverlay, onItemRemove),
          ),
        ),
      ],
    );
  }
}

class OptionSelectorOverlay<T> extends StatefulWidget {
  const OptionSelectorOverlay({
    super.key,
    required this.overlayEntry,
    required this.onSelected,
    required this.nameToValue,
    required this.selectedValues,
    this.nameToDisplayItemBuilder,
    this.defaultValue,
    this.selectableOptions,
    this.emptyItemsBuilder,
    this.searchHintText,
    this.noItemsFoundText,
    this.optionItemHeight,
    this.textWidgetBuilder,
    this.numItemsToShow,
    this.showSearchPanel = true,
    this.displayItemAlignment = AxisDirection.right,
  });

  final OverlayEntry overlayEntry;
  final Function(T) onSelected;
  final Map<String, T> nameToValue;
  final List<T> selectedValues;
  final Map<String, WidgetBuilder>? nameToDisplayItemBuilder;
  final Set<String>? selectableOptions;
  final WidgetBuilder? emptyItemsBuilder;
  final String? defaultValue;
  final String? searchHintText;
  final String? noItemsFoundText;
  final double? optionItemHeight;
  final Widget Function(String name)? textWidgetBuilder;
  final int? numItemsToShow;
  final AxisDirection displayItemAlignment;
  final bool showSearchPanel;

  @override
  State<OptionSelectorOverlay> createState() => _OptionSelectorOverlayState();
}

class _OptionSelectorOverlayState<T> extends State<OptionSelectorOverlay<T>> {
  final GlobalKey<FormFieldState<String>> searchFieldKey =
      GlobalKey<FormFieldState<String>>(debugLabel: 'optionSelectorFieldKey');
  final keyboardFocusNode = FocusNode();
  final FocusNode searchFocus = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final scrollController = ScrollController();
  late List<String> searchedOptions;
  late int selectedIndex;
  var scrollTopIndex = 0;

  double get itemHeight => widget.optionItemHeight ?? _kDefaultItemHeight;
  int get numItemsToShow => widget.numItemsToShow ?? _kDefaultNumItemsToShow;
  final dividerHeight = _kDefaultDividerHeight;

  double get listHeight =>
      _kDefaultPanelSearchHeight +
      (itemHeight + dividerHeight) * numItemsToShow;

  T value(String name) => widget.nameToValue[name]!;

  @override
  void initState() {
    searchedOptions = widget.nameToValue.keys.toList();
    searchFocus.addListener(() {
      if (!searchFocus.hasFocus) {
        widget.overlayEntry.remove();
      }
    });
    selectedIndex = widget.defaultValue != null
        ? searchedOptions.indexOf(widget.defaultValue!)
        : -1;
    super.initState();
    searchFocus.requestFocus();
  }

  @override
  void dispose() {
    searchFocus.dispose();
    searchController.dispose();
    keyboardFocusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      autofocus: true,
      focusNode: keyboardFocusNode,
      onKeyEvent: (event) {
        final logicalKey = event.logicalKey;
        final keyboard = HardwareKeyboard.instance;

        if (event is KeyDownEvent) {
          if (logicalKey == LogicalKeyboardKey.escape) {
            searchFocus.unfocus();
            return;
          }

          if (logicalKey == LogicalKeyboardKey.enter && selectedIndex > -1) {
            searchFocus.unfocus();
            widget.onSelected(
                widget.nameToValue[searchedOptions[selectedIndex]] as T);
            return;
          }

          final goDown = logicalKey == LogicalKeyboardKey.arrowDown ||
              (!keyboard.isShiftPressed &&
                  logicalKey == LogicalKeyboardKey.tab);
          final goUp = logicalKey == LogicalKeyboardKey.arrowUp ||
              (keyboard.isShiftPressed && logicalKey == LogicalKeyboardKey.tab);
          selectedIndex += goDown ? 1 : 0;
          selectedIndex -= goUp ? 1 : 0;
          selectedIndex =
              max(min(searchedOptions.length - 1, selectedIndex), 0);
          if (selectedIndex >= scrollTopIndex + numItemsToShow) {
            scrollTopIndex = selectedIndex - numItemsToShow + 1;
            scrollController
                .jumpTo(scrollTopIndex * (itemHeight + dividerHeight));
          } else if (selectedIndex < scrollTopIndex) {
            scrollTopIndex = selectedIndex;
            scrollController
                .jumpTo(scrollTopIndex * (itemHeight + dividerHeight));
          }

          setState(() {});
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: searchedOptions.isEmpty ? 1.5 * listHeight : listHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              width: 2,
              color: context.theme.dark200,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: widget.showSearchPanel ? 1 : 0.001,
                  child: SizedBox(
                    height: widget.showSearchPanel ? null : 0.01,
                    child: PanelSearchWidget(
                      fieldKey: searchFieldKey,
                      textInputAction: TextInputAction.none,
                      autofocus: true,
                      width: 270.0,
                      isDense: true,
                      focusNode: searchFocus,
                      controller: searchController,
                      onChanged: (val) {
                        final optionSearch = TextSearch(widget.nameToValue.keys
                            .map((name) =>
                                TextSearchItem.fromTerms(name, [name]))
                            .toList());
                        setState(
                          () => searchedOptions = optionSearch
                              .search(val)
                              .map((e) => e.object)
                              .toList(),
                        );
                      },
                      hintText: widget.searchHintText ?? '',
                    ),
                  ),
                ),
                if (searchedOptions.isEmpty)
                  Flexible(
                    child: widget.emptyItemsBuilder != null &&
                            searchController.text.isEmpty
                        ? widget.emptyItemsBuilder!(context)
                        : Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              widget.noItemsFoundText ?? 'No items found',
                              style: context.theme.subtitle2,
                            ),
                          ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: searchedOptions.length,
                      itemBuilder: (context, index) {
                        final name = searchedOptions[index];
                        return _OverlaySelectorItem(
                          name: name,
                          onSelected: (name) {
                            widget.onSelected(widget.nameToValue[name] as T);
                            searchFocus.unfocus();
                          },
                          isChosen: widget.selectedValues
                              .contains(widget.nameToValue[name]),
                          isSelected: selectedIndex == index,
                          canBeSelected: widget.selectableOptions == null ||
                              widget.selectableOptions!.contains(name),
                          height: itemHeight,
                          textWidgetBuilder: widget.textWidgetBuilder,
                          displayItemBuilder:
                              widget.nameToDisplayItemBuilder?[name],
                          displayItemAlignment: widget.displayItemAlignment,
                        );
                      },
                      separatorBuilder: (context, index) => Container(
                        height: dividerHeight,
                        width: double.maxFinite,
                        color: context.theme.dark200,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlaySelectorItem extends StatefulWidget {
  const _OverlaySelectorItem({
    required this.name,
    required this.onSelected,
    required this.isChosen,
    required this.isSelected,
    required this.canBeSelected,
    required this.height,
    this.textWidgetBuilder,
    this.displayItemBuilder,
    this.displayItemAlignment = AxisDirection.right,
  });

  final String name;
  final Function(String) onSelected;
  final bool isChosen;
  final bool isSelected;
  final bool canBeSelected;
  final double height;
  final Widget Function(String name)? textWidgetBuilder;
  final WidgetBuilder? displayItemBuilder;
  final AxisDirection displayItemAlignment;

  @override
  State<_OverlaySelectorItem> createState() => _OverlaySelectorItemState();
}

class _OverlaySelectorItemState<T> extends State<_OverlaySelectorItem> {
  bool isHovering = false;
  bool get canBeSelected => widget.canBeSelected;

  @override
  Widget build(BuildContext context) {
    final textWidget = widget.textWidgetBuilder != null
        ? widget.textWidgetBuilder!(widget.name)
        : Text(
            widget.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: canBeSelected
                  ? context.theme.secondaryText
                  : context.theme.errorColor,
              fontFamily: 'Product Sans',
              fontWeight: FontWeight.normal,
              fontStyle: canBeSelected ? FontStyle.normal : FontStyle.italic,
              fontSize: kFontSize13px,
            ),
          );

    return InkWell(
      onTap: canBeSelected ? () => widget.onSelected(widget.name) : null,
      hoverColor: context.theme.dark200,
      child: Container(
        height: widget.height,
        color: widget.isSelected ? context.theme.dark300 : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment:
                widget.displayItemAlignment == AxisDirection.right
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.start,
            children: [
              textWidget,
              const Spacer(),
              Checkbox(
                value: widget.isChosen,
                activeColor: context.theme.primary,
                side: BorderSide(
                  color: context.theme.dark300,
                  width: 2,
                ),
                checkColor: Colors.white,
                fillColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? context.theme.primary
                      : Colors.transparent,
                ),
                onChanged: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
