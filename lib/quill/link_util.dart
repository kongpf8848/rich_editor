import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:rich_editor/theme/app_theme.dart';

class LinkDialog extends StatefulWidget {
  const LinkDialog({
    this.link,
    this.text,
    Key? key,
  }) : super(key: key);

  final String? link;
  final String? text;

  @override
  State<LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<LinkDialog> {
  late String _link;
  late String _text;
  late RegExp linkRegExp;
  late TextEditingController _linkController;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _link = widget.link ?? '';
    _text = widget.text ?? '';
    linkRegExp = AutoFormatMultipleLinksRule.linkRegExp;
    _linkController = TextEditingController(text: _link);
    _textController = TextEditingController(text: _text);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).twColors.primaryBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      title: const Text(
        '编辑链接',
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      titleTextStyle: TextStyle(
          color: Theme.of(context).twColors.primaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.bold),
      content: Container(
          constraints:
              BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('文本',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).twColors.primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 8),
              Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).twColors.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: Theme.of(context).twColors.primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis),
                    decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 15, right: 15),
                        hintText: '输入文本',
                        hintStyle: TextStyle(
                            color: Theme.of(context).twColors.thirdTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).twColors.primary!))),
                    autofocus: true,
                    onChanged: _textChanged,
                    controller: _textController,
                  )),
              const SizedBox(height: 20),
              Text('链接',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Theme.of(context).twColors.primaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  )),
              const SizedBox(height: 8),
              Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).twColors.inputBackgroundColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    style: TextStyle(
                        color: Theme.of(context).twColors.primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis),
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 15, right: 15),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).twColors.primary!)),
                      hintText: '粘贴或输入链接',
                      hintStyle: TextStyle(
                          color: Theme.of(context).twColors.thirdTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    autofocus: true,
                    onChanged: _linkChanged,
                    controller: _linkController,
                  )),
              const SizedBox(height: 20),
              Container(
                height: 36,
                alignment: Alignment.center,
                child: Row(children: [
                  Expanded(
                      child: getBottomButton('取消',
                          bgColor: Theme.of(context)
                              .twColors
                              .fillOffBackgroundColor,
                          textColor: Theme.of(context).twColors.secondTextColor,
                          onClick: () {
                    Navigator.of(context).pop();
                  })),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: getBottomButton(
                    '确定',
                    bgColor: (_canPress()
                        ? Theme.of(context).twColors.primary
                        : Theme.of(context).twColors.primaryDisable),
                    textColor: (_canPress()
                        ? Colors.white
                        : Colors.white.withOpacity(0.6)),
                    onClick: _canPress() ? _applyLink : null,
                  )),
                ]),
              )
            ],
          )),
      //actions: [_okButton(), _okButton()],
    );
  }

  Widget getBottomButton(String text,
      {Color? bgColor, Color? textColor, Function? onClick}) {
    return Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              onClick?.call();
            },
            child: Container(
                height: 32,
                alignment: Alignment.center,
                child: Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    )))));
  }

  bool _canPress() {
    if (_text.trim().isEmpty || _link.trim().isEmpty) {
      return false;
    }
    if (!linkRegExp.hasMatch(_link)) {
      return false;
    }

    return true;
  }

  void _linkChanged(String value) {
    setState(() {
      _link = value;
    });
  }

  void _textChanged(String value) {
    setState(() {
      _text = value;
    });
  }

  void _applyLink() {
    Navigator.pop(context, TextLink(_text.trim(), _link.trim()));
  }
}

class TextLink {
  TextLink(
    this.text,
    this.link,
  );

  final String text;
  final String link;
}
