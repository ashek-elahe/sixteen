import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/animated_entrance_widget.dart';
import 'package:sixteen/widget/custom_image.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/input_field.dart';
import 'package:sixteen/widget/loading_button.dart';
import 'package:sixteen/widget/my_app_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _addressNode = FocusNode();
  UserModel user = Get.find<AuthController>().user!;

  @override
  void initState() {
    super.initState();

    _nameController.text = user.name ?? '';
    _phoneController.text = user.phone ?? '';
    _emailController.text = user.email ?? '';
    _addressController.text = user.address ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'edit_profile'.tr),
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
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return CustomImage(image: authController.user!.image ?? '', height: 100, width: 100);
                  }),
                ),

                InkWell(
                  onTap: () => Get.find<AuthController>().updateProfileImage(buttonController: _buttonController),
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
              nextFocus: _emailNode,
              inputType: TextInputType.phone,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.left, child: InputField(
              titleText: 'email'.tr,
              hintText: 'enter_your_email_address'.tr,
              controller: _emailController,
              focusNode: _emailNode,
              nextFocus: _addressNode,
              inputType: TextInputType.emailAddress,
              isEnabled: false,
            )),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.right, child: InputField(
              titleText: 'address'.tr,
              hintText: 'enter_your_address'.tr,
              controller: _addressController,
              focusNode: _addressNode,
              inputAction: TextInputAction.done,
              inputType: TextInputType.streetAddress,
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
              if(name.isEmpty) {
                showSnackBar(message: 'enter_your_name'.tr);
                _buttonController.error();
              }else if(phone.isEmpty) {
                showSnackBar(message: 'enter_your_phone_number'.tr);
                _buttonController.error();
              }else if(!GetUtils.isPhoneNumber(phone)) {
                showSnackBar(message: 'enter_valid_phone_number'.tr);
                _buttonController.error();
              }else if(email.isEmpty) {
                showSnackBar(message: 'enter_your_email_address'.tr);
                _buttonController.error();
              }else if(!GetUtils.isEmail(email)) {
                showSnackBar(message: 'enter_valid_email_address'.tr);
                _buttonController.error();
              }else if(address.isEmpty) {
                showSnackBar(message: 'enter_your_address'.tr);
                _buttonController.error();
              }else {
                Get.find<AuthController>().updateUserProfile(user: UserModel(
                  uid: user.uid, name: name, phone: phone, email: email, address: address,
                ), buttonController: _buttonController);
              }
            },
            child: Text('update'.tr, style: fontMedium.copyWith(color: Colors.white)),
          ),
        )),

      ])),
    );
  }
}
