import 'package:flutter/material.dart';
import 'package:car_app/pages/home/service/service_page.dart';
import 'package:car_app/pages/home/home_page.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({
    super.key,
  });

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: [
            Container(
              height: 50.0,
              padding: const EdgeInsets.all(6.0),
              margin: const EdgeInsets.symmetric(horizontal: 25.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                color: const Color(0xFFEBEDEF),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.0),
                  color: const Color(0XFFFC6011),
                ),
                labelColor: Colors.white,
                tabs: const [
                  Tab(text: 'All Product'),
                  Tab(text: 'Service'),
                ],
              ),
            ),
            const Divider(thickness: 5, color: Color(0xFFEBEDEF)),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [HomePage(), ServicePage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
