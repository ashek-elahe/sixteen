import 'package:flutter/material.dart';
import 'package:sixteen/utilities/style.dart';

class CustomDropdown extends StatefulWidget {
  final String title;
  final VoidCallback? onTap;
  const CustomDropdown({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: shadow,
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Expanded(child: Text(widget.title, style: fontRegular)),
          const Icon(Icons.arrow_drop_down),
        ]),
      ),
    );
  }
}
