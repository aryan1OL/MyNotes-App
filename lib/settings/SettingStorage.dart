import 'package:hive_ce/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortOrder { newest, oldest }

class SettingStorage {
  SettingStorage(this._prefs);
  final SharedPreferences _prefs;

  static const _darkModeKey = 'darkMode';
  static const _sortOrderKey = 'sortOrder';

  Box get _box => Hive.box('settings');


  //used shared preferences
  bool get isDarkMode{
    return _prefs.getBool(_darkModeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(_darkModeKey, value);
  }


  // stored in hive
  SortOrder get sortOrder {
    final name = _box.get(_sortOrderKey, defaultValue: 'newest') as String;
    return SortOrder.values.byName(name);
  }

  Future<void> setSortOrder(SortOrder order) async {
    await _box.put(_sortOrderKey, order.name);
  }

}

