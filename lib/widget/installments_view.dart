import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sixteen/model/installment_model.dart';
import 'package:sixteen/utilities/constants.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';
import 'package:sixteen/widget/paginated_list_view.dart';

class InstallmentsView extends StatelessWidget {
  final List<InstallmentModel>? installments;
  final ScrollController scrollController;
  final bool enabledPagination;
  final bool showTitle;
  final Function() onPaginate;
  const InstallmentsView({
    super.key, required this.installments, required this.scrollController, required this.enabledPagination,
    required this.onPaginate, this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      showTitle ? Text(
        'installments'.tr, style: fontBold.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
      ) : const SizedBox(),
      SizedBox(height: showTitle ? 10 : 0),

      installments != null ? installments!.isNotEmpty ? PaginatedListView(
        scrollController: scrollController,
        enabledPagination: enabledPagination,
        onPaginate: onPaginate,
        itemView: ListView.builder(
          itemCount: installments!.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            InstallmentModel installment = installments![index];

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(children: [

                Expanded(flex: 7, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    Converter.dateToMonth(installment.month!),
                    style: fontBold.copyWith(fontSize: 18, color: Theme.of(context).canvasColor),
                  ),
                  const SizedBox(height: 5),

                  Row(children: [
                    Text(installment.medium ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
                    const SizedBox(width: 5),
                    Expanded(child: Text(
                      '(${installment.reference ?? ''})',
                      style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
                    )),
                  ]),
                  const SizedBox(height: 5),

                  Row(children: [
                    Text('${'received_by'.tr}:', style: fontRegular.copyWith(color: Theme.of(context).canvasColor)),
                    const SizedBox(width: 5),
                    Expanded(child: Text(installment.receiverName ?? '', style: fontMedium.copyWith(color: Theme.of(context).canvasColor))),
                  ]),
                  const SizedBox(height: 5),

                  Text(
                    Converter.dateToDateTimeString(installment.createdAt!),
                    style: fontRegular.copyWith(fontSize: 10, color: Theme.of(context).disabledColor),
                  ),

                ])),

                Container(
                  height: 100,
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
          },
        ),
      ) : Center(child: Text(
        'no_installment_found'.tr, style: fontRegular.copyWith(color: Theme.of(context).canvasColor),
      )) : const InstallmentShimmer(),

    ]);
  }
}

class InstallmentShimmer extends StatelessWidget {
  const InstallmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: Constants.pagination,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).disabledColor, width: 0.5),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Row(children: [
            
              Expanded(flex: 7, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            
                Container(height: 15, width: 100, color: Colors.grey[300]),
                const SizedBox(height: 10),

                Container(height: 12, width: 50, color: Colors.grey[300]),
                const SizedBox(height: 10),

                Container(height: 10, width: 120, color: Colors.grey[300]),
                const SizedBox(height: 10),

                Container(height: 8, width: 100, color: Colors.grey[300]),
            
              ])),
            
              Container(
                height: 100,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: DottedLine(direction: Axis.vertical, dashColor: Theme.of(context).disabledColor, lineThickness: 2),
              ),
            
              Expanded(flex: 3, child: Column(children: [

                Container(height: 20, width: 50, color: Colors.grey[300]),
                const SizedBox(height: 10),
            
                Text('BDT', style: fontMedium.copyWith(color: Theme.of(context).canvasColor)),
            
              ])),
            
            ]),
          ),
        );
      },
    );
  }
}
