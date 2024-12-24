import 'dart:io';

import 'package:f_note/widgets/ReadPage.dart';
import 'package:f_note/widgets/WritePage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.title != null &&
        widget.title!.isNotEmpty &&
        widget.text != null &&
        widget.text!.isNotEmpty) {
      _title = widget.title;
      _text = widget.text;
    }
    _titleController = TextEditingController();
    _textController = TextEditingController();
    _loadData();
  }

  String? getSavedTitle(SharedPreferences prefs, String? defaultTitle) {
    try {
      return prefs.getString('saved_title') ?? defaultTitle;
    } catch (e) {
      print('Error loading saved title: $e');
      return defaultTitle;
    }
  }

  String? getSavedText(SharedPreferences prefs, String? defaultText) {
    try {
      return prefs.getString('saved_text') ?? defaultText;
    } catch (e) {
      print('Error loading saved text: $e');
      return defaultText;
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedTitle = getSavedTitle(prefs, widget.title);
    final loadedText = getSavedText(prefs, widget.text);
    setState(() {
      _title = loadedTitle;
      _text = loadedText;
      _titleController.text = loadedTitle ?? ''; // 更新标题控制器文本
      _textController.text = loadedText ?? ''; // 更新文本控制器文本
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_title', _title ?? '');
    await prefs.setString('saved_text', _text ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('写作页面'),
        actions: [
          IconButton(
              icon: Icon(Icons.save_alt_outlined),
              onPressed: () {
                saveFile();
              }),
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
      body: read
          ? ReadPage(title: _title ?? '', text: _text ?? '')
          : WritePage(
              titleController: _titleController,
              textController: _textController,
              onTitleChanged: (value) {
                _title = value;
                _saveData();
              },
              onTextChanged: (value) {
                _text = value;
                _saveData();
              },
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose(); // 清理标题控制器资源
    _textController.dispose(); // 清理文本控制器资源
    super.dispose();
  }

// 将文件保存成md文件
  Future<void> saveFile() async {
    try {
      // 获取文件保存路径
      final directory = await getApplicationDocumentsDirectory();
      final fnoteDir = '${directory.path}/Fnote';

      // 确保 Fnote 文件夹存在
      final dir = Directory(fnoteDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final filePath = '$fnoteDir/$_title.md';

      // 创建文件并写入内容
      final file = File(filePath);
      await file.writeAsString('\n\n$_text');
      _title = '';
      _title = '';
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_title');
      await prefs.remove('saved_text');

      // 显示保存成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件保存成功')),
      );
    } catch (e) {
      // 显示保存失败提示
      print('文件保存失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件保存失败，请重试')),
      );
    }
  }
}
