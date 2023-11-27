import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/style.dart';

class CustomButton extends StatelessWidget {
  final Function? onPressed;
  final String buttonText;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double radius;
  final IconData? icon;
  final Color? color;
  final bool isLoading;
  final bool transparent;
  const CustomButton({Key? key, this.onPressed, required this.buttonText, this.margin, this.width, this.height,
    this.radius = 10, this.icon, this.color, this.isLoading = false, this.transparent = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ? Theme.of(context).disabledColor : transparent ? null : color ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : context.width, height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: transparent ? BorderSide(color: Theme.of(context).primaryColor) : BorderSide.none,
      ),
    );

    return Center(child: SizedBox(width: width ?? context.width, child: Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        style: flatButtonStyle,
        child: isLoading ? Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).cardColor),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 10),

          Text('loading'.tr, style: fontMedium.copyWith(color: Theme.of(context).cardColor)),
        ])) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(icon, color: Theme.of(context).cardColor),
          ) : const SizedBox(),
          Text(
            buttonText, textAlign: TextAlign.center,
            style: fontBold.copyWith(color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor, fontSize: 16),
          ),
        ]),
      ),
    )));
  }
}