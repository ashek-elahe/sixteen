import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sixteen/controller/installment_controller.dart';
import 'package:sixteen/dialog/animated_dialog.dart';
import 'package:sixteen/dialog/confirmation_dialog.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/installment_widget.dart';
import 'package:sixteen/widget/installments_view.dart';
import 'package:sixteen/widget/my_app_bar.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

class InstallmentRequestPage extends StatefulWidget {
  const InstallmentRequestPage({super.key});

  @override
  State<InstallmentRequestPage> createState() => _InstallmentRequestPageState();
}

class _InstallmentRequestPageState extends State<InstallmentRequestPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    Get.find<InstallmentController>().getInstallmentRequests(reload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'installment_requests'.tr),
      body: GetBuilder<InstallmentController>(builder: (instController) {
        return RefreshIndicator(
          onRefresh: () async {
            await Get.find<InstallmentController>().getInstallmentRequests(reload: true);
          },
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(Constants.padding),
            child: GetBuilder<InstallmentController>(builder: (insController) {
              return insController.installmentRequests != null ? insController.installmentRequests!.isNotEmpty ? PaginatedListView(
                scrollController: _scrollController,
                enabledPagination: insController.requestPaginate,
                onPaginate: () => Get.find<InstallmentController>().getInstallmentRequests(),
                itemView: ListView.builder(
                  itemCount: insController.installmentRequests!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    InstallmentModel installment = insController.installmentRequests![index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Slidable(
                        startActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [SlidableAction(
                            onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                              message: 'are_you_sure_to_deny_this_request'.tr,
                              isLoading: insController.isLoading,
                              onOkPressed: () async {
                                Get.find<InstallmentController>().denyInstallment(installment: installment, index: index);
                              },
                            ), isFlip: true),
                            backgroundColor: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(10),
                            foregroundColor: Colors.white,
                            icon: Icons.cancel,
                            label: 'deny'.tr,
                          )],
                        ),
                        endActionPane: ActionPane(
                          extentRatio: 0.3,
                          motion: const ScrollMotion(),
                          children: [SlidableAction(
                            onPressed: (context) => showAnimatedDialog(ConfirmationDialog(
                              message: 'are_you_sure_to_approve_this_request'.tr,
                              isLoading: insController.isLoading,
                              onOkPressed: () async {
                                Get.find<InstallmentController>().approveInstallment(installment: installment, index: index);
                              },
                            ), isFlip: true),
                            backgroundColor: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            foregroundColor: Colors.white,
                            icon: Icons.done,
                            label: 'approve'.tr,
                          )],
                        ),
                        child: InstallmentWidget(installment: installment, showUser: true),
                      ),
                    );
                  },
                ),
              ) : Center(child: Text(
                'no_installment_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
              )) : const InstallmentShimmer();
            }),
          ),
        );
      }),
    );
  }
}
