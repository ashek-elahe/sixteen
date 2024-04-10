import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sixteen/controller/message_controller.dart';
import 'package:sixteen/utilities/helper.dart';
import 'package:sixteen/utilities/style.dart';

class EmojiTextEditor extends StatefulWidget {
  const EmojiTextEditor({super.key});

  @override
  State<EmojiTextEditor> createState() => _EmojiTextEditorState();
}

class _EmojiTextEditorState extends State<EmojiTextEditor> {
  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onBackspacePressed() {
    _controller..text = _controller.text.characters.toString()..selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      GetBuilder<MessageController>(builder: (messageController) {
        return messageController.attachments.isNotEmpty ? SizedBox(height: 60, child: ListView.builder(
          itemCount: messageController.attachments.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(5),
          itemBuilder: (context, index) {
            XFile file = messageController.attachments[index];
            String extension = file.name.split('.').last;

            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Stack(children: [
                Helper.isImage(extension) ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(
                    File(file.path),
                    height: 50, width: 50, fit: BoxFit.cover,
                  ),
                ) : Container(
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
                Positioned(
                  top: 0, right: 0,
                  child: InkWell(
                    onTap: () => messageController.removeAttachment(index),
                    child: const Icon(Icons.close, color: Colors.red, size: 15),
                  ),
                ),
              ]),
            );
          },
        )) : const SizedBox();
      }),

      Container(height: 66.0 + MediaQuery.of(context).padding.bottom, color: Theme.of(context).primaryColor, child: SafeArea(
        child: Row(children: [

          Material(color: Colors.transparent, child: IconButton(
            onPressed: () {
              setState(() {
                emojiShowing = !emojiShowing;
              });
            },
            icon: const Icon(Icons.emoji_emotions, color: Colors.white),
          )),

          Material(color: Colors.transparent, child: IconButton(
            onPressed: () => Get.find<MessageController>().pickAttachments(),
            icon: const Icon(Icons.feed, color: Colors.white),
          )),

          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _controller,
              style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'type_a_message'.tr,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
              ),
            ),
          )),

          Material(color: Colors.transparent, child: GetBuilder<MessageController>(builder: (messageController) {
            return IconButton(
              onPressed: () async {
                if(!messageController.isLoading) {
                  bool success = await messageController.sendMessage(reply: _controller.text.trim());
                  if(success) {
                    _controller.text = '';
                  }
                }
              },
              icon: messageController.isLoading ? const CircularProgressIndicator(
                backgroundColor: Colors.white,
              ) : const Icon(Icons.send, color: Colors.white),
            );
          })),

        ]),
      )),

      Offstage(
        offstage: !emojiShowing,
        child: SizedBox(height: 250, child: EmojiPicker(
          textEditingController: _controller,
          onBackspacePressed: _onBackspacePressed,
          config: Config(
            columns: 7,
            emojiSizeMax: 32 * (GetPlatform.isIOS ? 1.30 : 1.0),
            verticalSpacing: 0,
            horizontalSpacing: 0,
            gridPadding: EdgeInsets.zero,
            initCategory: Category.RECENT,
            bgColor: Theme.of(context).cardColor,
            indicatorColor: Theme.of(context).primaryColor,
            iconColor: Theme.of(context).disabledColor,
            iconColorSelected: Theme.of(context).primaryColor,
            backspaceColor: Theme.of(context).primaryColor,
            skinToneDialogBgColor: Theme.of(context).cardColor,
            skinToneIndicatorColor: Theme.of(context).disabledColor,
            enableSkinTones: true,
            recentTabBehavior: RecentTabBehavior.RECENT,
            recentsLimit: 28,
            replaceEmojiOnLimitExceed: false,
            noRecents: Text(
              'no_recent_emojis'.tr,
              style: fontRegular.copyWith(color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            loadingIndicator: const SizedBox.shrink(),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL,
            checkPlatformCompatibility: true,
          ),
        )),
      ),

    ]);
  }
}
