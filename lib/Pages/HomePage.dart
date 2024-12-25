import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<Map<String, String>> _noteTitles = [];
  final Set<int> _selectedIndices = <int>{};
  bool _isMultiSelect = false;

  @override
  bool get wantKeepAlive => false; // 设置为 false 以确保每次返回页面时重新构建

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    final fnoteDir = Directory('${directory.path}/Fnote');
    print("扫描了目录: ${fnoteDir.path}");
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
    super.build(context); // 必须调用 super.build(context)
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadNotes();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          ),
          if (_noteTitles.isNotEmpty)
            IconButton(
              icon: Icon(_isMultiSelect ? Icons.close : Icons.check_box),
              onPressed: _toggleMultiSelect,
            ),
          if (_isMultiSelect)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedNotes,
            )
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
                fillColor: const Color.fromARGB(90, 117, 117, 117),
                enabledBorder: null,
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
                final isSelected = _selectedIndices.contains(index);
                return Card(
                  shadowColor: Colors.white,
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(_noteTitles[index]['fileName'] ?? '未知标题'),
                    selected: isSelected, // 设置选中状态
                    onTap: () {
                      if (_isMultiSelect) {
                        setState(() {
                          if (isSelected) {
                            _selectedIndices.remove(index);
                          } else {
                            _selectedIndices.add(index);
                          }
                        });
                      } else {
                        // 导航到笔记详情页
                        Navigator.pushNamed(context, '/note',
                            arguments: _noteTitles[index]);
                      }
                    },
                    trailing:
                        _isMultiSelect && isSelected ? Icon(Icons.check) : null,
                    enableFeedback: false, // 关闭水波点击效果
                    splashColor: Colors.transparent, // 去掉水波点击效果
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'newNote', // 添加唯一的 heroTag
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              Navigator.pushNamed(context, '/editor');
            },

            splashColor: Colors.transparent, // 移除水波效果
            hoverColor: Colors.transparent, // 移除悬停效果
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }

  Future<void> _deleteSelectedNotes() async {
    if (_selectedIndices.isEmpty) return;

    final indicesToDelete = List<int>.from(_selectedIndices); // 复制一份选中的索引

    try {
      for (var index in indicesToDelete) {
        final filePath = _noteTitles[index]['filePath'];
        if (filePath != null) {
          final file = File(filePath);
          await file.delete();
        }
      }

      setState(() {
        _isMultiSelect = false; // 退出多选模式
        _selectedIndices.clear(); // 清空选中的索引
      });

      await _loadNotes(); // 重新加载笔记列表
    } catch (e) {
      // 处理删除过程中出现的异常
      print('删除笔记时出错: $e');
    }
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelect = !_isMultiSelect;
      if (!_isMultiSelect) {
        _selectedIndices.clear(); // 退出多选模式时清空选中的索引
      }
    });
  }
}
