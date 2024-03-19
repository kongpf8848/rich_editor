import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

import 'link_util.dart';
import 'mobile_icon_button.dart';
import 'mobile_icon_theme.dart';

class ToolbarLinkButton extends StatefulWidget {
  const ToolbarLinkButton({
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.icon,
    this.iconTheme,
    this.dialogTheme,
    this.afterButtonPressed,
    this.tooltip,
    this.linkRegExp,
    this.linkDialogAction,
    Key? key,
  }) : super(key: key);

  final QuillController controller;
  final IconData? icon;
  final double iconSize;
  final MobileIconTheme? iconTheme;
  final QuillDialogTheme? dialogTheme;
  final VoidCallback? afterButtonPressed;
  final String? tooltip;
  final RegExp? linkRegExp;
  final LinkDialogAction? linkDialogAction;

  @override
  _ToolbarLinkButtonState createState() => _ToolbarLinkButtonState();
}

class _ToolbarLinkButtonState extends State<ToolbarLinkButton> {
  void _didChangeSelection() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeSelection);
  }

  @override
  void didUpdateWidget(covariant ToolbarLinkButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeSelection);
      widget.controller.addListener(_didChangeSelection);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_didChangeSelection);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToggled = _getLinkAttributeValue() != null;
    return MobileIconButton(
      tooltip: widget.tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: 36,
      icon: Image.asset(
        'images/quill/toolbar_link.png',
        width: widget.iconSize,
        height: widget.iconSize,
        color: isToggled
            ? (widget.iconTheme?.iconSelectedColor ??
                theme.primaryIconTheme.color)
            : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color),
      ),
      fillColor: isToggled
          ? (widget.iconTheme?.iconSelectedFillColor ??
              Theme.of(context).primaryColor)
          : (widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor),
      borderRadius: widget.iconTheme?.borderRadius ?? 2,
      onPressed: () => _openLinkDialog(context),
      afterPressed: widget.afterButtonPressed,
    );
  }

  void _openLinkDialog(BuildContext context) {
    showDialog<TextLink>(
      context: context,
      builder: (ctx) {
        var link = _getLinkAttributeValue();
        final index = widget.controller.selection.start;

        var text;
        if (link != null) {
          // text should be the link's corresponding text, not selection
          final leaf =
              widget.controller.document.querySegmentLeafNode(index).leaf;
          if (leaf != null) {
            text = leaf.toPlainText();
          }
        }

        final len = widget.controller.selection.end - index;
        text ??=
            len == 0 ? '' : widget.controller.document.getPlainText(index, len);
        return LinkDialog(
          link: link,
          text: text,
        );
      },
    ).then(
      (value) {
        if (value != null) _linkSubmitted(value);
      },
    );
  }

  String? _getLinkAttributeValue() {
    return widget.controller
        .getSelectionStyle()
        .attributes[Attribute.link.key]
        ?.value;
  }

  TextRange getLinkRange(Node node) {
    var start = node.documentOffset;
    var length = node.length;
    var prev = node.previous;
    final linkAttr = node.style.attributes[Attribute.link.key]!;
    while (prev != null) {
      if (prev.style.attributes[Attribute.link.key] == linkAttr) {
        start = prev.documentOffset;
        length += prev.length;
        prev = prev.previous;
      } else {
        break;
      }
    }

    var next = node.next;
    while (next != null) {
      if (next.style.attributes[Attribute.link.key] == linkAttr) {
        length += next.length;
        next = next.next;
      } else {
        break;
      }
    }
    return TextRange(start: start, end: start + length);
  }

  void _linkSubmitted(TextLink value) {
    var index = widget.controller.selection.start;
    var length = widget.controller.selection.end - index;
    debugPrint('++++++++++++++_linkSubmitted,index:$index,length:$length');
    if (_getLinkAttributeValue() != null) {
      // text should be the link's corresponding text, not selection
      final leaf = widget.controller.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        final range = getLinkRange(leaf);
        index = range.start;
        length = range.end - range.start;
      }
    }
    widget.controller.replaceText(index, length, value.text, null);
    widget.controller
        .formatText(index, value.text.length, LinkAttribute(value.link));
    widget.controller.updateSelection(
        TextSelection.collapsed(
          offset: index + value.text.length,
        ),
        ChangeSource.local);
  }
}
