import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../data/repositories/admin_repository.dart';
import '../../jadwal/data/models/event_model.dart';
import '../../turnamen/data/models/turnamen_model.dart';
import '../../piagam/data/models/piagam_model.dart';
import '../../berita/data/models/berita_model.dart';

class AdminProvider extends ChangeNotifier {
  final AdminRepository _repository;

  AdminProvider(this._repository);

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;
  String? _adminName;
  String? get adminName => _adminName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  List<Event> _events = [];
  List<Event> get events => _events;

  List<Turnamen> _turnamenList = [];
  List<Turnamen> get turnamenList => _turnamenList;

  List<Piagam> _piagamList = [];
  List<Piagam> get piagamList => _piagamList;

  List<Berita> _beritaList = [];
  List<Berita> get beritaList => _beritaList;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Mensimulasikan jeda jaringan
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Hash password input dan bandingkan
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      final inputHash = digest.toString();

      // Hash SHA-256 dari "ferkushijatim2025."
      const expectedHash = 'a3786de9d25976f20cc6ea1bbec7e955b2e0025d5beec5d417360eb86f100ff2';

      if (username == 'admin' && inputHash == expectedHash) {
        _adminName = 'Admin';
        _isAuthenticated = true;
        return true;
      } else {
        _errorMessage = 'Login gagal. Periksa username dan password Anda.';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _adminName = null;
    notifyListeners();
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _events = await _repository.fetchEvents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final event = await _repository.createEvent(data);
      _events.add(event);
      _successMessage = 'Event berhasil ditambahkan';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteEvent(id);
      _events.removeWhere((e) => e.id == id);
      _successMessage = 'Event berhasil dihapus';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTurnamen() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _turnamenList = await _repository.fetchTurnamen();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTurnamen(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final turnamen = await _repository.createTurnamen(data);
      _turnamenList.add(turnamen);
      _successMessage = 'Turnamen berhasil ditambahkan';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteTurnamen(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteTurnamen(id);
      _turnamenList.removeWhere((t) => t.id == id);
      _successMessage = 'Turnamen berhasil dihapus';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPiagam() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _piagamList = await _repository.fetchPiagam();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPiagam(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final piagam = await _repository.createPiagam(data);
      _piagamList.add(piagam);
      _successMessage = 'Piagam berhasil ditambahkan';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePiagam(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deletePiagam(id);
      _piagamList.removeWhere((p) => p.id == id);
      _successMessage = 'Piagam berhasil dihapus';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBerita() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _beritaList = await _repository.fetchBerita();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBerita(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final berita = await _repository.createBerita(data);
      _beritaList.add(berita);
      _successMessage = 'Berita berhasil ditambahkan';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBerita(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.deleteBerita(id);
      _beritaList.removeWhere((b) => b.id == id);
      _successMessage = 'Berita berhasil dihapus';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}

