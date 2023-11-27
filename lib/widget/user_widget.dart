import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/card_widget.dart';
import 'package:sixteen/widget/custom_image.dart';
import 'package:sixteen/widget/info_widget.dart';

class UserWidget extends StatelessWidget {
  final UserModel user;
  final bool showBalance;
  const UserWidget({super.key, required this.user, this.showBalance = false});

  @override
  Widget build(BuildContext context) {
    return CardWidget(child: Row(children: [

      Expanded(child: Column(children: [

        InfoWidget(title: 'name'.tr, value: user.name),
        const SizedBox(height: 5),

        InfoWidget(title: 'phone'.tr, value: user.phone),
        const SizedBox(height: 5),

        InfoWidget(title: 'email'.tr, value: user.email),
        const SizedBox(height: 5),

        InfoWidget(title: 'joined_at'.tr, value: Helper.getDateDistance(user.joiningDate ?? DateTime.now())),
        const SizedBox(height: 5),

        InfoWidget(title: 'address'.tr, value: user.address),

      ])),
      const SizedBox(width: 10),

      Column(children: [

        showBalance ? Container(
          margin: const EdgeInsets.only(bottom: Constants.padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            Converter.convertAmount(user.balance ?? 0),
            style: fontMedium.copyWith(fontSize: 12, color: Theme.of(context).canvasColor),
          ),
        ) : const SizedBox(),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CustomImage(image: user.image ?? '', height: 80, width: 80),
          ),
        ),

      ]),

    ]));
  }
}
