import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixteen/controller/message_controller.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/message_model.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/emoji_text_editor.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

class MessagePage extends StatefulWidget {
  final ConversationModel conversation;
  const MessagePage({super.key, required this.conversation});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final ScrollController _scrollController = ScrollController();
  int _senderMessageCount = 0;

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
          return messageController.messages != null ? messageController.messages!.isNotEmpty ? PaginatedListView(
            scrollController: _scrollController,
            reverse: true,
            enabledPagination: messageController.paginate,
            onPaginate: () => messageController.getMessages(id: messageController.conversation!.id!),
            itemView: Expanded(child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              itemCount: messageController.messages!.length,
              reverse: true,
              itemBuilder: (context, index) {
                if(index == 0) {
                  _senderMessageCount = 0;
                }
                MessageModel message = messageController.messages![index];
                bool isMe = messageController.isMe(message);
                if(isMe) {
                  _senderMessageCount++;
                }

                return BubbleSpecialThree(
                  text: message.message ?? '',
                  color: isMe ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
                  textStyle: fontRegular.copyWith(color: isMe ? Colors.white : Colors.black),
                  tail: index == 0 || (messageController.isMe(messageController.messages![index])
                      != messageController.isMe(messageController.messages![index -1])),
                  seen: isMe && (messageController.getReceiverUnreadCount(messageController.conversation!)! < _senderMessageCount),
                  delivered: isMe,
                  sent: isMe,
                  isSender: isMe,
                );
              },
            )),
          ) : Center(child: Text(
            'no_message_found'.tr,
            style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
          )) : const BubbleShimmer();
        })),

        const EmojiTextEditor(),

      ]),
    );
  }
}

class BubbleShimmer extends StatelessWidget {
  const BubbleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: 20,
      reverse: true,
      itemBuilder: (context, index) {
        bool isMe = index % 2 == 0;

        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: BubbleSpecialThree(
            text: 'IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII',
            color: isMe ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
            textStyle: fontRegular.copyWith(color: Colors.grey[300]),
            tail: true,
            seen: false,
            delivered: isMe,
            sent: isMe,
            isSender: isMe,
          ),
        );
      },
    );
  }
}
