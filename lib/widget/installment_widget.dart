import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';

class InstallmentWidget extends StatelessWidget {
  final InstallmentModel installment;
  final bool showUser;
  const InstallmentWidget({super.key, required this.installment, required this.showUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(children: [

        Expanded(flex: 7, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          Text(
            Converter.dateToMonth(installment.month!),
            style: fontBold.copyWith(fontSize: 18, color: Theme.of(context).canvasColor),
          ),
          const SizedBox(height: 5),

          showUser ? Text(
            (installment.userName != null && installment.userName!.isNotEmpty) ? installment.userName! : (installment.userEmail ?? ''),
            style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ) : const SizedBox(),
          SizedBox(height: showUser ? 5 : 0),

          Row(children: [
            Text(installment.medium ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
            const SizedBox(width: 5),
            Expanded(child: Text(
              '(${installment.reference ?? ''})',
              style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
            )),
          ]),
          const SizedBox(height: 5),

          installment.receiverEmail != null ? Row(children: [
            Text('${'received_by'.tr}:', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
            const SizedBox(width: 5),
            Expanded(child: Text(installment.receiverName ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
          ]) : const SizedBox(),
          SizedBox(height: installment.receiverEmail != null ? 5 : 0),

          Text(
            Converter.dateToDateTimeString(installment.createdAt!),
            style: fontRegular.copyWith(fontSize: 10, color: Theme.of(context).disabledColor),
          ),

        ])),

        Container(
          height: showUser ? 115 : 100,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: DottedLine(direction: Axis.vertical, dashColor: Theme.of(context).disabledColor, lineThickness: 2),
        ),

        Expanded(flex: 3, child: Column(children: [

          Text(
            installment.amount?.toStringAsFixed(0) ?? '0',
            style: fontBlack.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
          ),

          Text('BDT', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),

        ])),

      ]),
    );
  }
}
