import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final bool isLoading;
  final Function() onOkPressed;
  const ConfirmationDialog({super.key, required this.message, required this.onOkPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
        side: BorderSide(color: Theme.of(context).disabledColor, width: 0.5),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.padding, vertical: 30),
          child: Text(message, style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
        ),

        isLoading ? const Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Center(child: CircularProgressIndicator()),
        ) : Row(children: [
          Expanded(child: InkWell(
            onTap: () => Get.back(),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Constants.padding)),
                color: Theme.of(context).cardColor,
              ),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Text('cancel'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
            ),
          )),
          Expanded(child: InkWell(
            onTap: onOkPressed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(Constants.padding)),
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Text('confirm'.tr, style: fontMedium.copyWith(color: Colors.white)),
            ),
          )),
        ]),

      ]),
    );
  }
}
