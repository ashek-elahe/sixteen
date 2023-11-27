import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/dialog/base_dialog.dart';
import 'package:sixteen/model/user_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/custom_snackbar.dart';
import 'package:sixteen/widget/input_field.dart';
import 'package:sixteen/widget/loading_button.dart';

class AddInstallmentDialog extends StatefulWidget {
  final UserModel user;
  const AddInstallmentDialog({super.key, required this.user});

  @override
  State<AddInstallmentDialog> createState() => _AddInstallmentDialogState();
}

class _AddInstallmentDialogState extends State<AddInstallmentDialog> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallmentController>(builder: (insController) {
      return BaseDialog(children: [

        Text('add_installment'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 20)),
        const SizedBox(height: Constants.padding),

        Row(children: [
          Expanded(child: InkWell(
            onTap: () => insController.setIsAmount(false),
            child: Row(children: [
              Radio(value: false, groupValue: insController.isAmount, onChanged: (bool? isActive) => insController.setIsAmount(false)),
              Expanded(child: Text('selection'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
            ]),
          )),
          const SizedBox(width: 10),
          Expanded(child: InkWell(
            onTap: () => insController.setIsAmount(true),
            child: Row(children: [
              Radio(value: true, groupValue: insController.isAmount, onChanged: (bool? isActive) => insController.setIsAmount(true)),
              Expanded(child: Text('amount'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
            ]),
          )),
        ]),

        insController.isAmount ? InputField(
          titleText: 'amount'.tr,
          hintText: 'enter_amount'.tr,
          controller: _amountController,
          isNumber: true,
          inputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          borderRadius: BorderRadius.circular(10),
          inputAction: TextInputAction.done,
        ) : Container(
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Constants.padding),
          child: DropdownButton<double>(
            value: insController.amount,
            style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
            underline: const SizedBox(),
            isExpanded: true,
            dropdownColor: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            items: Constants.amounts.map((double value) {
              return DropdownMenuItem<double>(
                value: value,
                child: Text(Converter.convertAmount(value), style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
              );
            }).toList(),
            onChanged: (double? value) => insController.setAmount(value!),
          ),
        ),
        const SizedBox(height: Constants.padding),

        InkWell(
          onTap: () async {
            DateTime? month = await showMonthPicker(
              context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)), selectedMonthTextColor: Colors.white, roundedCornersRadius: 20,
            );
            if(month != null) {
              insController.setMonth(month);
            }
          },
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Constants.padding, vertical: 15),
            alignment: Alignment.center,
            child: Text(
              insController.dateTime != null ? Converter.dateToMonth(insController.dateTime!) : 'select_month'.tr,
              style: fontMedium.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 30),

        LoadingButton(
          controller: _buttonController,
          onPressed: () async {
            double amount = insController.isAmount ? _amountController.text.trim().isNotEmpty
                ? double.parse(_amountController.text.trim()) : 0 : insController.amount;
            if(amount <= 0) {
              showSnackBar(message: 'enter_amount'.tr);
              _buttonController.error();
            }else if(insController.dateTime == null) {
              showSnackBar(message: 'select_month'.tr);
              _buttonController.error();
            }else {
              Get.find<InstallmentController>().addInstallment(
                user: widget.user, amount: amount, month: insController.dateTime!, buttonController: _buttonController,
              );
            }
          },
          child: Text('add'.tr, style: fontMedium.copyWith(color: Colors.white)),
        ),

      ]);
    });
  }
}
