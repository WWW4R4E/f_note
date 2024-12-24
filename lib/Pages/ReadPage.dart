import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_markdown_latex/flutter_markdown_latex.dart';
import 'package:markdown/markdown.dart' as md;

class ReadPage extends StatelessWidget {
  final String title;
  final String text;

  ReadPage({Key? key, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(title),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          selectable: true,
          data: text,
          builders: {
            'latex': LatexElementBuilder(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w100,
              ),
              textScaleFactor: 1.2,
            ),
          },
          extensionSet: md.ExtensionSet(
            [LatexBlockSyntax()],
            [LatexInlineSyntax()],
          ),
        ),
      ),
    );
  }
}