import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

export 'package:debug_panel_devtool/src/themes/flutter_flow_theme.dart'
    show TextStyleHelper;

extension AppThemeExtensions on BuildContext {
  AppThemeModel get theme => AppTheme.of(this);
}

TextStyle productSans(
  BuildContext context, {
  double size = 16,
  Color? color,
  FontWeight weight = FontWeight.normal,
}) =>
    TextStyle(
      fontFamily: 'Product Sans',
      color: color ?? context.theme.primaryText,
      fontSize: size,
      fontWeight: weight,
    );

TextStyle monospace(
  BuildContext context, {
  double size = 16,
  Color? color,
  FontWeight weight = FontWeight.normal,
}) =>
    TextStyle(
      fontFamily: 'monospace',
      color: color ?? context.theme.primaryText,
      fontSize: size,
      fontWeight: weight,
    );

abstract class AppThemeModel with FFTheme {
  bool get isLightMode;

  Color get white;
  Color get lineColor;
  Color get overlay;
  Color get dark350;
  Color get primary600;
  Color get overlay0;
  Color get dark300;
  Color get hoverColor;
  Color get messageRed;
  Color get greenAccent;
  Color get panelBorderColor;
  Color get panelTextColor1;
  Color get panelColor;
  Color get dark200;
  Color get dark400;
  Color get dark800;
  Color get navPanelColor;
  Color get buttonColor;
  Color get workspaceButtonColor;
  Color get tooltip;
  Color get panelTextColor2;
  Color get errorColor => kErrorColor;

  TextStyle get subtitle2 => TextStyle(
        fontFamily: 'Product Sans',
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: kFontSize14px,
        overflow: TextOverflow.ellipsis,
      );
  TextStyle panelTextStyle(Color color) => TextStyle(
        fontFamily: 'Product Sans',
        fontSize: kFontSize12px,
        color: color,
      );
  TextStyle get panelTextStyle2 => TextStyle(
        fontFamily: 'Product Sans',
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: kFontSize14px,
        overflow: TextOverflow.ellipsis,
      );
  TextStyle get propertyName => TextStyle(
        fontFamily: 'Product Sans',
        color: secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: kFontSize13px,
      );
}

class AppTheme {
  static DeviceSize deviceSize = DeviceSize.mobile;

  static of(BuildContext context) {
    deviceSize = getDeviceSize(context);
    return Theme.of(context).brightness == Brightness.dark
        ? AppDarkModeTheme(deviceSize)
        : AppLightModeTheme(deviceSize);
  }
}

class AppLightModeTheme extends AppThemeModel {
  AppLightModeTheme(this.deviceSize);

  final DeviceSize deviceSize;

  @override
  bool get isLightMode => true;

  @override
  Color get white => Colors.black;

  @override
  Color get primary => const Color(0xFF4B39EF);

  @override
  Color get secondary => const Color(0xFF39D2C0);

  @override
  Color get tertiary => const Color(0xFFEE8B60);

  @override
  Color get alternate => const Color(0xFFE0E3E7);

  @override
  Color get primaryText => const Color(0xFF14181B);

  @override
  Color get secondaryText => const Color(0xFF57636C);

  @override
  Color get primaryBackground => const Color(0xFFF1F4F8);

  @override
  Color get secondaryBackground => const Color(0xFFFFFFFF);

  @override
  Color get accent1 => const Color(0x4C4B39EF);

  @override
  Color get accent2 => const Color(0x4D39D2C0);

  @override
  Color get accent3 => const Color(0x4DEE8B60);

  @override
  Color get accent4 => const Color(0xCCFFFFFF);

  @override
  Color get success => const Color(0xFF249689);

  @override
  Color get warning => const Color(0xFFFFA130);

  @override
  Color get error => const Color(0xFFFF5963);

  @override
  Color get info => const Color(0xFFFFFFFF);

  @override
  Color get lineColor => const Color(0xFFE0E3E7);

  @override
  Color get overlay => const Color(0xCCFFFFFF);

  @override
  Color get dark350 => const Color(0xFFFFFFFF);

  @override
  Color get primary600 => const Color(0xFF452FB7);

  @override
  Color get overlay0 => const Color(0x00FFFFFF);

  @override
  Color get dark300 => const Color(0xFFDBE2E7);

  @override
  Color get hoverColor => const Color(0xFFF3EEEE);

  @override
  Color get messageRed => const Color(0xFFDF3F3F);

  @override
  Color get greenAccent => const Color(0xFF31BFAE);

  @override
  Color get panelBorderColor => kGrey250;

  @override
  Color get panelTextColor1 => const Color(0xFF59636B);

