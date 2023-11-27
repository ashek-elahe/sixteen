import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/style.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function? onBackPressed;
  const MyAppBar({Key? key, required this.title, this.backButton = true, this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: fontMedium.copyWith(fontSize: 16, color: Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: true,
      leading: backButton ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: () => onBackPressed != null ? onBackPressed!() : Get.back(),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      actions: const [SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
