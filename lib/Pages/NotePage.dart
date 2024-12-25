import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/ReadPage.dart';

class NotePage extends StatelessWidget {
  final String title;
  final String path;
  const NotePage({
    super.key,
    required this.title,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    final file = File(path);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, '/editor', arguments: {
                  'fileName': title,
                  'context': File(path).readAsStringSync()
                });
              },
            ),
            
          ],
        ),
        body: ReadPage(title: title, text: file.readAsStringSync()));
  }
}
