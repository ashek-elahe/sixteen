import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/splash_controller.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/animated_entrance_widget.dart';
import 'package:sixteen/widget/animated_zoom_widget.dart';
import 'package:sixteen/widget/custom_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic(Constants.topic);
    if(FirebaseAuth.instance.currentUser != null) {
      Get.find<AuthController>().getUser(uid: FirebaseAuth.instance.currentUser!.uid).then((success) {
        Get.find<AuthController>().updateDeviceToken();
        if(success) {
          route();
        }
      });
    }else {
      route();
    }
  }

  void route() {
    Get.find<SplashController>().getSettings().then((success) {
      if(success) {
        Get.find<AuthController>().setAdmin();
        Future.delayed(Duration(seconds: FirebaseAuth.instance.currentUser != null ? 1 : 3), () {
          if(Get.find<SplashController>().settings!.maintenance!
              || Get.find<SplashController>().settings!.minimumVersion! > Constants.version) {
            Get.offNamed(Routes.getUpdateRoute(Get.find<SplashController>().settings!.minimumVersion! > Constants.version));
          }else if(FirebaseAuth.instance.currentUser != null) {
            Get.offNamed(Routes.getInitialRoute());
          }else {
            Get.offNamed(Routes.getLoginRoute());
          }
        });
      }else {
        showSnackBar(message: 'please_exit_from_app'.tr);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          // SizedBox(
          //   height: 500, width: 500,
          //   child: FlareActor(
          //     Constants.work.file,
          //     animation: Constants.work.animations.first,
          //     alignment: Alignment.center,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Hero(
            tag: 'logo',
            child: AnimatedZoomWidget(
              isZoomIn: true, size: const Size(200, 200),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Constants.padding),
                child: Image.asset(Constants.logo, height: 200, width: 200),
              ),
            ),
          ),
          const SizedBox(height: 20),

          AnimatedEntranceWidget(
            entrance: Entrance.bottom,
            child: Text(Constants.slogan, style: fontMedium.copyWith(color: Colors.white, fontSize: 14)),
          ),

        ]),
      ),
    );
  }
}
