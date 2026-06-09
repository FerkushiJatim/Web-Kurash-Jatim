import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/piagam_model.dart';

class PiagamRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PiagamRepository(dynamic apiClient);

  Future<List<Piagam>> fetchPiagam() async {
    final snapshot = await _firestore.collection('piagam').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Piagam.fromJson(data);
    }).toList();
  }

  Future<Piagam> fetchPiagamByTurnamen(String turnamen) async {
    final snapshot = await _firestore
        .collection('piagam')
        .where('turnamen_nama', isEqualTo: turnamen)
        .limit(1)
        .get();
        
    if (snapshot.docs.isEmpty) throw Exception('Piagam untuk turnamen tersebut tidak ditemukan');
    final docSnap = snapshot.docs.first;
    final data = docSnap.data();
    data['id'] = docSnap.id;
    return Piagam.fromJson(data);
  }
}

