import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/turnamen_model.dart';
import '../models/klasemen_model.dart';

class TurnamenRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TurnamenRepository(dynamic apiClient);

  Future<List<Turnamen>> fetchTurnamen() async {
    final snapshot = await _firestore.collection('turnamen').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Turnamen.fromJson(data);
    }).toList();
  }

  Future<Turnamen> fetchTurnamenById(String id) async {
    final docSnap = await _firestore.collection('turnamen').doc(id).get();
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return Turnamen.fromJson(data);
  }

  Future<List<Klasemen>> fetchKlasemen(String turnamenId) async {
    final snapshot = await _firestore
        .collection('klasemen')
        .where('turnamen_id', isEqualTo: turnamenId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Klasemen.fromJson(data);
    }).toList();
  }
}

