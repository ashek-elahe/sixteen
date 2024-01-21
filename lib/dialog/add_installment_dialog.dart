import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:get/get.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:nub/controller/installment_controller.dart';
import 'package:nub/controller/splash_controller.dart';
import 'package:nub/dialog/base_dialog.dart';
import 'package:nub/model/user_model.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/converter.dart';
import 'package:nub/utilities/routes.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/card_widget.dart';
import 'package:nub/widget/custom_snackbar.dart';
import 'package:nub/widget/input_field.dart';
import 'package:nub/widget/loading_button.dart';
import 'package:nub/widget/menu_button.dart';

class AddInstallmentDialog extends StatefulWidget {
  final UserModel user;
  final bool isSelf;
  const AddInstallmentDialog({super.key, required this.user, required this.isSelf});

  @override
  State<AddInstallmentDialog> createState() => _AddInstallmentDialogState();
}

class _AddInstallmentDialogState extends State<AddInstallmentDialog> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InstallmentController>(builder: (insController) {
      return BaseDialog(children: [

        Text(
          widget.isSelf ? 'pay_installment'.tr : 'add_installment'.tr,
          style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 20),
        ),
        const SizedBox(height: Constants.padding),

        (widget.isSelf && Get.find<SplashController>().settings!.autoPay!) ? CardWidget(padding: EdgeInsets.zero, child: CheckboxListTile(
          value: insController.autoPay,
          onChanged: (bool? isSelected) => insController.toggleAutoPay(),
          checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text('auto_payment'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
        )) : const SizedBox(),
        SizedBox(height: widget.isSelf ? Constants.padding : 0),

        !insController.autoPay ? MenuButton(icon: Icons.account_balance_sharp, title: 'payment_accounts'.tr, onPressed: () {
          Get.toNamed(Routes.getPaymentAccountsRoute());
        }) : const SizedBox(),
        SizedBox(height: !insController.autoPay ? Constants.padding : 0),

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

        !insController.autoPay ? Column(children: [

          Align(
            alignment: Alignment.centerLeft,
            child: Text('medium'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
          ),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: Constants.padding),
            child: DropdownButton<String>(
              value: insController.medium,
              style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
              underline: const SizedBox(),
              isExpanded: true,
              dropdownColor: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              items: Constants.mediums.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
                );
              }).toList(),
              onChanged: (String? value) => insController.setMedium(value!),
            ),
          ),
          const SizedBox(height: Constants.padding),

          InputField(
            titleText: 'reference'.tr,
            hintText: 'enter_reference'.tr,
            controller: _referenceController,
            borderRadius: BorderRadius.circular(10),
            inputAction: TextInputAction.done,
          ),
          const SizedBox(height: Constants.padding),

        ]) : const SizedBox(),

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
            }else if(_referenceController.text.trim().isEmpty && !insController.autoPay) {
              showSnackBar(message: 'enter_reference'.tr);
              _buttonController.error();
            }else if(insController.dateTime == null) {
              showSnackBar(message: 'select_month'.tr);
              _buttonController.error();
            }else {
              SSLCTransactionInfoModel? response;
              if(widget.isSelf && insController.autoPay) {
                response = await Get.find<InstallmentController>().sslCommerzCall(amount);
              }
              if(!(widget.isSelf && insController.autoPay) || response != null) {
                if(widget.isSelf && !insController.autoPay) {
                  Get.find<InstallmentController>().addInstallmentRequest(
                    amount: amount, month: insController.dateTime!,
                    medium: response != null ? response.cardType! : insController.medium,
                    reference: response != null ? response.bankTranId! : _referenceController.text.trim(),
                    buttonController: _buttonController,
                  );
                }else {
                  Get.find<InstallmentController>().addInstallment(
                    user: widget.user, amount: amount, month: insController.dateTime!,
                    medium: response != null ? response.cardType! : insController.medium,
                    reference: response != null ? response.bankTranId! : _referenceController.text.trim(),
                    autoPay: insController.autoPay, buttonController: _buttonController,
                  );
                }
              }else {
                _buttonController.error();
              }
            }
          },
          child: Text(
            widget.isSelf ? insController.autoPay ? 'pay_now'.tr : 'submit_request'.tr : 'add'.tr,
            style: fontMedium.copyWith(color: Colors.white),
          ),
        ),

      ]);
    });
  }
}
