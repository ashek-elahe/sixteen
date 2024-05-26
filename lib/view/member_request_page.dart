import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:nub/controller/user_controller.dart';
import 'package:nub/dialog/animated_dialog.dart';
import 'package:nub/dialog/confirmation_dialog.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/my_app_bar.dart';
import 'package:nub/widget/user_widget.dart';

class MemberRequestPage extends StatefulWidget {
  const MemberRequestPage({super.key});

  @override
  State<MemberRequestPage> createState() => _MemberRequestPageState();
}

class _MemberRequestPageState extends State<MemberRequestPage> {

  @override
  void initState() {
    super.initState();

    Get.find<UserController>().getMemberRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(title: 'member_requests'.tr),
      body: GetBuilder<UserController>(builder: (userController) {
        return userController.userRequests != null ? userController.userRequests!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<UserController>().getMemberRequest();
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          child: ListView.builder(
            itemCount: userController.userRequests!.length,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Constants.padding),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: Constants.padding),
                child: Slidable(
                  startActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: const ScrollMotion(),
                    children: [SlidableAction(
                      onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                        message: 'are_you_sure_to_delete_this_account'.tr,
                        isLoading: userController.isLoading,
                        onOkPressed: () {
                          Get.find<UserController>().deleteAccount(userController.userRequests![index]);
                        },
                      ), isFlip: true),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'delete'.tr,
                    )],
                  ),

                  endActionPane: ActionPane(
                    extentRatio: 0.3,
                    motion: const DrawerMotion(),
                    children: [SlidableAction(
                      onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                        message: 'are_you_sure_to_approve_this_account'.tr,
                        isLoading: userController.isLoading,
                        onOkPressed: () {
                          Get.find<UserController>().approveUser(userController.userRequests![index].email!);
                        },
                      ), isFlip: true),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      icon: Icons.check,
                      label: 'approve'.tr,
                    )],
                  ),

                  child: UserWidget(user: userController.userRequests![index], showBalance: false),
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
