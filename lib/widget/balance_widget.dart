import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixteen/utilities/converter.dart';
import 'package:sixteen/utilities/style.dart';

class BalanceWidget extends StatefulWidget {
  final double balance;
  const BalanceWidget({super.key, required this.balance});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  bool _isAnimated = false;
  bool _isBalanceShown = false;
  bool _isBalance = true;

  void changeState() async {
    _isAnimated = true;
    _isBalance = false;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 800), () => setState(() => _isBalanceShown = true));
    await Future.delayed(const Duration(seconds: 3), () => setState(() => _isBalanceShown = false));
    await Future.delayed(const Duration(milliseconds: 200), () => setState(() => _isAnimated = false));
    await Future.delayed(const Duration(milliseconds: 800), () => setState(() => _isBalance = true));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: changeState,
      child: Container(
        width: 160,
        height: 30,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Stack(alignment: Alignment.center, children: [
          /// ৳ Balance
          AnimatedOpacity(
            opacity: _isBalanceShown ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Text(
              Converter.convertAmount(widget.balance),
              style: fontMedium.copyWith(color: Theme.of(context).primaryColor),
            ),
          ),

          /// ব্যালেন্স দেখুন
          AnimatedOpacity(
            opacity: _isBalance ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Text('show_balance'.tr, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14)),
          ),

          /// Circle
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1100),
            left: _isAnimated == false ? 5 : 135,
            curve: Curves.fastOutSlowIn,
            child: Container(
              height: 20,
              width: 20,
              // padding: const EdgeInsets.only(bottom: 4),
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(50)),
              child: const FittedBox(child: Text('৳', style: TextStyle(color: Colors.white, fontSize: 17))),
            ),
          ),
        ]),
      ),
    );
  }
}
