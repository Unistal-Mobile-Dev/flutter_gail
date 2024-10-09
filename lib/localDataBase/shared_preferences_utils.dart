import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static SharedPreferences? instance;

  static getInstance() async {
  instance ??= await SharedPreferences.getInstance();
  return instance;
}

static Future<bool> setString(
{required String key, required String value}) async {
    await getInstance();
    return await instance!.setString(key, value);
  }

  static Future<String> getString({required String key}) async {
    await getInstance();
    return instance!.getString(key) ?? "";
  }

  static Future<bool> setBool(
      {required String key, required bool value}) async {
    await getInstance();
    return await instance!.setBool(key, value);
  }

  static Future<bool> getBool({required String key}) async {
    await getInstance();
    return instance!.getBool(key) ?? false;
  }

  static Future<bool> clearAll() async {
    return await instance!.clear();
  }
}
