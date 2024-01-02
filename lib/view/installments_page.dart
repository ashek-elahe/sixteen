import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/auth_controller.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/dialog/confirmation_dialog.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/custom_button.dart';
import 'package:sixteen/widget/installment_widget.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

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
              return insController.allInstallments != null ? insController.allInstallments!.isNotEmpty ? PaginatedListView(
                scrollController: _scrollController,
                enabledPagination: insController.allPaginate,
                onPaginate: () => Get.find<InstallmentController>().getAllInstallments(),
                itemView: ListView.builder(
                  itemCount: insController.allInstallments!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    InstallmentModel installment = insController.allInstallments![index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Slidable(
                        endActionPane: Get.find<AuthController>().isAdmin ? ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [SlidableAction(
                            onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                              message: 'are_you_sure_to_delete_this'.tr,
                              isLoading: insController.isLoading,
                              onOkPressed: () async {
                                Get.find<InstallmentController>().deleteInstallment(installment: installment, index: index);
                              },
                            ), isFlip: true),
                            backgroundColor: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'delete'.tr,
                          )],
                        ) : null,
                        child: InstallmentWidget(installment: installment, showUser: true),
                      ),
                    );
                  },
                ),
              ) : Center(child: Text(
                'no_installment_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
              )) : const InstallmentShimmer();
            }),
          )),

        ]),
      ),
    );
  }
}
