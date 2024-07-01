import 'dart:math';

import 'package:flutterflow_debug_panel/src/widgets/flutter_flow_hover.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

typedef ModalButtonBuilder = Widget Function(
  Function({required String eventName}) toggleMenuCallback,
);
typedef ModalMenuBuilder = Widget Function(VoidCallback removeMenuCallback);

OverlayEntry? _lastAddedMenu;

enum ModalMenuAlignment {
  alignLeftSides,
  alignRightSides,
  alignCenters,
  alignRightTopOfScreen,
}

/// Button that shows a modal menu when tapped.
class ModalMenuButton extends StatefulWidget {
  const ModalMenuButton({
    super.key,
    required this.buttonBuilder,
    required this.menuBuilder,
    this.buttonBottomMargin = 10,
    this.menuAlignment = ModalMenuAlignment.alignRightSides,
    this.menuWidth,
    this.menuHeight,
    this.menuWidthOffset = 0.0,
    this.menuHeightOffset = 0.0,
    this.menuPosition,
    this.clickOutsideToDismiss = true,
    this.wrapInCard = true,
    this.removeLastMenu = true,
    this.onToggled,
  }) : assert(menuAlignment != ModalMenuAlignment.alignCenters ||
            menuWidth != null);

  final ModalButtonBuilder buttonBuilder;
  final ModalMenuBuilder menuBuilder;
  final double buttonBottomMargin;
  final ModalMenuAlignment menuAlignment;
  final double? menuWidth;
  final double? menuHeight;
  final double menuWidthOffset;
  final double menuHeightOffset;
  final Offset Function(double screenWidth, double screenHeight)? menuPosition;
  final bool clickOutsideToDismiss;
  final bool wrapInCard;
  final bool removeLastMenu;
  final Function(String eventName)? onToggled;

  @override
  ModalMenuButtonState createState() => ModalMenuButtonState();
}

class ModalMenuButtonState extends State<ModalMenuButton> {
  OverlayEntry? menu;
  bool get isHidden => menu == null || !menu!.mounted;
  bool get isShowing => !isHidden;

  final buttonKey = GlobalKey(debugLabel: 'modalMenuButton');

  @override
  void dispose() {
    removeMenu();
    super.dispose();
  }

  void removeMenu() {
    menu?.remove();
    menu = null;
    _lastAddedMenu = null;
  }

  bool get alignRight =>
      widget.menuAlignment == ModalMenuAlignment.alignRightSides;
  Offset computeMenuOffset({
    required double screenWidth,
    required double screenHeight,
  }) {
    if (widget.menuPosition != null) {
      return widget.menuPosition!(screenWidth, screenHeight);
    }
    final buttonBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final buttonSize = buttonBox.size;
    final topOfButton = buttonPosition.dy - widget.buttonBottomMargin;
    final bottomOfButton =
        buttonPosition.dy + buttonSize.height + widget.buttonBottomMargin;

    late double dx;
    late double dy;

    // Menu shows above button if height is provided and menu overflows screen.
    final overflowsBelow = widget.menuHeight != null &&
        bottomOfButton + widget.menuHeight! > screenHeight;
    final overflowsAbove =
        widget.menuHeight != null && topOfButton - widget.menuHeight! < 0;
    if (overflowsAbove && overflowsBelow) {
      dy = buttonPosition.dy - widget.menuHeight! / 2;
    } else if (overflowsBelow) {
      dy = buttonPosition.dy - widget.menuHeight! - widget.buttonBottomMargin;
    } else {
      dy = bottomOfButton;
    }

    // A few more adjustments if positions still leave the menu off-screen.
    final maxY = widget.menuHeight != null
        ? MediaQuery.sizeOf(context).height - widget.menuHeight!
        : double.infinity;
    dy = min(max(0, dy), maxY);

    switch (widget.menuAlignment) {
      case ModalMenuAlignment.alignLeftSides:
        dx = buttonPosition.dx;
        break;
      case ModalMenuAlignment.alignRightSides:
        dx = screenWidth - (buttonPosition.dx + buttonSize.width);
        break;
      case ModalMenuAlignment.alignCenters:
        if (widget.menuWidth == null) {
          dx = buttonPosition.dx;
          break;
        }
        dx = buttonPosition.dx - widget.menuWidth! / 2 + buttonSize.width / 2;
        break;
      case ModalMenuAlignment.alignRightTopOfScreen:
        // Align the menu to the right of the button and start at the top of
        // the screen.
        dx = buttonPosition.dx + buttonSize.width;
        dy = 0;
        break;
    }

    return Offset(dx - widget.menuWidthOffset, dy - widget.menuHeightOffset);
  }

  Widget buildMenu(BuildContext context) {
    Widget menu = WebViewAware(
      child: widget.menuBuilder(removeMenu),
    );
    if (widget.wrapInCard) {
      menu = Card(
        color: Colors.transparent,
        margin: const EdgeInsets.fromLTRB(3.0, 0.0, 3.0, 3.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: WebViewAware(
          child: widget.menuBuilder(removeMenu),
        ),
      );
    }
    final menuOffset = computeMenuOffset(
      screenWidth: MediaQuery.sizeOf(context).width,
      screenHeight: MediaQuery.sizeOf(context).height,
    );
    return Stack(
      children: [
        if (widget.clickOutsideToDismiss)
          Positioned.fill(
            child: GestureDetector(
              onTap: removeMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
        Positioned(
          top: menuOffset.dy,
          left: alignRight ? null : menuOffset.dx,
          right: alignRight ? menuOffset.dx : null,
          child: menu,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: buttonKey,
      child: widget.buttonBuilder(
        ({required eventName}) => toggleMenu(
          eventName: eventName,
          removeLastMenu: widget.removeLastMenu,
        ),
      ),
    );
  }

  bool toggleMenu({required String eventName, bool removeLastMenu = true}) {
    if (isHidden) {
      if (removeLastMenu) {
        _lastAddedMenu?.remove();
      }
      _lastAddedMenu = menu = OverlayEntry(builder: buildMenu);
      widget.onToggled?.call(eventName);
      Overlay.of(context).insert(menu!);
      return true;
    } else {
      if (removeLastMenu) {
        removeMenu();
      }
      return false;
    }
  }
}

class ModalMenu extends StatelessWidget {
  const ModalMenu({
    super.key,
    required this.child,
    this.width = 200.0,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
            color: context.theme.panelBorderColor,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: child,
      );
}

class ModalMenuItem extends StatelessWidget {
  const ModalMenuItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconData,
    required this.color,
    this.isTop = false,
    this.isBottom = false,
    this.width,
    this.isProcess = false,
  });

  final Function() onTap;
  final String text;
  final IconData iconData;
  final Color color;
  final bool isTop;
  final bool isBottom;
  final double? width;
  final bool isProcess;

  @override
  Widget build(BuildContext context) => FlutterFlowHoverWidget(
        width: width,
        backgroundColor: context.theme.navPanelColor,
        hoverBackgroundColor: context.theme.dark400,
        borderRadius: BorderRadius.only(
          topLeft: isTop ? const Radius.circular(8.0) : Radius.zero,
          topRight: isTop ? const Radius.circular(8.0) : Radius.zero,
          bottomLeft: isBottom ? const Radius.circular(8.0) : Radius.zero,
          bottomRight: isBottom ? const Radius.circular(8.0) : Radius.zero,
        ),
        onTap: isProcess ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 18.0,
                color: color,
              ),
              const SizedBox(width: 10.0),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );
}
