import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/user_controller.dart';
import 'package:nub/model/user_model.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/animated_entrance_widget.dart';
import 'package:nub/widget/custom_image.dart';
import 'package:nub/widget/custom_snackbar.dart';
import 'package:nub/widget/input_field.dart';
import 'package:nub/widget/loading_button.dart';
import 'package:nub/widget/my_app_bar.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _nameController.text = '';
    _phoneController.text = '';
    _emailController.text = '';
    _addressController.text = '';
    _passwordController.text = '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'registration'.tr),
      body: SafeArea(child: Column(children: [

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(children: [

            AnimatedEntranceWidget(entrance: Entrance.top, child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                border: Border.all(width: 0.5, color: Theme.of(context).primaryColor),
              ),
              child: Stack(children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GetBuilder<UserController>(builder: (userController) {
                    return userController.file != null ? Image.file(
                      File(userController.file!.path), height: 100, width: 100,
                    ) : const CustomImage(image: '', height: 100, width: 100);
                  }),
                ),

                InkWell(
                  onTap: () => Get.find<UserController>().pickImage(),
                  child: Container(
                    height: 100, width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white, size: 30),
                  ),
                ),

              ]),
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.left, child: InputField(
              titleText: 'name'.tr,
              hintText: 'enter_your_name'.tr,
              controller: _nameController,
              focusNode: _nameNode,
              nextFocus: _phoneNode,
              inputType: TextInputType.name,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.right, child: InputField(
              titleText: 'phone'.tr,
              hintText: 'enter_your_phone_number'.tr,
              controller: _phoneController,
              focusNode: _phoneNode,
              nextFocus: _addressNode,
              inputType: TextInputType.phone,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.left, child: InputField(
              titleText: 'address'.tr,
              hintText: 'enter_your_address'.tr,
              controller: _addressController,
              focusNode: _addressNode,
              nextFocus: _emailNode,
              inputType: TextInputType.streetAddress,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.right, child: InputField(
              titleText: 'email'.tr,
              hintText: 'enter_your_email_address'.tr,
              controller: _emailController,
              focusNode: _emailNode,
              nextFocus: _passwordNode,
              inputType: TextInputType.emailAddress,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.left, child: InputField(
              titleText: 'password'.tr,
              hintText: 'enter_your_password'.tr,
              controller: _passwordController,
              focusNode: _passwordNode,
              inputAction: TextInputAction.done,
              inputType: TextInputType.visiblePassword,
              isPassword: true,
            )),

          ]),
        )),

        AnimatedEntranceWidget(entrance: Entrance.bottom, child: Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: LoadingButton(
            controller: _buttonController,
            onPressed: () async {
              String name = _nameController.text.trim();
              String phone = _phoneController.text.trim();
              String email = _emailController.text.trim();
              String address = _addressController.text.trim();
              String password = _passwordController.text.trim();
              if(name.isEmpty) {
                showSnackBar(message: 'enter_your_name'.tr);
                _buttonController.error();
              }else if(phone.isEmpty) {
                showSnackBar(message: 'enter_your_phone_number'.tr);
                _buttonController.error();
              }else if(!GetUtils.isPhoneNumber(phone)) {
                showSnackBar(message: 'enter_valid_phone_number'.tr);
                _buttonController.error();
              }else if(!GetUtils.isEmail(email)) {
                showSnackBar(message: 'enter_valid_email_address'.tr);
                _buttonController.error();
              }else if(address.isEmpty) {
                showSnackBar(message: 'enter_your_address'.tr);
                _buttonController.error();
              }else if(email.isEmpty) {
                showSnackBar(message: 'enter_your_email_address'.tr);
                _buttonController.error();
              }else if(password.isEmpty) {
                showSnackBar(message: 'enter_your_password'.tr);
                _buttonController.error();
              }else {
                Get.find<UserController>().register(user: UserModel(
                  name: name, phone: phone, email: email, address: address,
                ), password: password, buttonController: _buttonController);
              }
            },
            child: Text('register'.tr, style: fontMedium.copyWith(color: Colors.white)),
          ),
        )),

      ])),
    );
  }
}
