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
                border: InputBorder.none, // 移除边框
              ),
            ),
            // 生成分割线
            Divider(
              height: 10,
              thickness: 1,
            ),
            Expanded(
              child: TextField(
                controller: textController,
                onChanged: onTextChanged,
                decoration: const InputDecoration(
                  hintText: '请输入Markdown源码',
                  border: InputBorder.none, // 移除边框
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
