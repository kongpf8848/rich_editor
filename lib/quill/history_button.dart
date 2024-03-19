import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'mobile_icon_button.dart';
import 'mobile_icon_theme.dart';

class UndoRedoButton extends StatefulWidget {
  const UndoRedoButton({
    required this.icon,
    required this.controller,
    required this.undo,
    this.iconSize = 24,
    this.iconTheme,
    this.afterButtonPressed,
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final String icon;
  final double iconSize;
  final bool undo;
  final QuillController controller;
  final MobileIconTheme? iconTheme;
  final VoidCallback? afterButtonPressed;
  final String? tooltip;

  @override
  _UndoRedoButtonState createState() => _UndoRedoButtonState();
}

class _UndoRedoButtonState extends State<UndoRedoButton> {
  Color? _iconColor;
  late ThemeData theme;

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);
    _setIconColor();

    final fillColor =
        widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor;
    widget.controller.changes.listen((event) async {
      _setIconColor();
    });
    return MobileIconButton(
      tooltip: widget.tooltip,
      highlightElevation: 0,
      hoverElevation: 0,
      size: 36,
      icon: Image.asset(widget.icon,
          width: widget.iconSize, height: widget.iconSize, color: _iconColor),
      fillColor: fillColor,
      borderRadius: widget.iconTheme?.borderRadius ?? 2,
      onPressed: _changeHistory,
      afterPressed: widget.afterButtonPressed,
    );
  }

  void _setIconColor() {
    if (!mounted) return;

    if (widget.undo) {
      setState(() {
        _iconColor = widget.controller.hasUndo
            ? widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color
            : widget.iconTheme?.disabledIconColor ?? theme.disabledColor;
      });
    } else {
      setState(() {
        _iconColor = widget.controller.hasRedo
            ? widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color
            : widget.iconTheme?.disabledIconColor ?? theme.disabledColor;
      });
    }
  }

  void _changeHistory() {
    if (widget.undo) {
      if (widget.controller.hasUndo) {
        widget.controller.undo();
      }
    } else {
      if (widget.controller.hasRedo) {
        widget.controller.redo();
      }
    }

    _setIconColor();
  }
}
