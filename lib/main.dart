import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:rich_editor/quill/history_button.dart';
import 'package:rich_editor/quill/mobile_icon_theme.dart';
import 'package:rich_editor/quill/mobile_toolbar.dart';
import 'package:rich_editor/quill/rich_editor_util.dart';
import 'package:rich_editor/quill/embed_mention.dart';
import 'package:rich_editor/theme/app_theme.dart';

import 'model/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ));
    }
    return MaterialApp(
      title: 'flutter-quill-demo',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('zh', 'CN'),
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  QuillController? _quillController;
  MobileToolbar? _toolbar;
  QuillEditor? _quillEditor;
  final int maxLength = 10000;
  int preTextLength = 0;
  final ValueNotifier<bool> _editingStatusNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _saveStatusNotifier = ValueNotifier(false);
  final ValueNotifier<int> _plainTextNotifier = ValueNotifier(0);
  final List<User> userList = [
    User.fromJson({"uid": "1", "nickname": "张涛", "avatar": '', 'letter': "Z"}),
    User.fromJson({"uid": "2", "nickname": "李伟", "avatar": '', 'letter': "L"}),
    User.fromJson({"uid": "3", "nickname": "王小君", "avatar": '', 'letter': "W"}),
    User.fromJson({"uid": "4", "nickname": "马冰", "avatar": '', 'letter': "M"}),
    User.fromJson({"uid": "5", "nickname": "林圣贤", "avatar": '', 'letter': "L"}),
    User.fromJson({"uid": "6", "nickname": "陈风", "avatar": '', 'letter': "C"}),
    User.fromJson({"uid": "7", "nickname": "杨志", "avatar": '', 'letter': "Y"}),
    User.fromJson({"uid": "8", "nickname": "韩磊", "avatar": '', 'letter': "H"}),
    User.fromJson({"uid": "9", "nickname": "郭天明", "avatar": '', 'letter': "G"}),
  ];

  @override
  void initState() {
    super.initState();
    _loadFromAssets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quillController?.removeListener(_textChangeListener);
    _quillController?.dispose();
    super.dispose();
  }

  /// 将光标跳转到编辑器尾部
  void _moveToQuillBottom() {
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _quillController?.moveCursorToEnd();
    });
  }

  /// 加载模版
  Future<void> _loadFromAssets() async {
    try {
      final summary = await rootBundle.loadString('assets/template.json');
      setState(() {
        _editingStatusNotifier.value = true;
        if (_quillController != null) {
          _quillController?.removeListener(_textChangeListener);
          _quillController?.dispose();
        }
        _quillController = createQuillController(context, summary: summary);
        _quillController!.addListener(_textChangeListener);
        if (_editingStatusNotifier.value) {
          _moveToQuillBottom();
        }
      });
    } catch (error) {
      debugPrint('++++++++_loadFromAssets error:$error');
      setState(() {
        _editingStatusNotifier.value = true;
        final doc = Document()..insert(0, 'Empty asset');
        _quillController = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  void _textChangeListener() {
    debugPrint('++++++++++++++_textChangeListener');
    int curTextLength = getQuillLength(_quillController);
    _plainTextNotifier.value = getPlainTextLength(_quillController);
    _saveStatusNotifier.value = (curTextLength > 0);
    if (curTextLength > 1 && (curTextLength > preTextLength)) {
      final index = _quillController!.selection.baseOffset;
      if (index > 0) {
        var value = _quillController!.plainTextEditingValue.text;
        var newString = value.substring(index - 1, index);
        if (newString == '@') {
          _onMentionPressed();
        }
      }
    }
    preTextLength = curTextLength;
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: createNavigationBar(),
      body: Material(
        color: Theme.of(context).twColors.primaryBackgroundColor,
        child: SafeArea(
          top: false,
          child: _buildBody(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildBody() {
    return QuillProvider(
        configurations: QuillConfigurations(controller: _quillController!),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    createMeetingTopicWidget(),
                    const SizedBox(
                      height: 5,
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: _editingStatusNotifier,
                        builder: (context, value, _) {
                          return Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (value) createDivider(),
                                _getQuillEditor(
                                    readOnly: !value, autoFocus: value),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<bool>(
                valueListenable: _editingStatusNotifier,
                builder: ((context, value, _) {
                  return value ? _getMobileToolbar() : const SizedBox.shrink();
                }))
          ],
        ));
  }

  CupertinoNavigationBar createNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: Theme.of(context).twColors.primaryBackgroundColor,
      border: null,
      leading: createCloseWidget(),
      middle: createTextCountWidget(),
      trailing: ValueListenableBuilder(
        valueListenable: _editingStatusNotifier,
        builder: (BuildContext context, bool flag, Widget? child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: flag
                ? [
                    createUndoRedoWidget(true),
                    const SizedBox(
                      width: 6,
                    ),
                    createUndoRedoWidget(false),
                    const SizedBox(
                      width: 6,
                    ),
                    createSaveWidget(flag)
                  ]
                : [createSaveWidget(flag)],
          );
        },
      ),
    );
  }

  Widget createSaveWidget(bool flag) {
    return GestureDetector(
      onTap: onClickSave,
      child: Text(
        flag ? "保存" : "编辑",
        style: TextStyle(
          color: Theme.of(context).twColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }

  ///关闭按钮
  Widget? createCloseWidget() {
    return GestureDetector(
      onTap: () async {
        exit(0);
      },
      child: Image.asset(
        "images/ic_close.png",
        color: Theme.of(context).twColors.iconTintColor,
        height: 20,
        width: 20,
      ),
    );
  }

  void onClickSave() {
    debugPrint('++++++++++++json:${getQuillJson(_quillController)}');
    _editingStatusNotifier.value = !_editingStatusNotifier.value;
    if (_editingStatusNotifier.value) {
      _focusNode.requestFocus();
      _moveToQuillBottom();
    }
  }

  Widget createTextCountWidget() {
    return ValueListenableBuilder<int>(
        valueListenable: _plainTextNotifier,
        builder: (context, value, _) {
          return Text("已输入$value字",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).twColors.secondTextColor,
              ));
        });
  }

  Widget createUndoRedoWidget(bool undo) {
    if (_quillController != null) {
      return UndoRedoButton(
        icon: undo ? "images/quill/ic_undo.png" : "images/quill/ic_redo.png",
        controller: _quillController!,
        undo: undo,
        iconTheme: MobileIconTheme(
            iconUnselectedFillColor: Colors.transparent,
            iconSelectedFillColor: Colors.transparent,
            iconUnselectedColor: Theme.of(context).twColors.iconTintColor,
            disabledIconColor:
                Theme.of(context).twColors.iconTintColor!.withOpacity(0.5)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  ///会议主题
  createMeetingTopicWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        "周一质量监控方案讨论会",
        textAlign: TextAlign.left,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).twColors.primaryTextColor),
      ),
    );
  }

  //分割线
  createDivider() {
    return Divider(
        thickness: 1, color: Theme.of(context).twColors.dividerBackgroundColor);
  }

  Widget _getQuillEditor({
    required bool readOnly,
    required bool autoFocus,
  }) {
    debugPrint('++++++++++++++_getQuillEditor:${_quillController != null}');
    if (_quillController != null) {
      _quillEditor = createQuillEditor(context,
          controller: _quillController!,
          scrollController: _scrollController,
          focusNode: _focusNode,
          readOnly: readOnly,
          autoFocus: autoFocus,
          scrollable: false,
          paddingBottom: 30.0,
          hint: "请输入内容",
          userId: "1");
    }
    return _quillEditor ?? const SizedBox.shrink();
  }

  Widget _getMobileToolbar() {
    _toolbar = createMobileToolbar(context,
        controller: _quillController!,
        afterButtonPressed: _focusNode.requestFocus,
        onMentionPressed: _onMentionPressed);
    return Column(
      children: [
        Divider(
          thickness: 0.8,
          height: 0.8,
          color: Theme.of(context).twColors.dividerBackgroundColor,
        ),
        _toolbar!
      ],
    );
  }

  void _insertMention(User? user) {
    if (user == null) {
      return;
    }
    if (_quillController == null) {
      return;
    }
    final index = _quillController!.selection.extentOffset;
    var value = _quillController!.plainTextEditingValue.text;
    if (value.trim().isNotEmpty) {
      var newString = value.substring(index - 1, index);
      if (newString == '@') {
        _quillController!.document.delete(index - 1, 1);
        _quillController!.updateSelection(
          TextSelection.collapsed(
            offset: _quillController!.selection.extentOffset + 1,
          ),
          ChangeSource.local,
        );
      }
    }
    var data = {
      'index': '0',
      'denotationChar': '',
      'uid': user.uid,
      'nickname': user.nickname,
    };
    _quillController!.document
        .insert(_quillController!.selection.extentOffset, ' ');
    _quillController!.updateSelection(
      TextSelection.collapsed(
        offset: _quillController!.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );
    _quillController!.document
        .insert(_quillController!.selection.extentOffset, MentionEmbed(data));
    _quillController!.updateSelection(
      TextSelection.collapsed(
        offset: _quillController!.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );
    _quillController!.document
        .insert(_quillController!.selection.extentOffset, ' ');
    _quillController!.updateSelection(
      TextSelection.collapsed(
        offset: _quillController!.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );
  }

  void _onMentionPressed() async {
    debugPrint('+++++++++++++++++++++++_onMentionPressed');
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).twColors.dialogBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9),
            topRight: Radius.circular(9),
          ),
        ),
        builder: (context) {
          return ListView.builder(
              itemCount: userList.length,
              itemExtent: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Align(
                    widthFactor: 1.0,
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).twColors.primary,
                      child: Text(
                        userList[index].letter,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  title: Text(
                    userList[index].nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).twColors.primaryTextColor,
                        fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _insertMention(userList[index]);
                  },
                );
              });
        });
  }
}
