import 'package:flutter/material.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/style.dart';

class CardWidget extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsets? padding;
  const CardWidget({Key? key, this.title, this.padding, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        color: Theme.of(context).cardColor,
        boxShadow: shadow,
      ),
      padding: padding ?? const EdgeInsets.all(Constants.padding),
      child: Column(children: [

        title != null ? Padding(
          padding: const EdgeInsets.only(bottom: Constants.padding),
          child: Text(title!, style: fontMedium.copyWith(fontSize: 16)),
        ) : const SizedBox(),

        child,

      ]),
    );
  }
}
