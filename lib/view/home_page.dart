import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/user_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().getInstallments(uid: Get.find<AuthController>().getUserData()!.uid!, isMine: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        leading: Center(child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(Constants.logoTransparent, height: 40, width: 40),
        )),
        title: Text(Constants.appName, style:fontBold.copyWith(color: Theme.of(context).canvasColor, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Constants.padding),
        child: Column(children: [

          GetBuilder<AuthController>(builder: (authController) {
            return UserWidget(user: authController.getUserData()!);
          }),
          const SizedBox(height: Constants.padding),

          Text('installments'.tr, style: fontBold.copyWith(fontSize: 20, color: Theme.of(context).canvasColor)),
          const SizedBox(height: 10),

          GetBuilder<InstallmentController>(builder: (insController) {
            return insController.installments != null ? insController.installments!.isNotEmpty ? ListView.builder(
              itemCount: insController.installments!.length,
              itemBuilder: (context, index) {
                InstallmentModel installment = insController.installments![index];

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Row(children: [
                    
                    Expanded(flex: 7, child: Column(children: [
                      
                      Text(
                        Converter.dateToMonth(installment.month!),
                        style: fontBold.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
                      ),
                      const SizedBox(height: 5),

                      Row(children: [
                        Text('${'received_by'.tr}:', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
                        const SizedBox(width: 5),
                        Expanded(child: Text(installment.receiverName ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
                      ]),
                      
                    ])),

                    DottedLine(direction: Axis.vertical, dashColor: Theme.of(context).disabledColor),

                    Expanded(flex: 3, child: Column(children: [

                      Text(
                        installment.amount?.toStringAsFixed(0) ?? '0',
                        style: fontBlack.copyWith(fontSize: 25, color: Theme.of(context).canvasColor),
                      ),
                      const SizedBox(height: 5),

                      Text('BDT', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),

                    ])),
                    
                  ]),
                );
              },
            ) : Center(child: Text(
              'no_installment_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
            )) : const Center(child: CircularProgressIndicator());
          }),

        ]),
      ),
    );
  }
}
