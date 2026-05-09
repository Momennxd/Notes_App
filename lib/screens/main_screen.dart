import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/note.dart';
import 'package:flutter_application_1/core/notes_manager.dart';
import 'package:flutter_application_1/screens/add_show_note_screen.dart';
import 'package:flutter_application_1/widgets/note_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final notesManager = NotesManager();
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();                          
  }

  Future<void> _loadNotes() async {
    final notes = await notesManager.notes;
    
    if (!mounted) return;
    setState(() => _notes = notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomSheet: Container(
        color: const Color(0xFF1C1C1E),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_notes.length} Notes',             
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddShowNoteScreen(note: null),
                  ),
                );
                await _loadNotes();                  
              },
              icon: Icon(Icons.edit_square, color: Colors.amber),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'All Notes',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: _notes.isEmpty
                ? Center(
                    child: Text(
                      'No notes yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: _notes.length,           
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddShowNoteScreen(
                                  note: _notes[index],  
                                ),
                              ),
                            );
                            await _loadNotes();        
                          },
                          child: NoteCard(note: _notes[index]),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}