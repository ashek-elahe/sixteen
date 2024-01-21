import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/widget/my_app_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'admin'.tr),
      body: const SafeArea(child: Column(children: [


      ])),
    );
  }
}
