import 'package:flutter/material.dart';
import 'package:sixteen/utilities/style.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String? value;
  const InfoWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(children: [

      Text(
        '$title:',
        style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
      ),
      const SizedBox(width: 5),

      Expanded(child: Text(
        (value != null && value!.isNotEmpty) ? value! : 'N/A',
        style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
      )),

    ]);
  }
}
