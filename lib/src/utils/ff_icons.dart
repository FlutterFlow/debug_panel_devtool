// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

class FFIcons {
  FFIcons._();

  static bool isReservedIconFamilyName(String? familyName) =>
      kReservedIconFamilys.contains(familyName);
  static const kReservedIconFamilys = [
    _kFontFam,
    _kNewFontFam,
    _kTreeFontFam,
    _kPropertyFontFam,
    _kTextFieldFontFam,
  ];

  static const _kFontFam = 'FFIcons';
  static const _kNewFontFam = 'NewFFIcons';
  static const _kTreeFontFam = 'WidgetTreeIcons';
  static const _kPropertyFontFam = 'PropertyEditorIcons';
  static const _kTextFieldFontFam = 'TextFieldIcon';

  static const IconData actions = IconData(0xe906, fontFamily: _kNewFontFam);
  static const IconData arrow_down = IconData(0xe900, fontFamily: _kNewFontFam);
  static const IconData list = IconData(0xe806, fontFamily: _kFontFam);
  static const IconData filter = IconData(0xe986, fontFamily: _kNewFontFam);
  static const IconData fonts = IconData(0xe935, fontFamily: _kNewFontFam);
  static const IconData data_types = IconData(0xe9c5, fontFamily: _kNewFontFam);
  static const IconData database = IconData(0xe902, fontFamily: _kNewFontFam);
  static const IconData debug_icon = IconData(0xe90a, fontFamily: _kNewFontFam);
  static const IconData postgres = IconData(0xe9b9, fontFamily: _kNewFontFam);
  static const IconData supabase = IconData(0xe9aa, fontFamily: _kNewFontFam);
  static const IconData search = IconData(0xe998, fontFamily: _kNewFontFam);
  static const IconData uploaded_file =
      IconData(0xe9ac, fontFamily: _kNewFontFam);
}
