import 'package:material_ui/material_ui.dart';
import 'package:get/get.dart';
import 'package:my_notes/controller/notes_controller.dart';
import 'package:my_notes/widget/EmptyNote.dart';
import 'package:my_notes/widget/note_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final NotesController notesController = Get.find<NotesController>();

    final screenWidth = MediaQuery.sizeOf(context).width;

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
          // Add note button
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      addNoteActive = !addNoteActive;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        addNoteActive ? 'x Cancel' : '+ Add Note',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
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
                          await notesController.addNote(
                            titleController.text,
                            descriptionController.text,
                            date,
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
          Expanded(
            child: Obx(() {
              return notesController.notesList.isEmpty
                  ? EmptyNote()
                  : isList
                  ? ListView.builder(
                      itemCount: notesController.notesList.length,
                      itemBuilder: (context, index) {
                        return Note(
                          onFavoritePressed: () {
                            notesController.toggleFavorite(index);

                          },
                          key: ObjectKey(notesController.notesList[index]),
                          noteData: notesController.notesList[index],
                          onDeletePressed: () {
                            notesController.deleteNote(index);
                          },

                          onUpdatePressed: (title, description) async{
                            final now = DateTime.now();
                            final date = '${now.day}-${now.month}-${now.year}';
                            await notesController.updateNote(
                              title,
                              description,
                              date,
                              index,
                            );
                          },
                        );
                      },
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: notesController.notesList.length,
                      itemBuilder: (context, index) {
                        return Note(
                          onFavoritePressed: () {
                            notesController.toggleFavorite(index);
                          },
                          noteData: notesController.notesList[index],
                          key: ObjectKey(notesController.notesList[index]),
                          onDeletePressed: () {
                            notesController.deleteNote(index);
                          },
                          onUpdatePressed: (title, description) async{
                            final now = DateTime.now();
                            final date = '${now.day}-${now.month}-${now.year}';
                            await notesController.updateNote(
                              title,
                              description,
                              date,
                              index,
                            );

                          },
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}
