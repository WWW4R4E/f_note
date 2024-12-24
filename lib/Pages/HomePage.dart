import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '欢迎使用笔记',
            ),
          ],
        ),
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
