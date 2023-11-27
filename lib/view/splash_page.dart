import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/widget/animated_zoom_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if(FirebaseAuth.instance.currentUser != null) {
        Get.offNamed(Routes.getInitialRoute());
      }else {
        Get.offNamed(Routes.getLoginRoute());
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

        ]),
      ),
    );
  }
}
