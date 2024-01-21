import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:nub/model/installment_model.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/utilities/style.dart';
import 'package:nub/widget/installment_widget.dart';
import 'package:nub/widget/paginated_list_view.dart';

class InstallmentsView extends StatelessWidget {
  final List<InstallmentModel>? installments;
  final ScrollController scrollController;
  final bool enabledPagination;
  final bool showUser;
  final Function() onPaginate;
  const InstallmentsView({
    super.key, required this.installments, required this.scrollController, required this.enabledPagination,
    required this.onPaginate, this.showUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Text(
        'installments'.tr, style: fontBold.copyWith(fontSize: 20, color: Theme.of(context).canvasColor),
      ),
      const SizedBox(height: 10),

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

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InstallmentWidget(installment: installment, showUser: showUser),
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
