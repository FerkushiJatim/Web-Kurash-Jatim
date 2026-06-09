import 'package:flutter/material.dart';
import '../../jadwal/data/models/event_model.dart';
import '../../berita/data/models/berita_model.dart';
import '../data/repositories/beranda_repository.dart';

class BerandaProvider extends ChangeNotifier {
  final BerandaRepository _repository;

  BerandaProvider(this._repository);

  List<Berita> _beritaTerbaru = [];
  List<Event> _agendaMendatang = [];
  Map<String, int> _statistik = {'events': 0, 'turnamen': 0, 'piagam': 0};
  bool _isLoading = false;
  String? _errorMessage;

  List<Berita> get beritaTerbaru => _beritaTerbaru;
  List<Event> get agendaMendatang => _agendaMendatang;
  Map<String, int> get statistik => _statistik;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadBeranda() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.fetchBeritaTerbaru(),
        _repository.fetchAgendaMendatang(),
        _repository.fetchStatistik(),
      ]);
      _beritaTerbaru = results[0] as List<Berita>;
      _agendaMendatang = results[1] as List<Event>;
      _statistik = results[2] as Map<String, int>;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
