import 'package:flutter/material.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/card_widget.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Function() onPressed;
  const MenuButton({super.key, required this.icon, required this.title, required this.onPressed, this.trailing});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: radius,
      child: CardWidget(
        padding: const EdgeInsets.all(10),
        child: Row(children: [

          Container(
            height: 35, width: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 20, color: Theme.of(context).canvasColor),
          ),
          const SizedBox(width: 10),

          Expanded(child: Text(title, style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
          const SizedBox(width: 10),

          trailing ?? Icon(Icons.navigate_next, size: 20, color: Theme.of(context).disabledColor),

        ]),
      ),
    );
  }
}
