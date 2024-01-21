import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nub/utilities/style.dart';

class InputField extends StatefulWidget {
  final String titleText;
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final bool isPassword;
  final bool isNumber;
  final BorderRadius? borderRadius;
  final Function(String text)? onChanged;
  final Function(String text)? onSubmit;
  final Function()? onTap;
  final Function(bool isClosed)? onEyeToggle;
  final Function(PointerDownEvent event)? onOutsideTap;
  final bool isEnabled;
  final int maxLines;
  final TextCapitalization capitalization;
  final IconData? prefixIcon;

  const InputField(
      {Key? key,
        required this.titleText,
        this.hintText = '',
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.isEnabled = true,
        this.isNumber = false,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        this.onSubmit,
        this.borderRadius,
        this.onChanged,
        this.onTap,
        this.onEyeToggle,
        this.onOutsideTap,
        this.prefixIcon,
        this.capitalization = TextCapitalization.none,
        this.isPassword = false,
      }) : super(key: key);

  @override
  InputFieldState createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Material(borderRadius: widget.borderRadius ?? radius, child: TextField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: fontRegular.copyWith(fontSize: 14),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: Theme.of(context).primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: (widget.inputType == TextInputType.phone || widget.inputType == TextInputType.number)
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
          : widget.inputType == const TextInputType.numberWithOptions(decimal: true, signed: true)
          ? [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))] : null,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? radius,
          borderSide: BorderSide(style: BorderStyle.solid, width: 0.3, color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? radius,
          borderSide: BorderSide(style: BorderStyle.solid, width: 1, color: Theme.of(context).primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? radius,
          borderSide: BorderSide(style: BorderStyle.solid, width: 0.3, color: Theme.of(context).primaryColor),
        ),
        isDense: true,
        hintText: widget.hintText,
        labelText: widget.titleText,
        alignLabelWithHint: true,
        floatingLabelStyle: fontRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: 16),
        fillColor: Theme.of(context).cardColor,
        hintStyle: fontRegular.copyWith(fontSize: 14, color: Theme.of(context).hintColor),
        filled: true,
        prefixIcon: widget.prefixIcon != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(widget.prefixIcon!, size: 20),
        ) : null,
        suffixIcon: widget.isPassword ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
          onPressed: _toggle,
        ) : null,
      ),
      onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : widget.onSubmit != null ? widget.onSubmit!(text) : null,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onTapOutside:  widget.onOutsideTap,
    ));
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
    if(widget.onEyeToggle != null) {
      widget.onEyeToggle!(_obscureText);
    }
  }

}
