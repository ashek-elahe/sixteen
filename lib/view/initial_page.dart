import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nub/utilities/constants.dart';
import 'package:nub/view/home_page.dart';
import 'package:nub/view/members_page.dart';
import 'package:nub/view/menu_page.dart';
import 'package:nub/widget/nav_bar_item.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _pageIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const HomePage(),
      const MembersPage(),
      const MenuPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Constants.padding)),
          color: Theme.of(context).cardColor,
        ),
        child: SafeArea(
          child: Row(children: [
            NavBarItem(icon: Icons.house_outlined, title: 'home'.tr, isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
            NavBarItem(icon: Icons.group, title: 'members'.tr, isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
            NavBarItem(icon: Icons.menu, title: 'menu'.tr, isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
          ]),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _pages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _pages[index];
        },
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }

}
