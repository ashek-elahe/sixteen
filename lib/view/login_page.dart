import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/routes.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/animated_entrance_widget.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/input_field.dart';
import 'package:sixteen/widget/loading_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().initData();
    _passwordNode.addListener(() {
      if(_passwordNode.hasFocus) {
        Get.find<AuthController>().setLoginState(LoginState.eyeClose);
      }else {
        Get.find<AuthController>().setLoginState(LoginState.idle);
      }
    });
  }

  @override
  void dispose() {
    _passwordNode.removeListener(() { });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [

          Hero(
            tag: 'logo',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.padding),
              child: Image.asset(Constants.logo, height: 100, width: 100),
            ),
          ),

          GetBuilder<AuthController>(builder: (authController) {
            return SizedBox(height: 300, width: 300, child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: RiveAnimation.asset(
                Constants.loginCharacter.file,
                animations: [Constants.loginCharacter.animations[authController.loginState == LoginState.eyeOpen ? 2
                    : authController.loginState == LoginState.eyeClose ? 1 : authController.loginState == LoginState.fail ? 4
                    : authController.loginState == LoginState.success ? 3 : 0]],
              ),
            ));
          }),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(Get.isDarkMode ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(children: [

              AnimatedEntranceWidget(
                entrance: Entrance.top,
                child: Text('login'.tr.toUpperCase(), style: fontBlack.copyWith(fontSize: 30)),
              ),
              const SizedBox(height: 30),

              AnimatedEntranceWidget(entrance: Entrance.left, child: Hero(tag: 'email', child: InputField(
                titleText: 'email'.tr,
                hintText: 'enter_your_email_address'.tr,
                controller: _emailController,
                focusNode: _emailNode,
                nextFocus: _passwordNode,
                inputType: TextInputType.emailAddress,
              ))),
              const SizedBox(height: 20),

              AnimatedEntranceWidget(entrance: Entrance.right, child: Hero(tag: 'password', child: InputField(
                titleText: 'password'.tr,
                hintText: 'enter_your_password'.tr,
                controller: _passwordController,
                focusNode: _passwordNode,
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
                onEyeToggle: (bool eyeClosed) => Get.find<AuthController>().setLoginState(eyeClosed ? LoginState.eyeClose : LoginState.eyeOpen),
              ))),

              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.getForgotRoute()),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('forgot_password'.tr, style: fontMedium.copyWith(fontSize: 14, color: Colors.red)),
                  ),
                ),
              ),

              AnimatedEntranceWidget(entrance: Entrance.bottom, child: Hero(tag: 'auth_button', child: LoadingButton(
                controller: _buttonController,
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordController.text.trim();
                  if(email.isEmpty) {
                    showSnackBar(message: 'enter_your_email_address'.tr);
                    error();
                  }else if(!GetUtils.isEmail(email)) {
                    showSnackBar(message: 'enter_valid_email_address'.tr);
                    error();
                  }else if(password.isEmpty) {
                    showSnackBar(message: 'enter_your_password'.tr);
                    error();
                  }else {
                    Get.find<AuthController>().login(email: email, password: password, buttonController: _buttonController);
                  }
                },
                child: Text('login'.tr, style: fontMedium.copyWith(color: Colors.white)),
              ))),

            ]),
          ),

        ]),
      )),
    );
  }

  void error() {
    Get.find<AuthController>().setLoginState(LoginState.fail);
    _buttonController.error();
  }

}
