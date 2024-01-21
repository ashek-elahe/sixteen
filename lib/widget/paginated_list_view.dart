import 'package:flutter/material.dart';
import 'package:nub/utilities/constants.dart';

class PaginatedListView extends StatefulWidget {
  final ScrollController? scrollController;
  final Function() onPaginate;
  final Widget itemView;
  final bool enabledPagination;
  final bool reverse;
  const PaginatedListView({
    Key? key, required this.scrollController, required this.onPaginate,
    required this.itemView, this.enabledPagination = true, this.reverse = false,
  }) : super(key: key);

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState extends State<PaginatedListView> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    widget.scrollController?.addListener(() {
      if (widget.scrollController?.position.pixels == widget.scrollController?.position.maxScrollExtent
          && !_isLoading && widget.enabledPagination) {
        if(mounted) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    if (widget.enabledPagination) {
      setState(() {
        _isLoading = true;
      });
      await widget.onPaginate();
      setState(() {
        _isLoading = false;
      });

    }else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      widget.reverse ? const SizedBox() : widget.itemView,

      !widget.enabledPagination ? const SizedBox() : Center(child: Padding(
        padding: _isLoading ? const EdgeInsets.all(Constants.padding) : EdgeInsets.zero,
        child: _isLoading ? const CircularProgressIndicator() : const SizedBox(),
      )),

      widget.reverse ? widget.itemView : const SizedBox(),

    ]);
  }
}
