import 'package:flutter/material.dart';
import '../data/repositories/piagam_repository.dart';
import '../data/models/piagam_model.dart';

class PiagamProvider extends ChangeNotifier {
  final PiagamRepository _repository;

  PiagamProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Piagam> _piagamList = [];
  List<Piagam> get piagamList => _piagamList;

  Piagam? _selectedPiagam;
  Piagam? get selectedPiagam => _selectedPiagam;

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

  Future<void> searchByTurnamen(String turnamen) async {
    _isSearching = true;
    _errorMessage = null;
    _selectedPiagam = null;
    notifyListeners();

    try {
      _selectedPiagam = await _repository.fetchPiagamByTurnamen(turnamen);
    } catch (e) {
      _errorMessage = 'Arsip piagam untuk turnamen "$turnamen" tidak ditemukan.';
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void selectPiagam(Piagam piagam) {
    _selectedPiagam = piagam;
    notifyListeners();
  }

  void clearSelection() {
    _selectedPiagam = null;
    _errorMessage = null;
    notifyListeners();
  }
}

