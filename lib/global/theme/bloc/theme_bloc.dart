// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

// 🌎 Project imports:
import '../app_theme.dart';

part 'theme_event.dart';

/// Theme bloc, support save local theme for app
class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeData> {
  // ignore: public_member_api_docs
  ThemeBloc() : super(AppTheme.light());

  @override
  Stream<ThemeData> mapEventToState(ThemeEvent event) async* {
    if (event is LightThemeEvent) yield AppTheme.light();
    if (event is DarkThemeEvent) yield AppTheme.dark();
  }

  @override
  ThemeData? fromJson(Map<String, dynamic> json) {
    try {
      if (json['light'] as bool) return AppTheme.light();
      return AppTheme.dark();
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, bool>? toJson(ThemeData state) {
    try {
      return {'light': state == AppTheme.light()};
    } catch (_) {
      return null;
    }
  }
}
