
import 'package:material_ui/material_ui.dart';
import 'package:my_notes/model/note.dart';



class NoteWidget extends StatefulWidget {
  final VoidCallback onFavoritePressed;
  final Note note;
  final VoidCallback onDeletePressed;
  final Future<void> Function(String title,String description) onUpdatePressed;

  const NoteWidget({
    super.key,
    required this.onFavoritePressed,
    required this.onDeletePressed,
    required this.onUpdatePressed,
    required this.note,
  });

  @override
  State<NoteWidget> createState() => _NoteWidgetState();
}

class _NoteWidgetState extends State<NoteWidget> {
  bool isEditing=false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEditing?Column(
      children: [
        const SizedBox(height: 10),

        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: "Enter Title",
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 10),

        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: "Enter Description",
            border: OutlineInputBorder(),
          ),
        ),
        Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty) {
                  return;
                }

                await widget.onUpdatePressed(
                  titleController.text,
                  descriptionController.text,
                );

                if (!mounted) return;

                setState(() {
                  isEditing = false;
                });
              },
              child: const Text('Update Note'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                });
              },
              child: const Text('Cancel'),
            ),
          ],
        )


      ],
    ):Card(
      color: Colors.blue[900],
      elevation: 2,
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NoteHeader(
              title: widget.note.title,
              isFavorite: widget.note.isFavorite,
              onFavoritePressed: widget.onFavoritePressed,
            ),

            const SizedBox(height: 8),

            NoteDescription(description: widget.note.description),

            const SizedBox(height: 8),

            NoteFooter(onDeletePressed: widget.onDeletePressed,date: widget.note.date,onEditingPressed:startEditing,),
          ],
        ),
      ),
    );
  }

  void startEditing() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;

    setState(() {
      isEditing = true;
    });
  }
}

class NoteHeader extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;


  const NoteHeader({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.note, color: Colors.blue),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white,),
      ),
      trailing: IconButton(
        onPressed: onFavoritePressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
      ),
    );
  }
}

class NoteDescription extends StatelessWidget {
  final String description;

  const NoteDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Text(description, maxLines: 3, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white),);
  }
}

class NoteFooter extends StatelessWidget {
  final String date;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditingPressed;
  String _formatDate(String stored) {
    final d = DateTime.tryParse(stored);                 // 1
    if (d == null) return stored;                        // 2
    final day = d.day.toString().padLeft(2, '0');        // 3
    final month = d.month.toString().padLeft(2, '0');
    return '$day-$month-${d.year}';
  }

  const NoteFooter({super.key,required this.date,required this.onDeletePressed,required this.onEditingPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month),
            const SizedBox(width: 4),
            Text(_formatDate(date),style: TextStyle(color: Colors.white),),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onDeletePressed,
              icon: const Icon(Icons.delete_outline,color: Colors.white,),
            ),
            IconButton(
              onPressed: onEditingPressed,
              icon: const Icon(Icons.edit,color: Colors.white,),
            ),
          ],
        ),
      ],
    );
  }
}








