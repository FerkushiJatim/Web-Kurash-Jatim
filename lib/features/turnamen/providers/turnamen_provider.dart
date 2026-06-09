import 'package:flutter/material.dart';
import '../data/repositories/turnamen_repository.dart';
import '../data/models/turnamen_model.dart';
import '../data/models/klasemen_model.dart';

class TurnamenProvider extends ChangeNotifier {
  final TurnamenRepository _repository;

  TurnamenProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Turnamen> _turnamenList = [];
  List<Turnamen> get turnamenList => _turnamenList;

  Turnamen? _selectedTurnamen;
  Turnamen? get selectedTurnamen => _selectedTurnamen;

  List<Klasemen> _klasemenList = [];
  List<Klasemen> get filteredKlasemen => _klasemenList;

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

  void selectTurnamen(Turnamen turnamen) {
    _selectedTurnamen = turnamen;
    _loadKlasemen(turnamen.id);
    notifyListeners();
  }

  void clearSelection() {
    _selectedTurnamen = null;
    _klasemenList = [];
    notifyListeners();
  }

  Future<void> _loadKlasemen(String turnamenId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _klasemenList = await _repository.fetchKlasemen(turnamenId);
    } catch (e) {
      _errorMessage = e.toString();
      _klasemenList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

