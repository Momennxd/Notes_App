
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/app_colors.dart';
import 'package:flutter_application_1/core/note.dart';
import 'package:flutter_application_1/core/notes_manager.dart';

class AddShowNoteScreen extends StatefulWidget {
  final Note? note;
  const AddShowNoteScreen({super.key, required this.note});

  @override
  State<AddShowNoteScreen> createState() => _AddShowNoteScreenState();
}

class _AddShowNoteScreenState extends State<AddShowNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              cursorColor: AppColors.yellowNotes,
              controller: titleController,
              maxLines: null,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              decoration: InputDecoration(border: InputBorder.none),
            ),

            SizedBox(height: 0),

            Expanded(
              child: TextField(
                cursorColor: AppColors.yellowNotes,
                controller: contentController,
                maxLines: null,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: Icon(Icons.arrow_back_ios, color: AppColors.yellowNotes),
        ),
        actions: [
          PopupMenuButton<String>(
            color: AppColors.NoteCardBG,
            icon: Icon(Icons.more_vert, color: AppColors.yellowNotes),
            onSelected: (value) async {
              if (value == 'delete') {
                if (widget.note != null) {
                  await NotesManager().deleteNote(widget.note!.id);
                }
                if (!mounted) return;
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Text('Delete', style: TextStyle(color: Colors.white)),
                    SizedBox(width: 18),
                    Icon(Icons.delete_forever_outlined, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black),
            ),
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();

              if (title.isEmpty && content.isEmpty) {
                Navigator.pop(context);
                return;
              }

              try {
                if (widget.note == null) {
                  await NotesManager().addNote(
                    title,
                    content,
                    Icons.notes_outlined,
                  );
                } else {
                  await NotesManager().updateNote(
                    widget.note!.id,
                    title: title,
                    content: content,
                  );
                }
              } catch (e) {
                debugPrint(
                  '❌ Error saving note: $e',
                ); // check your console for this
              }

              if (!mounted) return;
              Navigator.pop(context);
            },
            child: Text('Done', style: TextStyle(color: AppColors.yellowNotes)),
          ),
        ],
      ),
    );
  }
}
