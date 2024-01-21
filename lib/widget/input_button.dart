import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/utilities/style.dart';

class InputButton extends StatelessWidget {
  final String text;
  final bool hasValue;
  final VoidCallback onPressed;
  const InputButton({Key? key, required this.text, required this.hasValue, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius, side: BorderSide(style: BorderStyle.solid, width: 0.3, color: Theme.of(context).primaryColor)),
        minimumSize: Size(context.width, 50), maximumSize: Size(context.width, 50), alignment: Alignment.centerLeft,
        backgroundColor: Theme.of(context).cardColor, elevation: 0, padding: const EdgeInsets.only(left: 10),
      ),
      child: Text(text, style: fontRegular.copyWith(color: hasValue ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).hintColor)),
    );
  }
}
