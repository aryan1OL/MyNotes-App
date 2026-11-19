
import 'package:my_notes/settings/SettingStorage.dart';

class SettingState {
  final bool isDarkMode;
  final SortOrder sortOrder;

  SettingState({required this.isDarkMode,required this.sortOrder});

  SettingState copyWith({bool? isDarkMode,SortOrder? sortOrder}){
    isDarkMode=isDarkMode??this.isDarkMode;
    sortOrder=sortOrder??this.sortOrder;
    return SettingState(isDarkMode: isDarkMode, sortOrder: sortOrder);
  }


}
