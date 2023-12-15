import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/dialog/base_dialog.dart';
import 'package:sixteen/dialog/confirmation_dialog.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/style.dart';

class ActionDialog extends StatelessWidget {
  final UserModel user;
  const ActionDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    UserModel me = Get.find<AuthController>().user!;
    return BaseDialog(children: [

      Text(user.name ?? '', style: fontMedium.copyWith(fontSize: 14, color: Theme.of(context).canvasColor)),
      const SizedBox(height: Constants.padding),

      ActionButton(title: 'info'.tr, onPressed: () => Get.toNamed(Routes.getUserDetailsRoute(user))),

      ActionButton(title: 'send_message'.tr, onPressed: () => Get.toNamed(Routes.getMessagesRoute(ConversationModel(
        user1Id: user.uid, user1Email: user.email, user1Phone: user.phone, user1Name: user.name, user1Image: user.image,
        user2Id: me.uid, user2Email: me.email, user2Phone: me.phone, user2Name: me.name, user2Image: me.image,
      )))),

      ActionButton(title: 'poke_for_installment'.tr, onPressed: () => Get.find<SplashController>().sendNotification(
        toTopic: false, token: user.deviceToken ?? '', title: 'Hello ${user.name}', body: 'please_complete_your_installment_of_this_month'.tr,
      )),

      ActionButton(
        title: Get.find<SplashController>().isAdmin(user.email!) ? 'remove_from_admin'.tr : 'mark_as_admin'.tr,
        onPressed: () => showAnimatedDialog(ConfirmationDialog(
          message: Get.find<SplashController>().isAdmin(user.email!) ? 'remove_from_admin'.tr : 'mark_as_admin'.tr,
          onOkPressed: () {
            Get.back();
            Get.find<SplashController>().updateAdmin(user.email!, !Get.find<SplashController>().isAdmin(user.email!));
          },
        )),
      ),

    ]);
  }
}

class ActionButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  const ActionButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
        onPressed();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        width: context.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(title, style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
      ),
    );
  }
}
