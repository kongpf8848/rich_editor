import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart';

class DividerEmbedBuilder extends EmbedBuilder {
  @override
  String get key => "divider";

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return const Column(children: [
      Divider(thickness: 1, color: Colors.grey),
    ]);
  }

  @override
  String toPlainText(Embed node) {
    return "";
  }
}
