import 'package:flutter/material.dart';
import 'package:car_app/components/app_bar/custom_app_bar.dart';

class ServiceItems extends StatelessWidget {
  const ServiceItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: CustomAppBar(title: 'title'),
        body: Column(
          children: [
            Text(
              ' Explore Service',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
