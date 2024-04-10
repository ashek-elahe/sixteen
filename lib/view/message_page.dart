import 'dart:io';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixteen/controller/message_controller.dart';
import 'package:sixteen/model/conversation_model.dart';
import 'package:sixteen/model/message_model.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/custom_image.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
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

  Future<String?> _getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      debugPrint("Cannot get download folder path: $stack");
    }
    return directory?.path;
  }

  static var httpClient = HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String? dir = await _getDownloadPath();
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    showSnackBar(message: '$filename ${'downloaded_to'.tr}: $dir', isError: false);
    return file;
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

                return Column(children: [

                  BubbleSpecialThree(
                    text: message.message ?? '',
                    color: isMe ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
                    textStyle: fontRegular.copyWith(color: isMe ? Colors.white : Colors.black),
                    tail: index == 0 || (messageController.isMe(messageController.messages![index])
                        != messageController.isMe(messageController.messages![index -1])),
                    seen: isMe && (messageController.getReceiverUnreadCount(messageController.conversation!)! < _senderMessageCount),
                    delivered: isMe,
                    sent: isMe,
                    isSender: isMe,
                  ),

                  (message.attachments != null && message.attachments!.isNotEmpty) ? SizedBox(height: 60, child: ListView.builder(
                    itemCount: message.attachments!.length,
                    scrollDirection: Axis.horizontal,
                    reverse: isMe,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      String extension = Uri.parse(message.attachments![index]).path.split('.').last;
                      String name = Uri.parse(message.attachments![index]).path.split('/').last;

                      return Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Helper.isImage(extension) ? ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CustomImage(
                            image: message.attachments![index],
                            height: 50, width: 50, fit: BoxFit.cover,
                          ),
                        ) : InkWell(
                          onTap: () {
                            _downloadFile(message.attachments![index], name);
                          },
                          child: Container(
                            height: 50, width: 50, alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              extension.toUpperCase(),
                              style: fontRegular.copyWith(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ),
                      );
                    },
                  )) : const SizedBox()

                ]);
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
