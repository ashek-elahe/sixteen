import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/card_widget.dart';

class BalanceView extends StatelessWidget {
  const BalanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(child: GetBuilder<SplashController>(builder: (splashController) {
      return Column(children: [

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [

          Text('${'balance'.tr}:', style: fontRegular.copyWith(color: Theme.of(context).canvasColor, fontSize: 18)),
          const SizedBox(width: 5),

          Text(
            Converter.convertAmount((splashController.settings!.installments! + splashController.settings!.others!) - splashController.settings!.cost!),
            style: fontMedium.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
          ),

        ]),
        const SizedBox(height: 10),

        Row(children: [

          Expanded(child: BalancePortion(title: 'installments'.tr, balance: splashController.settings!.installments!)),

          Expanded(child: BalancePortion(title: 'others'.tr, balance: splashController.settings!.others!)),

          Expanded(child: BalancePortion(title: 'total_cost'.tr, balance: splashController.settings!.cost!)),

        ]),

      ]);
    }));
  }
}

class BalancePortion extends StatelessWidget {
  final String title;
  final double balance;
  const BalancePortion({super.key, required this.title, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Text(Converter.convertAmount(balance), style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
      const SizedBox(height: 5),

      Text(title, style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),

    ]);
  }
}
