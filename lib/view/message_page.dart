import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/message_controller.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/message_model.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/emoji_text_editor.dart';
import 'package:sixteen/widget/my_app_bar.dart';

class MessagePage extends StatefulWidget {
  final ConversationModel conversation;
  const MessagePage({super.key, required this.conversation});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<MessageController>().getConversationAndMessages(conversation: widget.conversation);
  }

  @override
  void dispose() {
    Get.find<MessageController>().cancelListeningMessage();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: Get.find<MessageController>().getReceiverName(widget.conversation) ?? ''),
      body: Column(children: [

        Expanded(child: GetBuilder<MessageController>(builder: (messageController) {
          return messageController.messages != null ? messageController.messages!.isNotEmpty ? ListView.builder(
            itemCount: messageController.messages!.length,
            reverse: true,
            itemBuilder: (context, index) {
              MessageModel message = messageController.messages![index];
              bool isMe = messageController.isMe(message);

              return BubbleSpecialThree(
                text: message.message ?? '',
                color: const Color(0xFF1B97F3),
                textStyle: fontRegular.copyWith(color: Colors.white),
                tail: index == 0 || (messageController.isMe(messageController.messages![index])
                    != messageController.isMe(messageController.messages![index -1])),
                seen: isMe && message.isSeen!,
                delivered: isMe,
                sent: isMe,
                isSender: !isMe,
              );
            },
          ) : Center(child: Text(
            'no_message_found'.tr,
            style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
          )) : const Center(child: CircularProgressIndicator());
        })),

        const EmojiTextEditor(),

      ]),
    );
  }
}
