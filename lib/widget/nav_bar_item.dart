import 'package:flutter/material.dart';
import 'package:nub/utilities/style.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  const NavBarItem({super.key, required this.icon, required this.title, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50, width: 50,
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
        padding: const EdgeInsets.all(5),
        child: InkWell(
          onTap: onTap,
          child: Column(children: [

            Icon(icon, color: isSelected ? Colors.white : Theme.of(context).canvasColor, size: 20),

            Text(title, style: fontMedium.copyWith(
              color: isSelected ? Colors.white : Theme.of(context).canvasColor, fontSize: 12,
            )),

          ]),
        ),
      ),
    );
  }
}