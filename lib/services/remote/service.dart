import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_app/models/service_model.dart';
import 'package:car_app/resources/define_collection.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> fetchServices() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(AppDefineCollection.APP_USER_SERVICE)
          .get();
      return snapshot.docs.map((doc) {
        return ServiceModel.fromJson({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      throw Exception('Failed to load services: $e');
    }
  }
}
