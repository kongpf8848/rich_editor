import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:rich_editor/quill/toolbar_style_button.dart';
import 'package:rich_editor/quill/toolbar_link_button.dart';

import '../theme/app_theme.dart';
import 'mobile_icon_button.dart';
import 'mobile_icon_theme.dart';

class MobileToolbar extends StatelessWidget {
  const MobileToolbar({
    required this.controller,
    required this.backgroundColor,
    this.iconTheme,
    this.onMentionPressed,
    this.afterButtonPressed,
    Key? key,
  }) : super(key: key);

  final double toolbarIconSize = 24.0;
  final QuillController? controller;
  final Color? backgroundColor;
  final MobileIconTheme? iconTheme;
  final VoidCallback? onMentionPressed;
  final VoidCallback? afterButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tightFor(
        height: toolbarIconSize * 2,
      ),
      color: backgroundColor,
      child: Row(children: [
        _buildScrollableList(context),
        _buildKeyboardButton(context),
      ]),
    );
  }

  Widget _buildScrollableList(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final fillColor = iconTheme?.iconUnselectedFillColor ?? theme.canvasColor;

    List<Widget> widgetList = [];
    widgetList.add(const SizedBox(width: 16));
    widgetList.add(MobileIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 36,
      icon: Image.asset('images/quill/toolbar_mention.png',
          width: 24, height: 24, color: iconColor),
      fillColor: fillColor,
      onPressed: onMentionPressed,
      afterPressed: afterButtonPressed,
      borderRadius: iconTheme?.borderRadius ?? 2,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.h1,
      icon: 'images/quill/toolbar_h1.png',
      iconSize: toolbarIconSize,
      tooltip: 'H1',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.h2,
      icon: 'images/quill/toolbar_h2.png',
      iconSize: toolbarIconSize,
      tooltip: 'H2',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.bold,
      icon: 'images/quill/toolbar_bold.png',
      iconSize: toolbarIconSize,
      tooltip: 'Bold',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.italic,
      icon: 'images/quill/toolbar_italic.png',
      iconSize: toolbarIconSize,
      tooltip: 'italic',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.underline,
      icon: 'images/quill/toolbar_underline.png',
      iconSize: toolbarIconSize,
      tooltip: 'underline',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.strikeThrough,
      icon: 'images/quill/toolbar_strike.png',
      iconSize: toolbarIconSize,
      tooltip: 'strikeThrough',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.ol,
      icon: 'images/quill/toolbar_ordered.png',
      iconSize: toolbarIconSize,
      tooltip: 'ol',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: Attribute.ul,
      icon: 'images/quill/toolbar_bullet.png',
      iconSize: toolbarIconSize,
      tooltip: 'ul',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarLinkButton(
      icon: Icons.bolt,
      iconSize: toolbarIconSize,
      tooltip: 'link',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(ToolbarStyleButton(
      attribute: const BackgroundAttribute('#FF984E'),
      icon: 'images/quill/toolbar_highlight.png',
      iconSize: toolbarIconSize,
      tooltip: 'highlight',
      controller: controller!,
      iconTheme: iconTheme,
      afterButtonPressed: afterButtonPressed,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(MobileIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: 36,
      icon: Image.asset('images/quill/toolbar_divider.png',
          width: 24, height: 24, color: iconColor),
      fillColor: fillColor,
      onPressed: () {
        _insertDivider(context, controller!);
      },
      afterPressed: afterButtonPressed,
      borderRadius: iconTheme?.borderRadius ?? 2,
    ));
    widgetList.add(const SizedBox(width: 20));

    widgetList.add(const SizedBox(width: 16));

    return Expanded(
      child: ScrollConfiguration(
        behavior: _NoGlowBehavior(),
        child: CustomScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widgetList,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardButton(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(-2, 0),
            blurRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Image.asset(
          'images/quill/toolbar_keyboard.png',
          width: 24,
          height: 24,
          color: Theme.of(context).twColors.iconTintColor,
        ),
        iconSize: 24,
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          //widget.afterButtonPressed?.call();
        },
      ),
    );
  }

  Future<void> _insertDivider(
      BuildContext context, QuillController controller) async {
    final index = controller.selection.baseOffset;

    controller.document.insert(index, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );

    //清除格式
    final attrs = <Attribute>{};
    for (final style in controller.getAllSelectionStyles()) {
      for (final attr in style.attributes.values) {
        attrs.add(attr);
      }
    }
    for (final attr in attrs) {
      controller.formatSelection(Attribute.clone(attr, null));
    }

    controller.document.insert(index + 1, const BlockEmbed("divider", "true"));
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );

    controller.document.insert(index + 2, '\n');
    controller.updateSelection(
      TextSelection.collapsed(
        offset: controller.selection.extentOffset + 1,
      ),
      ChangeSource.local,
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  Widget buildViewportChrome(BuildContext _, Widget child, AxisDirection __) {
    return child;
  }
}
