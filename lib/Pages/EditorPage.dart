import 'dart:io';

import 'package:f_note/widgets/ReadPage.dart';
import 'package:f_note/widgets/WritePage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class EditorPage extends StatefulWidget {
  final String? title;
  final String? text;

  const EditorPage({super.key, this.title, this.text});

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  bool read = false;
  String? _title;
  String? _text;
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late TextEditingController _findController;
  late TextEditingController _replaceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _textController = TextEditingController(text: widget.text);
    _findController = TextEditingController();
    _replaceController = TextEditingController();
    _title = widget.title;
    _text = widget.text;
  }

  Future<void> _saveFile() async {
    try {
      if (_title == null ||
          _title!.isEmpty ||
          _text == null ||
          _text!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('标题和内容不能为空')),
        );
        return;
      }

      // 获取文件保存路径
      final directory = await getApplicationDocumentsDirectory();
      final fnoteDir = p.join(directory.path, 'Fnote');

      // 确保 Fnote 文件夹存在
      final dir = Directory(fnoteDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // 清理文件名中的非法字符
      String cleanTitle =
          _title?.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_') ?? 'untitled';

      // 进一步清理文件名中的其他潜在非法字符（如换行符等）
      cleanTitle = cleanTitle.replaceAll(RegExp(r'[\n\r\t]'), '_').trim();

      final filePath = p.join(fnoteDir, '$cleanTitle.md');
      final file = File(filePath);

      // 检查文件是否存在
      if (await file.exists()) {
        final shouldOverwrite = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('文件已存在'),
            content: Text('是否覆盖现有文件？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('覆盖'),
              ),
            ],
          ),
        );

        Navigator.pop(context);
        if (shouldOverwrite != true) {
          return;
        }
      }

      // 创建文件并写入内容
      // print('Saving file: $filePath');
      await file.writeAsString(_text ?? '');

      // 显示保存成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件保存成功')),
      );
    } catch (e) {
      // 分类处理异常
      if (e is FileSystemException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('文件系统错误，请检查权限')),
        );
      } else {
        // print('文件保存失败: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('文件保存失败，请重试')),
        );
      }
    }
  }

  void _findAndReplace() {
    final findText = _findController.text;
    final replaceText = _replaceController.text;
    if (findText.isEmpty) {
      return;
    }
    setState(() {
      _text = _text?.replaceAll(findText, replaceText);
      _textController.text = _text ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt_outlined),
            onPressed: () async {
              await _saveFile();
            },
          ),
          IconButton(
            icon: Icon(Icons.change_circle_outlined),
            onPressed: () {
              setState(() {
                read = !read;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!read)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _findController,
                      decoration: InputDecoration(
                        hintText: '查找',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _replaceController,
                      decoration: InputDecoration(
                        hintText: '替换',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: _findAndReplace,
                    child: Text('替换'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: read
                ? ReadPage(title: _title ?? '', text: _text ?? '')
                : WritePage(
                    titleController: _titleController,
                    textController: _textController,
                    onTitleChanged: (value) {
                      _title = value;
                    },
                    onTextChanged: (value) {
                      _text = value;
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose(); // 清理标题控制器资源
    _textController.dispose(); // 清理文本控制器资源
    _findController.dispose(); // 清理查找控制器资源
    _replaceController.dispose(); // 清理替换控制器资源
    super.dispose();
  }
}
