import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:nub/controller/splash_controller.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/custom_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdatePage extends StatefulWidget {
  final bool isUpdate;
  const UpdatePage({super.key, required this.isUpdate});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          SizedBox(height: 300, width: 300, child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: RiveAnimation.asset(
              widget.isUpdate ? Constants.update.file : Constants.maintenance.file,
              animations: widget.isUpdate ? [
                Constants.update.animations[0], Constants.update.animations[1], Constants.update.animations[2],
                Constants.update.animations[3], Constants.update.animations[4], Constants.update.animations[5],
              ] : [Constants.maintenance.animations[0], Constants.maintenance.animations[1]],
            ),
          )),

          Padding(
            padding: const EdgeInsets.all(50),
            child: Text(
              widget.isUpdate ? 'a_newer_version_of_app_is_available'.tr : 'app_is_under_maintenance'.tr,
              style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 18), textAlign: TextAlign.center,
            ),
          ),

          widget.isUpdate ? CustomButton(
            buttonText: 'update'.tr,
            margin: const EdgeInsets.symmetric(horizontal: 50),
            onPressed: () async {
              if(await canLaunchUrlString(Get.find<SplashController>().settings!.appUrl!)) {
                launchUrlString(Get.find<SplashController>().settings!.appUrl!, mode: LaunchMode.externalApplication);
              }
            },
          ) : const SizedBox(),

        ]),
      ),
    );
  }
}
