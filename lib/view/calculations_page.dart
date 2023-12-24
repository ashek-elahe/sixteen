import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/calculation_controller.dart';
import 'package:sixteen/dialog/add_amount_dialog.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/model/amount_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

class CalculationsPage extends StatefulWidget {
  const CalculationsPage({super.key});

  @override
  State<CalculationsPage> createState() => _CalculationsPageState();
}

class _CalculationsPageState extends State<CalculationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<CalculationController>().getAllAmounts(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'other_calculations'.tr),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAnimatedDialog(const AddAmountDialog()),
        label: Text('add_deduct_amount'.tr, style: fontMedium.copyWith(color: Colors.white)),
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(Constants.padding),
        child: GetBuilder<CalculationController>(builder: (calController) {
          return calController.amounts != null ? calController.amounts!.isNotEmpty ? PaginatedListView(
            scrollController: _scrollController,
            enabledPagination: calController.paginate,
            onPaginate: () => Get.find<CalculationController>().getAllAmounts(),
            itemView: ListView.builder(
              itemCount: calController.amounts!.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                AmountModel amountModel = calController.amounts![index];

                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: amountModel.isAdd! ? Colors.green : Colors.red, width: 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
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
