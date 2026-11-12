import 'dart:convert';
import 'dart:developer';

import 'package:flutter_gail/feature/login/domain/models/login_model.dart';
import 'package:flutter_gail/localDataBase/preferences_name.dart';
import 'package:flutter_gail/localDataBase/shared_preferences_utils.dart';
import 'package:flutter_gail/utils/commonClass/app_config.dart';

/// 🔑 Reads the signed-in user, falling back to the copy stored at login.
///
/// [AppConfig] is an in-memory singleton and a background isolate gets its
/// own memory, so there `AppConfig.instanceInit()` hands back a blank object
/// — no token, no schema. Every upload from the background service then went
/// out unauthenticated. SharedPreferences is backed by native storage and is
/// readable from any isolate, so the session is recovered from there.
class SessionHelper {
  static LoginDataModel? _cached;

  /// The current user, or null if nobody is signed in.
  static Future<LoginDataModel?> currentUser() async {
    final inMemory = AppConfig.instanceInit()?.userData;
    if (_hasToken(inMemory)) return inMemory;
    if (_hasToken(_cached)) return _cached;

    try {
      final userJson = await SharedPreferencesUtils.getString(
        key: PreferencesName.userInfo,
      );
      if (userJson.isEmpty) return inMemory;

      _cached = LoginDataModel.fromJson(jsonDecode(userJson));
      return _cached;
    } catch (e, s) {
      log("⚠️ Could not restore session from storage: $e", stackTrace: s);
      return inMemory;
    }
  }

  static Future<String> authToken() async =>
      (await currentUser())?.tokens?.access ?? "";

  static Future<String> schema() async => (await currentUser())?.schema ?? "";

  /// Drop the isolate-local copy, e.g. on logout.
  static void clear() => _cached = null;

  static bool _hasToken(LoginDataModel? user) =>
      (user?.tokens?.access ?? "").isNotEmpty;
}
