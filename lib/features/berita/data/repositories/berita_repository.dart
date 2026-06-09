import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/berita_model.dart';

class BeritaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BeritaRepository(dynamic apiClient);

  Future<List<Berita>> fetchBerita() async {
    final snapshot = await _firestore.collection('berita').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Berita.fromJson(data);
    }).toList();
  }

  Future<Berita> fetchBeritaById(String id) async {
    final docSnap = await _firestore.collection('berita').doc(id).get();
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return Berita.fromJson(data);
  }
}
