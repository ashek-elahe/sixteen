import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/splash_controller.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/animated_entrance_widget.dart';
import 'package:nub/widget/custom_snackbar.dart';
import 'package:nub/widget/input_field.dart';
import 'package:nub/widget/loading_button.dart';
import 'package:nub/widget/my_app_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _titleNode = FocusNode();
  final FocusNode _messageNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'send_notification'.tr),
      body: Column(children: [

        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.padding),
          child: Column(children: [

            AnimatedEntranceWidget(entrance: Entrance.left, child: Hero(tag: 'title', child: InputField(
              titleText: 'title'.tr,
              hintText: 'enter_the_title'.tr,
              controller: _titleController,
              focusNode: _titleNode,
              nextFocus: _messageNode,
              inputType: TextInputType.text,
              capitalization: TextCapitalization.words,
            ))),
            const SizedBox(height: 20),

            AnimatedEntranceWidget(entrance: Entrance.right, child: Hero(tag: 'message', child: InputField(
              titleText: 'message'.tr,
              hintText: 'enter_the_message'.tr,
              controller: _messageController,
              focusNode: _messageNode,
              inputAction: TextInputAction.done,
              inputType: TextInputType.text,
              maxLines: 5,
              capitalization: TextCapitalization.sentences,
            ))),
            const SizedBox(height: 20),

          ]),
        )),

        AnimatedEntranceWidget(entrance: Entrance.bottom, child: Padding(
          padding: const EdgeInsets.all(Constants.padding),
          child: LoadingButton(
            controller: _buttonController,
            onPressed: () async {
              String title = _titleController.text.trim();
              String message = _messageController.text.trim();
              if(title.isEmpty) {
                showSnackBar(message: 'enter_the_title'.tr);
                _buttonController.error();
              }else if(message.isEmpty) {
                showSnackBar(message: 'enter_the_message'.tr);
                _buttonController.error();
              }else {
                bool success = await Get.find<SplashController>().sendNotification(toTopic: true, token: '', title: title, body: message);
                if(success) {
                  _buttonController.success();
                  Get.back();
                  showSnackBar(message: 'notification_sent_successfully'.tr, isError: false);
                }else {
                  _buttonController.error();
                }
              }
            },
            child: Text('send'.tr, style: fontMedium.copyWith(color: Colors.white)),
          ),
        )),

      ]),
    );
  }
}
