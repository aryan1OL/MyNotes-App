import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_notes/cubit/notes_cubit.dart';
import 'package:my_notes/cubit/settings_cubit.dart';
import 'package:my_notes/cubit/settings_state.dart';
import 'package:my_notes/database/NotesHiveDatabase.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/settings/SettingStorage.dart';
import 'package:my_notes/theme/app_theme.dart';
import 'package:my_notes/views/notes_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  await Hive.openBox('settings');
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NotesCubit(NotesHiveDatabase())..loadNotes(),
        ),
        BlocProvider(create: (_) => SettingsCubit(SettingStorage(prefs))),

      ],
      child: BlocBuilder<SettingsCubit, SettingState>(
        builder: (context, settings) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: Scaffold(
              appBar: AppBar(
                title: const Text(
                  'My Notes',
                ),
                actions: [
                  PopupMenuButton<SortOrder>(
                    tooltip: 'Sort notes',
                    icon: const Icon(Icons.sort),
                    initialValue: settings.sortOrder,                                   // 1
                    onSelected: (order) => context.read<SettingsCubit>().setSortOrder(order),  // 2
                    itemBuilder: (context) => const [                                   // 3
                      PopupMenuItem(value: SortOrder.newest, child: Text('Newest first')),
                      PopupMenuItem(value: SortOrder.oldest, child: Text('Oldest first')),
                    ],
                  ),
                  IconButton(
                    tooltip: settings.isDarkMode ? 'Light mode' : 'Dark mode',
                    icon: Icon(
                      settings.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    ),
                    onPressed: () =>
                        context.read<SettingsCubit>().toggleDarkMode(),
                  ),
                ],
              ),
              body: NotesApp(),
            ),
          );
        },
      ),
    ),
  );
}
