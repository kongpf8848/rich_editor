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
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Column(children: [
      Divider(
          thickness: 1,
          color: isLight ? const Color(0xFFD1D5DB) : const Color(0xFF525252)),
    ]);
  }

  @override
  String toPlainText(Embed node) {
    return "";
  }
}
