import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../jadwal/data/models/event_model.dart';
import '../../../berita/data/models/berita_model.dart';

class BerandaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Berita>> fetchBeritaTerbaru({int limit = 6}) async {
    final snapshot = await _firestore
        .collection('berita')
        .orderBy('tanggal_publikasi', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Berita.fromJson(data);
    }).toList();
  }

  Future<List<Event>> fetchAgendaMendatang({int limit = 5}) async {
    final snapshot = await _firestore
        .collection('events')
        .where('status', isEqualTo: 'upcoming')
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Event.fromJson(data);
    }).toList();
  }

  Future<Map<String, int>> fetchStatistik() async {
    final eventsSnap = await _firestore.collection('events').get();
    final turnamenSnap = await _firestore.collection('turnamen').get();
    final piagamSnap = await _firestore.collection('piagam').get();
    return {
      'events': eventsSnap.docs.length,
      'turnamen': turnamenSnap.docs.length,
      'piagam': piagamSnap.docs.length,
    };
  }
}
