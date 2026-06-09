import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../jadwal/data/models/event_model.dart';
import '../../../turnamen/data/models/turnamen_model.dart';
import '../../../piagam/data/models/piagam_model.dart';
import '../../../berita/data/models/berita_model.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminRepository(dynamic apiClient); // Keep constructor signature if needed, or we can just ignore apiClient

  Map<String, dynamic> _prepareData(Map<String, dynamic> data) {
    // Helper to ensure dates sent to Firestore are strings
    return data; 
  }

  // Events CRUD
  Future<List<Event>> fetchEvents() async {
    final snapshot = await _firestore.collection('events').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Event.fromJson(data);
    }).toList();
  }

  Future<Event> createEvent(Map<String, dynamic> eventData) async {
    final docRef = await _firestore.collection('events').add(_prepareData(eventData));
    eventData['id'] = docRef.id;
    return Event.fromJson(eventData);
  }

  Future<Event> updateEvent(String id, Map<String, dynamic> eventData) async {
    await _firestore.collection('events').doc(id).update(_prepareData(eventData));
    eventData['id'] = id;
    return Event.fromJson(eventData);
  }

  Future<void> deleteEvent(String id) async {
    await _firestore.collection('events').doc(id).delete();
  }

  // Turnamen CRUD
  Future<List<Turnamen>> fetchTurnamen() async {
    final snapshot = await _firestore.collection('turnamen').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Turnamen.fromJson(data);
    }).toList();
  }

  Future<Turnamen> createTurnamen(Map<String, dynamic> turnamenData) async {
    final docRef = await _firestore.collection('turnamen').add(_prepareData(turnamenData));
    turnamenData['id'] = docRef.id;
    return Turnamen.fromJson(turnamenData);
  }

  Future<Turnamen> updateTurnamen(String id, Map<String, dynamic> turnamenData) async {
    await _firestore.collection('turnamen').doc(id).update(_prepareData(turnamenData));
    turnamenData['id'] = id;
    return Turnamen.fromJson(turnamenData);
  }

  Future<void> deleteTurnamen(String id) async {
    await _firestore.collection('turnamen').doc(id).delete();
  }

  // Piagam CRUD
  Future<List<Piagam>> fetchPiagam() async {
    final snapshot = await _firestore.collection('piagam').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Piagam.fromJson(data);
    }).toList();
  }

  Future<Piagam> createPiagam(Map<String, dynamic> piagamData) async {
    final docRef = await _firestore.collection('piagam').add(_prepareData(piagamData));
    piagamData['id'] = docRef.id;
    return Piagam.fromJson(piagamData);
  }

  Future<Piagam> updatePiagam(String id, Map<String, dynamic> piagamData) async {
    await _firestore.collection('piagam').doc(id).update(_prepareData(piagamData));
    piagamData['id'] = id;
    return Piagam.fromJson(piagamData);
  }

  Future<void> deletePiagam(String id) async {
    await _firestore.collection('piagam').doc(id).delete();
  }

  // Berita CRUD
  Future<List<Berita>> fetchBerita() async {
    final snapshot = await _firestore.collection('berita').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Berita.fromJson(data);
    }).toList();
  }

  Future<Berita> createBerita(Map<String, dynamic> beritaData) async {
    final docRef = await _firestore.collection('berita').add(_prepareData(beritaData));
    beritaData['id'] = docRef.id;
    return Berita.fromJson(beritaData);
  }

  Future<Berita> updateBerita(String id, Map<String, dynamic> beritaData) async {
    await _firestore.collection('berita').doc(id).update(_prepareData(beritaData));
    beritaData['id'] = id;
    return Berita.fromJson(beritaData);
  }

  Future<void> deleteBerita(String id) async {
    await _firestore.collection('berita').doc(id).delete();
  }
}

