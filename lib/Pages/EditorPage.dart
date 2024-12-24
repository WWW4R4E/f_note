import 'package:f_note/Pages/ReadPage.dart';
import 'package:f_note/Pages/WritePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

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
    _titleController = TextEditingController();
    _textController = TextEditingController();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedTitle = prefs.getString('saved_title') ?? '';
    final loadedText = prefs.getString('saved_text') ?? '';
    setState(() {
      _title = loadedTitle;
      _text = loadedText;
      _titleController.text = loadedTitle; // 更新标题控制器文本
      _textController.text = loadedText; // 更新文本控制器文本
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
        title: const Text('源码编辑页面'),
        actions: [
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
}