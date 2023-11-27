import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/user_controller.dart';
import 'package:sixteen/dialog/add_installment_dialog.dart';
import 'package:sixteen/dialog/add_member_dialog.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/dialog/confirmation_dialog.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/user_widget.dart';
import 'package:sixteen/widget/my_app_bar.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {

  @override
  void initState() {
    super.initState();

    Get.find<UserController>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'members'.tr, backButton: false),
      floatingActionButton: Get.find<AuthController>().isAdmin ? FloatingActionButton.extended(
        onPressed: () => showAnimatedDialog(const AddMemberDialog()),
        label: Text('add_member'.tr, style: fontMedium.copyWith(color: Colors.white)),
      ) : null,
      body: GetBuilder<UserController>(builder: (userController) {
        return userController.users != null ? userController.users!.isNotEmpty ? ListView.builder(
          itemCount: userController.users!.length,
          padding: const EdgeInsets.all(Constants.padding),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: Constants.padding),
              child: Slidable(
                enabled: Get.find<AuthController>().isAdmin,
                startActionPane: ActionPane(
                  extentRatio: 0.3,
                  motion: const ScrollMotion(),
                  children: [SlidableAction(
                    onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                      message: 'are_you_sure_to_delete_this_account'.tr,
                      onOkPressed: () {},
                    ), isFlip: true),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'delete'.tr,
                  )],
                ),

                endActionPane: ActionPane(
                  extentRatio: 0.5,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => showAnimatedDialog(AddInstallmentDialog(user: userController.users![index])),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.add_comment,
                      label: 'info'.tr,
                      spacing: 2,
                      padding: EdgeInsets.zero,
                    ),
                    SlidableAction(
                      onPressed: (context) => showAnimatedDialog(AddInstallmentDialog(user: userController.users![index])),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      icon: Icons.add_comment,
                      label: 'add_new_installment'.tr,
                      spacing: 2,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),

                child: UserWidget(user: userController.users![index], showBalance: Get.find<AuthController>().isAdmin),
              ),
            );
          },
        ) : Center(child: Text(
          'no_member_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
        )) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
