import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/theme_controller.dart';
import 'package:sixteen/controller/translation_controller.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/menu_button.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'menu'.tr, backButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.padding),
        child: Column(children: [

          MenuButton(
            icon: Icons.edit, title: 'edit_profile'.tr,
            onPressed: () => Get.toNamed(Routes.getEditProfileRoute()),
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(
            icon: Icons.lock_reset, title: 'change_password'.tr,
            onPressed: () => Get.find<AuthController>().resetPassword(Get.find<AuthController>().getUserData()!.email!),
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(
            icon: Icons.language, title: 'language'.tr,
            trailing: GetBuilder<TranslationController>(builder: (transController) {
              return Text(
                transController.locale.languageCode.toUpperCase(),
                style: fontBold.copyWith(color: Theme.of(context).canvasColor),
              );
            }),
            onPressed: () => Get.find<TranslationController>().toggleLanguage(),
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(
            icon: Icons.dark_mode_outlined, title: 'theme'.tr,
            trailing: GetBuilder<ThemeController>(builder: (themeController) {
              return Icon(
                themeController.isDark ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).canvasColor,
                size: 18,
              );
            }),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(icon: Icons.logout, title: 'logout'.tr, onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Get.offAllNamed(Routes.getLoginRoute());
          }),

        ]),
      ),
    );
  }
}
