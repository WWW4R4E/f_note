import 'package:flutter/material.dart';
import 'ReadPage.dart';

class NotePage extends StatelessWidget {
  final String title;
  final String text;
  const NotePage({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: ReadPage(title: title, text: text)
    );
  }
}
