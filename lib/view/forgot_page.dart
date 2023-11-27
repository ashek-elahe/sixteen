import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/custom_button.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/input_field.dart';
import 'package:sixteen/widget/my_app_bar.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'forgot_password'.tr),
      body: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

          Text(
            'enter_your_email_address_to_get_password_reset_mail'.tr,
            style: fontMedium, textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          InputField(
            titleText: 'email'.tr,
            hintText: 'enter_your_email_address'.tr,
            controller: _emailController,
            inputAction: TextInputAction.done,
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30),

          GetBuilder<AuthController>(builder: (authController) {
            return !authController.isLoading ? CustomButton(
              buttonText: 'send_mail'.tr,
              onPressed: () {
                String email = _emailController.text.trim();
                if(email.isEmpty) {
                  showSnackBar(message: 'enter_your_email_address'.tr);
                }else if(!GetUtils.isEmail(email)) {
                  showSnackBar(message: 'enter_valid_email_address'.tr);
                }else {
                  authController.resetPassword(email);
                }
              },
            ) : Center(child: CircularProgressIndicator(color: Theme.of(context).secondaryHeaderColor));
          }),

        ]),
      )),
    );
  }
}
