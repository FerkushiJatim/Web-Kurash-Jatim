import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';
import '../../../../shared/models/pertandingan_model.dart';

class JadwalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  JadwalRepository(dynamic apiClient);

  Future<List<Event>> fetchEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Event.fromJson(data);
    }).toList();
  }

  Future<Event> fetchEventById(String id) async {
    final docSnap = await _firestore.collection('events').doc(id).get();
    final data = docSnap.data()!;
    data['id'] = docSnap.id;
    return Event.fromJson(data);
  }

  Future<List<Pertandingan>> fetchPertandinganByEventId(String eventId) async {
    final snapshot = await _firestore
        .collection('pertandingan')
        .where('event_id', isEqualTo: eventId)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Pertandingan.fromJson(data);
    }).toList();
  }
}