  @override
  Color get panelColor => Colors.white;

  @override
  Color get dark200 => const Color(0xFFC4CDD6);

  @override
  Color get dark400 => const Color(0xFFF1F4F8);

  @override
  Color get dark800 => Colors.white;

  @override
  Color get navPanelColor => Colors.white;

  @override
  Color get buttonColor => const Color(0xFF4542e6);

  @override
  Color get workspaceButtonColor => const Color(0xFF59636B);

  @override
  Color get tooltip => const Color(0xFF57636C);

  @override
  Color get panelTextColor2 => const Color(0xFF59636B);

  @override
  FFTypography get typography => {
        DeviceSize.mobile: MobileTypography(this),
        DeviceSize.tablet: TabletTypography(this),
        DeviceSize.desktop: DesktopTypography(this),
      }[deviceSize]!;
}

class AppDarkModeTheme extends AppThemeModel {
  AppDarkModeTheme(this.deviceSize);

  final DeviceSize deviceSize;

  @override
  bool get isLightMode => false;

  @override
  Color get white => Colors.white;

  @override
  Color get primary => const Color(0xFF4B39EF);

  @override
  Color get secondary => const Color(0xFF39D2C0);

  @override
  Color get tertiary => const Color(0xFFEE8B60);

  @override
  Color get alternate => const Color(0xFF323B45);

  @override
  Color get primaryText => const Color(0xFFFFFFFF);

  @override
  Color get secondaryText => const Color(0xFF95A1AC);

  @override
  Color get primaryBackground => const Color(0xFF1A1F24);

  @override
  Color get secondaryBackground => const Color(0xFF14181B);

  @override
  Color get accent1 => const Color(0x4C4B39EF);

  @override
  Color get accent2 => const Color(0x4D39D2C0);

  @override
  Color get accent3 => const Color(0x4DEE8B60);

  @override
  Color get accent4 => const Color(0xCB1A1F24);

  @override
  Color get success => const Color(0xFF249689);

  @override
  Color get warning => const Color(0xFFFFA130);

  @override
  Color get error => const Color(0xFFFF5963);

  @override
  Color get info => const Color(0xFFFFFFFF);

  @override
  Color get lineColor => const Color(0xFF323B45);

  @override
  Color get overlay => const Color(0xCB1A1F24);

  @override
  Color get dark350 => const Color(0xFF262D34);

  @override
  Color get primary600 => const Color(0xFF452FB7);

  @override
  Color get overlay0 => const Color(0x0014181B);

  @override
  Color get dark300 => const Color(0xFF323B45);

  @override
  Color get hoverColor => const Color(0xFF1A2024);

  @override
  Color get messageRed => const Color(0xFFDF3F3F);

  @override
  Color get greenAccent => const Color(0xFF31BFAE);

  @override
  Color get panelBorderColor => const Color(0xFF323B45);

  @override
  Color get panelTextColor1 => const Color(0xFF59636B);

  @override
  Color get panelColor => const Color(0xFF14181B);

  @override
  Color get dark200 => const Color(0xFF2d353d);

  @override
  Color get dark400 => const Color(0xFF1D2428);

  @override
  Color get dark800 => const Color(0xFF090F13);

  @override
  Color get navPanelColor => const Color(0xFF101213);

  @override
  Color get buttonColor => const Color(0xFF4542e6);

  @override
  Color get workspaceButtonColor => const Color(0xFFC8C8C8);

  @override
  Color get tooltip => const Color(0xFF57636C);

  @override
  Color get panelTextColor2 => const Color(0xFF9AA6B6);

  @override
  FFTypography get typography => {
        DeviceSize.mobile: MobileTypography(this),
        DeviceSize.tablet: TabletTypography(this),
        DeviceSize.desktop: DesktopTypography(this),
      }[deviceSize]!;
}

class MobileTypography implements FFTypography {
  MobileTypography(this.theme);
  final AppThemeModel theme;

