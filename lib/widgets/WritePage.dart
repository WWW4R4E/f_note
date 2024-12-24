import 'package:flutter/material.dart';

class WritePage extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController textController;
  final Function(String) onTitleChanged;
  final Function(String) onTextChanged;

  const WritePage({
    super.key,
    required this.titleController,
    required this.textController,
    required this.onTitleChanged,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              onChanged: onTitleChanged,
              decoration: const InputDecoration(
                hintText: '请输入标题',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: onTextChanged,
                decoration: const InputDecoration(
                  hintText: '请输入Markdown源码',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
