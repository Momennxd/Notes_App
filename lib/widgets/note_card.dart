import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/note.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xff1C1C1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(note.icon ?? Icons.notes_rounded, color: Color(0xFF98989F), size: 20),
                SizedBox(width: 10),
                Text(
                  note.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Text(
              note.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Color(0xFF98989F),
                fontSize: 16,
              ),
            ),
      
            Text(
              DateFormat('MMM d, y').format(note.date),
              style: TextStyle(color: Color(0xFF98989F), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
