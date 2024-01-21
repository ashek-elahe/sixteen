import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/message_controller.dart';
import 'package:nub/model/conversation_model.dart';
import 'package:nub/utilities/converter.dart';
import 'package:nub/utilities/routes.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/custom_image.dart';
import 'package:nub/widget/my_app_bar.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {

  @override
  void initState() {
    super.initState();

    Get.find<MessageController>().getConversations();
  }

  @override
  void dispose() {
    Get.find<MessageController>().cancelListeningConversation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'conversations'.tr),
      body: GetBuilder<MessageController>(builder: (messageController) {
        return messageController.conversations != null ? messageController.conversations!.isNotEmpty ? ListView.separated(
          itemCount: messageController.conversations!.length,
          separatorBuilder: (context, index) => Divider(color: Theme.of(context).disabledColor),
          itemBuilder: (context, index) {
            ConversationModel conversation = messageController.conversations![index];
            return ListTile(
              onTap: () => Get.toNamed(Routes.getMessagesRoute(conversation)),

              leading: ClipOval(child: CustomImage(image: messageController.getReceiverImage(conversation), height: 50, width: 50)),

              title: Row(children: [

                Expanded(child: Text(
                  messageController.getReceiverName(conversation) ?? '',
                  style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: 10),

                Text(
                  Converter.dateToTime(conversation.lastMessageTime!),
                  style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
                )

              ]),

              subtitle: Text(conversation.lastMessage ?? '', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),

              trailing: messageController.getMyUnreadCount(conversation)! > 0 ? Container(
                height: 20, width: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  messageController.getMyUnreadCount(conversation).toString(),
                  style: fontRegular.copyWith(color: Colors.white, fontSize: 12),
                ),
              ) : const SizedBox(),

            );
          },
        ) : Center(child: Text(
          'no_conversation_found'.tr,
          style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
        )) : const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
