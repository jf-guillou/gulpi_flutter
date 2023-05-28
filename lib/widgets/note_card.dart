import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String content;
  const NoteCard(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(padding: EdgeInsets.all(8.0), child: Text(content)));
  }
}
