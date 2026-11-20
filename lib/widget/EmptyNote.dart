import 'package:material_ui/material_ui.dart';

class EmptyNote extends StatelessWidget {
  const EmptyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add_outlined, size: 70, color: cs.primary),
          SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

          ),
          SizedBox(height: 8),
          Text('Create your first note', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
