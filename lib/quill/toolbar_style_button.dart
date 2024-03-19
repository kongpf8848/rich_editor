import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:rich_editor/quill/mobile_icon_button.dart';
import 'package:rich_editor/quill/mobile_icon_theme.dart';

typedef ToolbarStyleButtonBuilder = Widget Function(
  BuildContext context,
  Attribute attribute,
  String icon,
  Color? fillColor,
  bool? isToggled,
  VoidCallback? onPressed,
  VoidCallback? afterPressed, [
  double iconSize,
  MobileIconTheme? iconTheme,
]);

class ToolbarStyleButton extends StatefulWidget {
  const ToolbarStyleButton({
    required this.attribute,
    required this.icon,
    required this.controller,
    this.iconSize = kDefaultIconSize,
    this.fillColor,
    this.childBuilder = defaultToolbarStyleButtonBuilder,
    this.iconTheme,
    this.afterButtonPressed,
    this.tooltip,
    Key? key,
  }) : super(key: key);

  final Attribute attribute;

  final String icon;
  final double iconSize;

  final Color? fillColor;

  final QuillController controller;

  final ToolbarStyleButtonBuilder childBuilder;

  ///Specify an icon theme for the icons in the toolbar
  final MobileIconTheme? iconTheme;

  final VoidCallback? afterButtonPressed;
  final String? tooltip;

  @override
  _ToolbarStyleButtonState createState() => _ToolbarStyleButtonState();
}

class _ToolbarStyleButtonState extends State<ToolbarStyleButton> {
  bool? _isToggled;

  Style get _selectionStyle => widget.controller.getSelectionStyle();

  @override
  void initState() {
    super.initState();
    _isToggled = _getIsToggled(_selectionStyle.attributes);
    widget.controller.addListener(_didChangeEditingValue);
  }

  @override
  Widget build(BuildContext context) {
    return UtilityWidgets.maybeTooltip(
      message: widget.tooltip,
      child: widget.childBuilder(
        context,
        widget.attribute,
        widget.icon,
        widget.fillColor,
        _isToggled,
        _toggleAttribute,
        widget.afterButtonPressed,
        widget.iconSize,
        widget.iconTheme,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ToolbarStyleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggled = _getIsToggled(_selectionStyle.attributes);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  void _didChangeEditingValue() {
    setState(() => _isToggled = _getIsToggled(_selectionStyle.attributes));
  }

  bool _getIsToggled(Map<String, Attribute> attrs) {
    if (widget.attribute.key == Attribute.list.key ||
        widget.attribute.key == Attribute.script.key ||
        widget.attribute.key == Attribute.header.key) {
      final attribute = attrs[widget.attribute.key];
      if (attribute == null) {
        return false;
      }
      return attribute.value == widget.attribute.value;
    }
    return attrs.containsKey(widget.attribute.key);
  }

  void _toggleAttribute() {
    widget.controller.formatSelection(_isToggled!
        ? Attribute.clone(widget.attribute, null)
        : widget.attribute);
  }
}

Widget defaultToolbarStyleButtonBuilder(
  BuildContext context,
  Attribute attribute,
  String icon,
  Color? fillColor,
  bool? isToggled,
  VoidCallback? onPressed,
  VoidCallback? afterPressed, [
  double iconSize = kDefaultIconSize,
  MobileIconTheme? iconTheme,
]) {
  final theme = Theme.of(context);
  final isEnabled = onPressed != null;
  final iconColor = isEnabled
      ? isToggled == true
          ? (iconTheme?.iconSelectedColor ??
              theme
                  .primaryIconTheme.color) //You can specify your own icon color
          : (iconTheme?.iconUnselectedColor ?? theme.iconTheme.color)
      : (iconTheme?.disabledIconColor ?? theme.disabledColor);
  final fill = isEnabled
      ? isToggled == true
          ? (iconTheme?.iconSelectedFillColor ??
              Theme.of(context).primaryColor) //Selected icon fill color
          : (iconTheme?.iconUnselectedFillColor ??
              theme.canvasColor) //Unselected icon fill color :
      : (iconTheme?.disabledIconFillColor ??
          (fillColor ?? theme.canvasColor)); //Disabled icon fill color
  Widget widget = Image.asset(
    icon,
    width: iconSize,
    height: iconSize,
    color: iconColor,
  );
  return MobileIconButton(
    highlightElevation: 0,
    hoverElevation: 0,
    size: 36,
    icon: widget,
    fillColor: fill,
    onPressed: onPressed,
    afterPressed: afterPressed,
    borderRadius: iconTheme?.borderRadius ?? 2,
  );
}
