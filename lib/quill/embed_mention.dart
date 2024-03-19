import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' as base;
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:rich_editor/theme/app_theme.dart';

class MentionEmbed extends Embeddable {
  const MentionEmbed(
    dynamic value,
  ) : super(mentionType, value);

  static const String mentionType = 'styled-mention';

  static MentionEmbed fromDocument(Document document) =>
      MentionEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class MentionEmbedBuilder extends EmbedBuilder {
  MentionEmbedBuilder({required this.currentUid});

  final String? currentUid;

  @override
  String get key => 'styled-mention';

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    base.Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final data = node.value.data;
    final text = "@${data['nickname']}";
    final isCurrentUser = currentUid == data['uid'];
    final textColor = (isCurrentUser ? Colors.white : Theme.of(context).twColors.primary);
    final style = TextStyle(
        color: textColor,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
        overflow: TextOverflow.ellipsis);

    if (isCurrentUser) {
      return Padding(
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99), color: Theme.of(context).twColors.primary),
            child: Text(
              text,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: style.copyWith(fontSize: 14),
            ),
          ));
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: style,
        ),
      );
    }
  }

  @override
  String toPlainText(Embed node) {
    final data = node.value.data;
    return "@${data['nickname']}";
  }
}
