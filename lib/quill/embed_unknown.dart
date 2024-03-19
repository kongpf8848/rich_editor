import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class UnknownEmbedBuilder extends EmbedBuilder {
  @override
  String get key => '*********';

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return const SizedBox.shrink();
  }

  @override
  String toPlainText(Embed node) {
    return "";
  }
}