  @override
  String get displayLargeFamily => 'Product Sans';
  @override
  TextStyle get displayLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 44,
      );
  @override
  String get displayMediumFamily => 'Product Sans';
  @override
  TextStyle get displayMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 32,
      );
  @override
  String get displaySmallFamily => 'Product Sans';
  @override
  TextStyle get displaySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );
  @override
  String get headlineLargeFamily => 'Product Sans';
  @override
  TextStyle get headlineLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 24,
      );
  @override
  String get headlineMediumFamily => 'Product Sans';
  @override
  TextStyle get headlineMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );
  @override
  String get headlineSmallFamily => 'Product Sans';
  @override
  TextStyle get headlineSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  @override
  String get titleLargeFamily => 'Product Sans';
  @override
  TextStyle get titleLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      );
  @override
  String get titleMediumFamily => 'Product Sans';
  @override
  TextStyle get titleMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  @override
  String get titleSmallFamily => 'Product Sans';
  @override
  TextStyle get titleSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  @override
  String get labelLargeFamily => 'Product Sans';
  @override
  TextStyle get labelLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  @override
  String get labelMediumFamily => 'Product Sans';
  @override
  TextStyle get labelMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  @override
  String get labelSmallFamily => 'Product Sans';
  @override
  TextStyle get labelSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      );
  @override
  String get bodyLargeFamily => 'Product Sans';
  @override
  TextStyle get bodyLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
  @override
  String get bodyMediumFamily => 'Product Sans';
  @override
  TextStyle get bodyMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
  @override
  String get bodySmallFamily => 'Product Sans';
  @override
  TextStyle get bodySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
}

class TabletTypography implements FFTypography {
  TabletTypography(this.theme);
  final AppThemeModel theme;

  @override
  String get displayLargeFamily => 'Product Sans';
  @override
  TextStyle get displayLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 64,
      );
  @override
  String get displayMediumFamily => 'Product Sans';
  @override
  TextStyle get displayMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 36,
      );
  @override
  String get displaySmallFamily => 'Product Sans';
  @override
  TextStyle get displaySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      );
  @override
  String get headlineLargeFamily => 'Product Sans';
  @override
  TextStyle get headlineLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32,
      );
  @override
  String get headlineMediumFamily => 'Product Sans';
  @override
  TextStyle get headlineMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );
  @override
  String get headlineSmallFamily => 'Product Sans';
  @override
  TextStyle get headlineSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 24,
      );
  @override
  String get titleLargeFamily => 'Product Sans';
  @override
  TextStyle get titleLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  @override
  String get titleMediumFamily => 'Product Sans';
  @override
  TextStyle get titleMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.info,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  @override
  String get titleSmallFamily => 'Product Sans';
  @override
  TextStyle get titleSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  @override
  String get labelLargeFamily => 'Product Sans';
  @override
  TextStyle get labelLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );
  @override
  String get labelMediumFamily => 'Product Sans';
  @override
  TextStyle get labelMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  @override
  String get labelSmallFamily => 'Product Sans';
  @override
  TextStyle get labelSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      );
  @override
  String get bodyLargeFamily => 'Product Sans';
  @override
  TextStyle get bodyLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
  @override
  String get bodyMediumFamily => 'Product Sans';
  @override
  TextStyle get bodyMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
  @override
  String get bodySmallFamily => 'Product Sans';
  @override
  TextStyle get bodySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
}

class DesktopTypography implements FFTypography {
  DesktopTypography(this.theme);
  final AppThemeModel theme;

  @override
  String get displayLargeFamily => 'Product Sans';
  @override
  TextStyle get displayLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 64,
      );
  @override
  String get displayMediumFamily => 'Product Sans';
  @override
  TextStyle get displayMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 36,
      );
  @override
  String get displaySmallFamily => 'Product Sans';
  @override
  TextStyle get displaySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      );
  @override
  String get headlineLargeFamily => 'Product Sans';
  @override
  TextStyle get headlineLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 32,
      );
  @override
  String get headlineMediumFamily => 'Product Sans';
  @override
  TextStyle get headlineMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );
  @override
  String get headlineSmallFamily => 'Product Sans';
  @override
  TextStyle get headlineSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 24,
      );
  @override
  String get titleLargeFamily => 'Product Sans';
  @override
  TextStyle get titleLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 20,
      );
  @override
  String get titleMediumFamily => 'Product Sans';
  @override
  TextStyle get titleMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  @override
  String get titleSmallFamily => 'Product Sans';
  @override
  TextStyle get titleSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  @override
  String get labelLargeFamily => 'Product Sans';
  @override
  TextStyle get labelLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      );
  @override
  String get labelMediumFamily => 'Product Sans';
  @override
  TextStyle get labelMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      );
  @override
  String get labelSmallFamily => 'Product Sans';
  @override
  TextStyle get labelSmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.secondaryText,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      );
  @override
  String get bodyLargeFamily => 'Product Sans';
  @override
  TextStyle get bodyLarge => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      );
  @override
  String get bodyMediumFamily => 'Product Sans';
  @override
  TextStyle get bodyMedium => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
  @override
  String get bodySmallFamily => 'Product Sans';
  @override
  TextStyle get bodySmall => TextStyle(
        fontFamily: 'Product Sans',
        color: theme.primaryText,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
}
