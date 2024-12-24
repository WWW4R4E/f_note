import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> _noteTitles = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final fnoteDir = Directory('${directory.path}/fnote');
    if (await fnoteDir.exists()) {
      final files = fnoteDir.listSync();
      setState(() {
        _noteTitles = files
            .map((file) => {
                  'fileName': file.uri.pathSegments.last.split('.').first,
                  'filePath': file.path
                })
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: () {
              // 搜索按钮的功能
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 更多按钮的功能
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200], // 设置背景颜色
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              ),
            ),
          ),
        ),
        title: const Text('笔记'),
      ),
      body: _noteTitles.isEmpty
          ? Center(child: Text('快来写笔记吧！'))
          : ListView.builder(
              itemCount: _noteTitles.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(_noteTitles[index]['fileName'] ?? '未知标题'),
                    onTap: () {
                      // 导航到笔记详情页
                      Navigator.pushNamed(context, '/note',
                          arguments: _noteTitles[index]);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/editor');
        },
        tooltip: '新建笔记',
        child: const Icon(Icons.add),
      ),
    );
  }
}
