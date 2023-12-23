import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/user_widget.dart';

class UserDetailsPage extends StatefulWidget {
  final UserModel user;
  const UserDetailsPage({super.key, required this.user});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().getPersonInstallments(uid: widget.user.uid!, reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.user.name ?? ''),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(Constants.padding),
        child: Column(children: [

          UserWidget(user: widget.user),
          const SizedBox(height: Constants.padding),

          GetBuilder<InstallmentController>(builder: (insController) {
            return InstallmentsView(
              installments: insController.allInstallments, scrollController: _scrollController, enabledPagination: insController.allPaginate,
              onPaginate: () => Get.find<InstallmentController>().getPersonInstallments(uid: widget.user.uid!),
            );
          }),

        ]),
      ),
    );
  }
}
