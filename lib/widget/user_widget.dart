import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/card_widget.dart';
import 'package:sixteen/widget/custom_image.dart';

class UserWidget extends StatelessWidget {
  final UserModel user;
  final bool showBalance;
  const UserWidget({super.key, required this.user, this.showBalance = false});

  @override
  Widget build(BuildContext context) {
    double imageSize = 70;

    return Stack(children: [

      CardWidget(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Stack(children: [

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CustomImage(image: user.image ?? '', height: imageSize, width: imageSize),
            ),
          ),

          !user.isActive! ? Positioned(
            top: 0, bottom: 0, left: 0, right: 0,
            child: Container(
              width: imageSize, height: imageSize,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ) : const SizedBox(),

        ]),
        const SizedBox(width: 20),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

          RichText(text: TextSpan(
            text: (user.name != null && user.name!.isNotEmpty) ? user.name! : 'N/A',
            style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 16),
            children: [TextSpan(
              text: Get.find<AuthController>().isAnAdmin(user.email!) ? ' (${'admin'.tr})' : '',
              style: fontMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: 10),
            )],
          )),
          const SizedBox(height: 2),

          Text(
            Helper.getDateDistance(user.joiningDate ?? DateTime.now()),
            style: fontRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: 12),
          ),
          const SizedBox(height: 2),

          (user.phone != null && user.phone!.isNotEmpty) ? Text(
            (user.phone != null && user.phone!.isNotEmpty) ? user.phone! : 'N/A',
            style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
          ) : const SizedBox(),
          SizedBox(height: (user.phone != null && user.phone!.isNotEmpty) ? 2 : 0),

          Text(
            (user.email != null && user.email!.isNotEmpty) ? user.email! : 'N/A',
            style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
          ),
          const SizedBox(height: 2),

          (user.address != null && user.address!.isNotEmpty) ? Text(
            (user.address != null && user.address!.isNotEmpty) ? user.address! : 'N/A',
            style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
          ) : const SizedBox(),

        ])),

      ])),

      showBalance ? Positioned(
        top: -5, right: 0,
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
            color: Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            Converter.convertAmount(user.balance ?? 0),
            style: fontMedium.copyWith(fontSize: 12, color: Colors.white),
          ),
        ),
      ) : const SizedBox(),

    ]);
  }
}

class UserShimmer extends StatelessWidget {
  const UserShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWidget(child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Container(
          height: 70, width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
            border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(width: 20),

        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Container(height: 20, width: 250, color: Colors.grey[300]),
          const SizedBox(height: 10),

          Container(height: 10, width: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),

          Container(height: 15, width: 150, color: Colors.grey[300]),
          const SizedBox(height: 10),

          Container(height: 15, width: 120, color: Colors.grey[300]),
          const SizedBox(height: 10),

          Container(height: 10, width: 200, color: Colors.grey[300]),
          const SizedBox(height: 5),

          Container(height: 10, width: 200, color: Colors.grey[300]),

        ])),

      ]),
    ));
  }
}
