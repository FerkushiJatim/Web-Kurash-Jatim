import 'package:flutter/material.dart';
import '../data/repositories/jadwal_repository.dart';
import '../data/models/event_model.dart';
import '../../../../shared/models/pertandingan_model.dart';

class JadwalProvider extends ChangeNotifier {
  final JadwalRepository _repository;

  JadwalProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Event> _events = [];
  List<Event> get events => _events;

  DateTime _selectedMonth = DateTime.now();
  DateTime get selectedMonth => _selectedMonth;

  Event? _selectedEvent;
  Event? get selectedEvent => _selectedEvent;

  List<Pertandingan> _pertandingan = [];
  List<Pertandingan> get pertandingan => _pertandingan;

  void changeMonth(int offset) {
    _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + offset, 1);
    notifyListeners();
  }

  List<Event> getEventsForDate(DateTime date) {
    return _events.where((e) {
      final start = DateTime(e.tanggalMulai.year, e.tanggalMulai.month, e.tanggalMulai.day);
      final end = DateTime(e.tanggalSelesai.year, e.tanggalSelesai.month, e.tanggalSelesai.day);
      final target = DateTime(date.year, date.month, date.day);
      return (target.isAtSameMomentAs(start) || target.isAfter(start)) &&
             (target.isAtSameMomentAs(end) || target.isBefore(end));
    }).toList();
  }

  void selectEvent(Event event) {
    _selectedEvent = event;
    notifyListeners();
  }

  void clearSelectedEvent() {
    _selectedEvent = null;
    _pertandingan = [];
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

  Future<void> loadPertandingan(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _pertandingan = await _repository.fetchPertandinganByEventId(eventId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

