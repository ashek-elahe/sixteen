import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/account_controller.dart';
import 'package:sixteen/dialog/add_amount_dialog.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/dialog/confirmation_dialog.dart';
import 'package:sixteen/model/amount_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<AccountController>().getAllAmounts(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'other_accounts'.tr),

      floatingActionButton: Get.find<AuthController>().isAdmin ? FloatingActionButton.extended(
        onPressed: () => showAnimatedDialog(const AddAmountDialog()),
        label: Text('add_deduct_amount'.tr, style: fontMedium.copyWith(color: Colors.white)),
      ) : null,

      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(Constants.padding),
        child: GetBuilder<AccountController>(builder: (calController) {
          return calController.amounts != null ? calController.amounts!.isNotEmpty ? PaginatedListView(
            scrollController: _scrollController,
            enabledPagination: calController.paginate,
            onPaginate: () => Get.find<AccountController>().getAllAmounts(),
            itemView: ListView.builder(
              itemCount: calController.amounts!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                AmountModel amountModel = calController.amounts![index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Slidable(
                    endActionPane: Get.find<AuthController>().isAdmin ? ActionPane(
                      extentRatio: 0.3,
                      motion: const ScrollMotion(),
                      children: [SlidableAction(
                        onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                          message: 'are_you_sure_to_delete_this'.tr,
                          isLoading: calController.isLoading,
                          onOkPressed: () async {
                            Get.find<AccountController>().deleteAmount(amountModel: amountModel, index: index);
                          },
                        ), isFlip: true),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'delete'.tr,
                      )],
                    ) : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: amountModel.isAdd! ? Colors.green : Colors.red, width: 1),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [

                        Expanded(flex: 7, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(
                            amountModel.note ?? '',
                            style: fontMedium.copyWith(fontSize: 16, color: Theme.of(context).canvasColor),
                          ),
                          const SizedBox(height: 5),

                          amountModel.userEmail != null ? Text(
                            amountModel.userName ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ) : const SizedBox(),
                          SizedBox(height: amountModel.userEmail != null ? 5 : 0),

                          Row(children: [
                            Text('${'by'.tr}:', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
                            const SizedBox(width: 5),
                            Expanded(child: Text(amountModel.adminName ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor), maxLines: 1)),
                          ]),
                          const SizedBox(height: 5),

                          Text(
                            Converter.dateToDateTimeString(amountModel.date!),
                            style: fontRegular.copyWith(fontSize: 10, color: Theme.of(context).disabledColor),
                          ),

                        ])),

                        Container(
                          height: amountModel.userEmail != null ? 100 : 80,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: DottedLine(
                            direction: Axis.vertical,
                            dashColor: amountModel.isAdd! ? Colors.green : Colors.red, lineThickness: 2,
                          ),
                        ),

                        Expanded(flex: 3, child: Column(children: [

                          Text(
                            amountModel.amount?.toStringAsFixed(0) ?? '0',
                            style: fontBlack.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
                          ),

                          Text('BDT', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),

                        ])),

                      ]),
                    ),
                  ),
                );
              },
            ),
          ) : Center(child: Text(
            'no_calculation_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
          )) : const InstallmentShimmer();
        }),
      ),
    );
  }
}
