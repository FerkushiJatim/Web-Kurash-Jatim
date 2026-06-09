import 'package:flutter/material.dart';
import '../data/repositories/berita_repository.dart';
import '../data/models/berita_model.dart';
import '../../../../core/network/api_exception.dart';

class BeritaProvider extends ChangeNotifier {
  final BeritaRepository _repository;

  List<Berita> _beritaList = [];
  bool _isLoading = false;
  String? _errorMessage;
  Berita? _selectedBerita;

  BeritaProvider(this._repository);

  List<Berita> get beritaList => _beritaList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Berita? get selectedBerita => _selectedBerita;

  Future<void> fetchBerita() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _beritaList = await _repository.fetchBerita();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBeritaById(String id) async {
    _isLoading = true;
    _errorMessage = null;
    _selectedBerita = null;
    notifyListeners();

    try {
      _selectedBerita = await _repository.fetchBeritaById(id);
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
