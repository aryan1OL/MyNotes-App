

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_notes/cubit/settings_state.dart';
import 'package:my_notes/settings/SettingStorage.dart';

class SettingsCubit extends Cubit<SettingState>{
  final SettingStorage _storage;

  SettingsCubit(SettingStorage storage)
    : _storage=storage,
      super(SettingState(isDarkMode: storage.isDarkMode, sortOrder: storage.sortOrder));


  Future<void> toggleDarkMode() async{
    bool newVal=!state.isDarkMode;
    await _storage.setDarkMode(newVal);
    emit(state.copyWith(isDarkMode: newVal));
  }

  Future<void> setSortOrder(SortOrder order) async{
    await _storage.setSortOrder(order);
    emit(state.copyWith(sortOrder: order));
  }
}