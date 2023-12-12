import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/dialog/photo_viewer.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  const CustomImage({Key? key, required this.image, this.height, this.width, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PhotoViewer.view(image),
      child: CachedNetworkImage(
        imageUrl: image, height: height, width: width, fit: fit,
        placeholder: (context, url) => Image.asset(Constants.logo, height: height, width: width, fit: fit),
        errorWidget: (context, url, error) => Image.asset(Constants.logo, height: height, width: width, fit: fit),
      ),
    );
  }
}
