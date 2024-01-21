import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/dialog/add_installment_dialog.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/balance_view.dart';
import 'package:sixteen/widget/balance_widget.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/user_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().getMyInstallments(uid: Get.find<AuthController>().user!.uid!, reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0, elevation: 0.5,
        backgroundColor: Theme.of(context).cardColor,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        leading: Center(child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(Constants.logoTransparent, height: 40, width: 40),
        )),
        title: Text(Constants.appName, style:fontBold.copyWith(color: Theme.of(context).canvasColor, fontSize: 20)),
        actions: [Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: GetBuilder<AuthController>(builder: (authController) {
            return BalanceWidget(balance: authController.user!.balance ?? 0);
          }),
        )],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => showAnimatedDialog(AddInstallmentDialog(user: Get.find<AuthController>().user!, isSelf: true)),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<AuthController>().getUser(uid: Get.find<AuthController>().user!.uid!);
          await Get.find<InstallmentController>().getMyInstallments(uid: Get.find<AuthController>().user!.uid!, reload: true);
          await Get.find<SplashController>().getSettings();
        },
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(Constants.padding),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(children: [

            GetBuilder<AuthController>(builder: (authController) {
              return UserWidget(user: authController.user!);
            }),
            const SizedBox(height: Constants.padding),

            InkWell(
              onTap: () => Get.toNamed(Routes.getAccountsRoute()),
              child: const BalanceView(),
            ),
            const SizedBox(height: Constants.padding),

            GetBuilder<InstallmentController>(builder: (insController) {
              return InstallmentsView(
                installments: insController.installments, scrollController: _scrollController, enabledPagination: insController.paginate,
                onPaginate: () => Get.find<InstallmentController>().getMyInstallments(uid: Get.find<AuthController>().user!.uid!),
              );
            }),

          ]),
        ),
      ),
    );
  }
}
