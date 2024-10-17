import 'package:flutter/material.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:car_app/models/service_model.dart';
import 'package:car_app/services/remote/service.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceService serviceService = ServiceService();

    return Scaffold(
      body: FutureBuilder<List<ServiceModel>>(
        future: serviceService.fetchServices(), // Fetch services
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No services found.'));
          }

          List<ServiceModel> services = snapshot.data!;

          return ListView.separated(
            itemBuilder: (context, index) {
              final service = services[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0)
                    .copyWith(top: 10),
                child: Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(80),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(5, 10),
                        blurRadius: 20,
                        color: AppColor.grey.withOpacity(0.8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(80),
                        ),
                        child: Image.network(
                          service.image ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 220,
                        ),
                      ),
                      Positioned(
                        bottom: 30,
                        right: 0,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 150,
                              child: Text(
                                service.name ?? '-.-',
                                maxLines: 2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  backgroundColor:
                                      Colors.black54.withOpacity(0.2),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20.0),
            itemCount: services.length,
          );
        },
      ),
    );
  }
}
