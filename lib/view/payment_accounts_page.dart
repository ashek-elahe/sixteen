import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nub/controller/splash_controller.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/card_widget.dart';
import 'package:nub/widget/custom_snackbar.dart';
import 'package:nub/widget/my_app_bar.dart';

class PaymentAccountsPage extends StatefulWidget {
  const PaymentAccountsPage({super.key});

  @override
  State<PaymentAccountsPage> createState() => _PaymentAccountsPageState();
}

class _PaymentAccountsPageState extends State<PaymentAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'payment_accounts'.tr),
      body: GetBuilder<SplashController>(builder: (splashController) {
        return ListView.builder(
          padding: const EdgeInsets.all(Constants.padding),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: splashController.settings?.accounts?.length ?? 0,
          itemBuilder: (context, index) {
            Map<String, dynamic> account = splashController.settings!.accounts![index];

            return Padding(
              padding: const EdgeInsets.only(bottom: Constants.padding),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: account['Account No']));
                  showSnackBar(message: 'account_no_copied'.tr, isError: false);
                },
                child: CardWidget(title: account['Account'], child: ListView.builder(
                  itemCount: account.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, i) => Row(children: [
                    Text('${account.keys.elementAt(i)}: ', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
                    Text(account.values.elementAt(i).toString(), style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
                  ]),
                )),
              ),
            );
          },
        );
      }),
    );
  }
}
