import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/controller/translation_controller.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/widget/custom_button.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';

class InstallmentsPage extends StatefulWidget {
  const InstallmentsPage({super.key});

  @override
  State<InstallmentsPage> createState() => _InstallmentsPageState();
}

class _InstallmentsPageState extends State<InstallmentsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().getAllInstallments(reload: true, dateReset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'installments'.tr),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<InstallmentController>().getAllInstallments(reload: true);
        },
        backgroundColor: Theme.of(context).primaryColor,
        color: Colors.white,
        child: Column(children: [

          GetBuilder<InstallmentController>(builder: (insController) {
            return CustomButton(
              buttonText: insController.dateTimeRange != null ? Converter.dateRangeToDateRangeString(
                insController.dateTimeRange!,
              ) : 'select_date_range'.tr,
              margin: const EdgeInsets.all(Constants.padding).copyWith(bottom: 0),
              onPressed: () async {
                DateTimeRange? dateTimeRange = await showDateRangePicker(
                  context: context, firstDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
                  lastDate: DateTime.now(), saveText: 'save'.tr, helpText: 'select_range'.tr,
                );
                if(dateTimeRange != null) {
                  insController.setDateRange(dateTimeRange);
                }
              },
            );
          }),

          Expanded(child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Constants.padding),
            child: GetBuilder<InstallmentController>(builder: (insController) {
              return InstallmentsView(
                installments: insController.allInstallments, scrollController: _scrollController,
                enabledPagination: insController.allPaginate, showTitle: false, showUser: true,
                onPaginate: () => Get.find<InstallmentController>().getAllInstallments(),
              );
            }),
          )),

        ]),
      ),
    );
  }
}
