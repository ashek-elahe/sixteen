import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/controller/auth_controller.dart';
import 'package:nub/controller/account_controller.dart';
import 'package:nub/dialog/base_dialog.dart';
import 'package:nub/model/amount_model.dart';
import 'package:nub/model/user_model.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/custom_snackbar.dart';
import 'package:nub/widget/input_field.dart';
import 'package:nub/widget/loading_button.dart';

class AddAmountDialog extends StatefulWidget {
  final UserModel? user;
  const AddAmountDialog({super.key, this.user});

  @override
  State<AddAmountDialog> createState() => _AddAmountDialogState();
}

class _AddAmountDialogState extends State<AddAmountDialog> {
  final RoundedLoadingButtonController _buttonController = RoundedLoadingButtonController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<AccountController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (calController) {
      return BaseDialog(children: [

        Text('add_deduct_amount'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor, fontSize: 20)),
        const SizedBox(height: Constants.padding),

        Row(children: [
          Expanded(child: InkWell(
            onTap: () => calController.setIsAdd(true),
            child: Row(children: [
              Radio(value: true, groupValue: calController.isAdd, onChanged: (bool? isActive) => calController.setIsAdd(true)),
              Expanded(child: Text('add'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
            ]),
          )),
          const SizedBox(width: 10),
          Expanded(child: InkWell(
            onTap: () => calController.setIsAdd(false),
            child: Row(children: [
              Radio(value: false, groupValue: calController.isAdd, onChanged: (bool? isActive) => calController.setIsAdd(false)),
              Expanded(child: Text('deduct'.tr, style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
            ]),
          )),
        ]),
        const SizedBox(height: Constants.padding),

        InputField(
          titleText: 'amount'.tr,
          hintText: 'enter_amount'.tr,
          controller: _amountController,
          isNumber: true,
          inputType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          borderRadius: BorderRadius.circular(10),
          inputAction: TextInputAction.done,
        ),
        const SizedBox(height: Constants.padding),

        InputField(
          titleText: 'note'.tr,
          hintText: 'enter_note'.tr,
          controller: _noteController,
          borderRadius: BorderRadius.circular(10),
          inputAction: TextInputAction.done,
        ),
        const SizedBox(height: 30),

        LoadingButton(
          controller: _buttonController,
          onPressed: () async {
            String amount = _amountController.text.trim();
            if(amount.isEmpty) {
              showSnackBar(message: 'enter_amount'.tr);
              _buttonController.error();
            }else if(_noteController.text.trim().isEmpty) {
              showSnackBar(message: 'enter_note'.tr);
              _buttonController.error();
            }else {
              UserModel admin = Get.find<AuthController>().user!;
              Get.find<AccountController>().addAmount(
                amountModel: AmountModel(
                  amount: double.parse(amount), note: _noteController.text.trim(), isAdd: calController.isAdd, date: DateTime.now(),
                  adminEmail: admin.email, adminId: admin.uid, adminName: admin.name,
                  userId: widget.user?.uid, userEmail: widget.user?.email, userName: widget.user?.name,
                ),
                buttonController: _buttonController,
              );
            }
          },
          child: Text('add'.tr, style: fontMedium.copyWith(color: Colors.white)),
        ),

      ]);
    });
  }
}
