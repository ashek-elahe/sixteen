import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:nub/dialog/animated_dialog.dart';
import 'package:nub/utilities/constants.dart';

class PhotoViewer {

  static void view(String imageUrl) => showAnimatedDialog(Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.padding)),
    child: Stack(children: [

      ClipRRect(
        borderRadius: BorderRadius.circular(Constants.padding),
        child: PhotoView(
          tightMode: true,
          imageProvider: NetworkImage(imageUrl),
          heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
        ),
      ),

      Positioned(top: 0, right: 0, child: IconButton(
        splashRadius: 5,
        onPressed: () => Get.back(),
        icon: const Icon(Icons.cancel, color: Colors.red),
      )),

    ]),
  ));

}