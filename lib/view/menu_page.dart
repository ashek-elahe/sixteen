import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/auth_controller.dart';
import 'package:nub/controller/theme_controller.dart';
import 'package:nub/controller/translation_controller.dart';
import 'package:nub/dialog/animated_dialog.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/routes.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/my_app_bar.dart';
import 'package:nub/widget/menu_button.dart';

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
            onPressed: () async {

              showAnimatedDialog(Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.padding),
                  side: BorderSide(color: Theme.of(Get.context!).disabledColor, width: 0.5),
                ),
                child: Container(
                  padding: const EdgeInsets.all(Constants.padding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Constants.padding),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text('password_reset_mail_sending'.tr, style: fontRegular.copyWith(color: Theme.of(Get.context!).canvasColor)),
                  ]),
                ),
              ), isFlip: true);

              await Get.find<AuthController>().resetPassword(Get.find<AuthController>().user!.email!);
              Get.back();

            },
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(
            icon: Icons.chat, title: 'message'.tr,
            onPressed: () => Get.toNamed(Routes.getConversationRoute()),
          ),
          const SizedBox(height: Constants.padding),

          if(Get.find<AuthController>().isAdmin) ...[

            MenuButton(
              icon: Icons.notification_add, title: 'send_notification'.tr,
              onPressed: () => Get.toNamed(Routes.getNotificationRoute()),
            ),
            const SizedBox(height: Constants.padding),

            MenuButton(
              icon: Icons.list_alt, title: 'installments'.tr,
              onPressed: () => Get.toNamed(Routes.getInstallmentsRoute()),
            ),
            const SizedBox(height: Constants.padding),

            MenuButton(
              icon: Icons.request_page_outlined, title: 'installment_requests'.tr,
              onPressed: () => Get.toNamed(Routes.getInstallmentRequestsRoute()),
            ),
            const SizedBox(height: Constants.padding),

            MenuButton(
              icon: Icons.people_alt_outlined, title: 'member_requests'.tr,
              onPressed: () => Get.toNamed(Routes.getMemberRequestsRoute()),
            ),
            const SizedBox(height: Constants.padding),

          ],

          MenuButton(
            icon: Icons.calculate_outlined, title: 'other_accounts'.tr,
            onPressed: () => Get.toNamed(Routes.getAccountsRoute()),
          ),
          const SizedBox(height: Constants.padding),

          MenuButton(
            icon: Icons.account_balance_sharp, title: 'payment_accounts'.tr,
            onPressed: () => Get.toNamed(Routes.getPaymentAccountsRoute()),
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
          const SizedBox(height: Constants.padding),

          Center(child: Text('${'version'.tr}: ${Constants.version}', style: fontMedium.copyWith(fontSize: 12))),

        ]),
      ),
    );
  }
}
