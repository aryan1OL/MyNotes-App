import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_notes/cubit/notes_cubit.dart';
import 'package:my_notes/cubit/notes_state.dart';
import 'package:my_notes/cubit/settings_cubit.dart';
import 'package:my_notes/model/note.dart';
import 'package:my_notes/settings/SettingStorage.dart';
import 'package:my_notes/widget/EmptyNote.dart';
import 'package:my_notes/widget/note_card.dart';

enum NoteFilter { all, favorites }

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}


class _NotesAppState extends State<NotesApp> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();



  bool isList = true;
  bool addNoteActive = false;
  NoteFilter filter = NoteFilter.all;

  void toggleIsList() {
    setState(() {
      isList = !isList;
    });
  }
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  List<Note> _sorted(List<Note> notes, SortOrder order) {
    final copy = [...notes];
    copy.sort((a, b) => order == SortOrder.newest
        ? b.date.compareTo(a.date)
        : a.date.compareTo(b.date));
    return copy;
  }



  @override
  Widget build(BuildContext context) {
    //final NotesController notesController = Get.find<NotesController>();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final sortOrder = context.select((SettingsCubit c) => c.state.sortOrder);

    int columns = 1;

    if (screenWidth >= 900) {
      columns = 4;
    } else if (screenWidth >= 600) {
      columns = 3;
    } else if (screenWidth >= 400) {
      columns = 2;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                  child: FilledButton(
                    onPressed: () => setState(() => addNoteActive = !addNoteActive),
                    child: Text(addNoteActive ? 'Cancel' : '+ Add note'),
                  ),
                ),
              IconButton(
                onPressed: () {
                  toggleIsList();
                },
                icon: isList ? Icon(Icons.grid_4x4) : Icon(Icons.list),
              ),
            ],
          ),
          addNoteActive
              ? Column(
                  children: [
                    const SizedBox(height: 10),

                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Enter Title",
                        hintText: "e.g. Flutter Learning",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Enter Description",
                        hintText: "Learn about flutter and dart Concepts",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        if (titleController.text.trim().isNotEmpty &&
                            descriptionController.text.trim().isNotEmpty) {
                          final now = DateTime.now();
                          final date = '${now.day}-${now.month}-${now.year}';
                          await context.read<NotesCubit>().addNote(
                            titleController.text,
                            descriptionController.text,
                          );
                          titleController.clear();
                          descriptionController.clear();
                        }
                      },
                      child: Text('Save Note'),
                    ),
                  ],
                )
              : const SizedBox(),
          Row(
            children: [
              ChoiceChip(
                label: const Text('All'),
                selected: filter == NoteFilter.all,
                onSelected: (_) => setState(() => filter = NoteFilter.all),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Favorites'),
                avatar: const Icon(Icons.favorite, size: 16),
                selected: filter == NoteFilter.favorites,
                onSelected: (_) => setState(() => filter = NoteFilter.favorites),
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<NotesCubit, NotesState>(
              listener: (context, state) {
                if (state is NotesLoaded && state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message!)),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  NotesInitial() => Text('Initialised'),
                  NotesLoading() => Center(child: const CircularProgressIndicator()),
                  NotesLoaded(:final notes) =>(){
                    var visible = _sorted(notes, sortOrder);
                    if(filter==NoteFilter.favorites){
                      visible=visible.where((n){return n.isFavorite==true;}).toList();
                    }

                    return visible.isEmpty
                        ? EmptyNote()
                        : isList
                        ? ListView.builder(
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        return NoteWidget(
                          onFavoritePressed: () {
                            context.read<NotesCubit>().toggleFavorite(
                              visible[index].id!,
                            );
                          },
                          key: ObjectKey(visible[index].id),
                          note: visible[index],
                          onDeletePressed: () {
                            context.read<NotesCubit>().deleteNote(
                              visible[index].id!,
                            );
                          },

                          onUpdatePressed: (title, description) async {
                            await context.read<NotesCubit>().updateNote(
                              visible[index].id!,
                              title,
                              description,
                            );
                          },
                        );
                      },
                    )
                        : GridView.builder(
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        return NoteWidget(
                          onFavoritePressed: () {
                            context.read<NotesCubit>().toggleFavorite(
                              visible[index].id!,
                            );
                          },
                          note: visible[index],
                          key: ObjectKey(visible[index].id),
                          onDeletePressed: () {
                            context.read<NotesCubit>().deleteNote(
                              visible[index].id!,
                            );
                          },
                          onUpdatePressed: (title, description) async {
                            await context.read<NotesCubit>().updateNote(
                              visible[index].id!,
                              title,
                              description,
                            );
                          },
                        );
                      },
                    );
                  }()

                ,
                  NotesError(:final message) => Text('There is some error:$message'),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
