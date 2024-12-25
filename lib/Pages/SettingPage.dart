import 'dart:io';
import 'package:f_note/provider/ThemNotifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("是否跟随系统主题"),
            trailing: Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Switch(
                  value: themeNotifier.themeMode == ThemeMode.system,
                  onChanged: (bool value) {
                    themeNotifier.setThemeMode(
                      value ? ThemeMode.system : ThemeMode.light,
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            title: const Text("字体大小调节"),
            trailing: Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_left_outlined),
                      onPressed: () {
                        double newFontSize = themeNotifier.fontSize - 2.0;
                        if (newFontSize >= 12.0) {
                          themeNotifier.setFontSize(newFontSize);
                        }
                      },
                    ),
                    Text(
                      "${themeNotifier.fontSize}",
                      style: TextStyle(fontSize: themeNotifier.fontSize),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_right_outlined),
                      onPressed: () {
                        double newFontSize = themeNotifier.fontSize + 2.0;
                        if (newFontSize <= 20.0) {
                          themeNotifier.setFontSize(newFontSize);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          ListTile(
            title: Text("笔记导入"),
            trailing: IconButton(
              icon: Icon(Icons.file_upload),
              onPressed: () async {
                // 使用file_picker选择文件
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: true, // 允许多选
                  type: FileType.custom,
                  allowedExtensions: ['txt', 'md'], // 允许的文件类型
                );

                if (result != null) {
                  // 获取应用目录
                  final directory = await getApplicationDocumentsDirectory();
                  final fnoteDir = p.join(directory.path, 'Fnote');
                  String appDocPath = fnoteDir;

                  // 复制文件到应用目录
                  for (PlatformFile file in result.files) {
                    File sourceFile = File(file.path!);
                    File targetFile = File('$appDocPath/${file.name}');
                    await sourceFile.copy(targetFile.path);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}