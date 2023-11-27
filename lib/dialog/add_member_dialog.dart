import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/user_controller.dart';
import 'package:sixteen/dialog/base_dialog.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/input_field.dart';
import 'package:sixteen/widget/loading_button.dart';

class AddMemberDialog extends StatefulWidget {
  const AddMemberDialog({super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BaseDialog(children: [

      Text('add_member'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 20)),
      const SizedBox(height: Constants.padding),

      InputField(
        titleText: 'email'.tr,
        hintText: 'enter_your_email_address'.tr,
        controller: _emailController,
        focusNode: _emailNode,
        nextFocus: _passwordNode,
        inputType: TextInputType.emailAddress,
      ),
      const SizedBox(height: Constants.padding),

      InputField(
        titleText: 'password'.tr,
        hintText: 'enter_your_password'.tr,
        controller: _passwordController,
        focusNode: _passwordNode,
        inputAction: TextInputAction.done,
        inputType: TextInputType.visiblePassword,
        isPassword: true,
      ),
      const SizedBox(height: 30),

      LoadingButton(
        controller: _buttonController,
        onPressed: () async {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          if(email.isEmpty) {
            showSnackBar(message: 'enter_your_email_address'.tr);
            _buttonController.error();
          }else if(!GetUtils.isEmail(email)) {
            showSnackBar(message: 'enter_valid_email_address'.tr);
            _buttonController.error();
          }else if(password.isEmpty) {
            showSnackBar(message: 'enter_your_password'.tr);
            _buttonController.error();
          }else {
            Get.find<UserController>().addMember(email: email, password: password, buttonController: _buttonController);
          }
        },
        child: Text('add'.tr, style: fontMedium.copyWith(color: Colors.white)),
      ),

    ]);
  }
}
