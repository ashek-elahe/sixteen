import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/constants.dart';

class BaseDialog extends StatelessWidget {
  final List<Widget> children;
  const BaseDialog({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
        side: BorderSide(color: Theme.of(context).disabledColor, width: 0.5),
      ),
      child: Stack(children: [

        Container(
          padding: const EdgeInsets.all(Constants.padding),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: children),
        ),

        Positioned(
          top: 0, right: 0,
          child: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.cancel, color: Colors.red)),
        ),

      ]),
    );
  }
}
