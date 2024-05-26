import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:nub/controller/auth_controller.dart';
import 'package:nub/controller/user_controller.dart';
import 'package:nub/dialog/action_dialog.dart';
import 'package:nub/dialog/add_installment_dialog.dart';
import 'package:nub/dialog/add_member_dialog.dart';
import 'package:nub/dialog/animated_dialog.dart';
import 'package:nub/dialog/confirmation_dialog.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/routes.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/user_widget.dart';
import 'package:nub/widget/my_app_bar.dart';

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
        return userController.users != null ? userController.users!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<UserController>().getUsers();
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          child: ListView.builder(
            itemCount: userController.users!.length,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Constants.padding),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Constants.padding),
                child: Slidable(
                  startActionPane: Get.find<AuthController>().isAdmin ? ActionPane(
                    extentRatio: 0.3,
                    motion: const ScrollMotion(),
                    children: [SlidableAction(
                      onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                        message: 'are_you_sure_to_delete_this_account'.tr,
                        isLoading: userController.isLoading,
                        onOkPressed: () {
                          Get.find<UserController>().deleteAccount(userController.users![index]);
                        },
                      ), isFlip: true),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'delete'.tr,
                    )],
                  ) : null,

                  endActionPane: ActionPane(
                    extentRatio: Get.find<AuthController>().isAdmin ? 0.5 : 0.3,
                    motion: const DrawerMotion(),
                    children: [

                      if(Get.find<AuthController>().isAdmin)...[SlidableAction(
                        onPressed: (context) => showAnimatedDialog(AddInstallmentDialog(user: userController.users![index], isSelf: false)),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        icon: Icons.add_comment,
                        label: 'add_new_installment'.tr,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                      )],

                      SlidableAction(
                        onPressed: (context) => showAnimatedDialog(ActionDialog(user: userController.users![index]), isFlip: true),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.more_horiz,
                        label: 'actions'.tr,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                      ),

                    ],
                  ),

                  child: InkWell(
                    onTap: Get.find<AuthController>().isAdmin ? () => Get.toNamed(Routes.getUserDetailsRoute(userController.users![index])) : null,
                    child: UserWidget(user: userController.users![index], showBalance: Get.find<AuthController>().isAdmin),
                  ),
                ),
              );
            },
          ),
        ) : Center(child: Text(
          'no_member_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
        )) : ListView.builder(
          itemCount: 20,
          padding: const EdgeInsets.all(Constants.padding),
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: Constants.padding),
            child: UserShimmer(),
          ),
        );
      }),
    );
  }
}
