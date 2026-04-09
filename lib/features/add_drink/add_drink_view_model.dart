import 'package:flutter/material.dart';
import 'package:promilaj/data/models/drink_brand.dart';
import 'package:promilaj/data/models/drink_type.dart';
import 'package:promilaj/data/repositories/drink_repository.dart';

/// İçki ekleme akışı ViewModel'i.
/// 4 adımlı akış: Tür → Marka → Miktar/Zaman → Onayla
class AddDrinkViewModel extends ChangeNotifier {
  final IDrinkRepository _drinkRepo;

  AddDrinkViewModel(this._drinkRepo);

  // ── Adım yönetimi ──
  int _currentStep = 0;
  int get currentStep => _currentStep;

  // ── Seçimler ──
  DrinkType? _selectedType;
  DrinkBrand? _selectedBrand;
  double _volumeMl = 250.0;
  double _hoursAgo = 0.0;
  String _searchQuery = '';

  // ── Getter'lar ──
  DrinkType? get selectedType => _selectedType;
  DrinkBrand? get selectedBrand => _selectedBrand;
  double get volumeMl => _volumeMl;
  double get hoursAgo => _hoursAgo;
  String get searchQuery => _searchQuery;

  /// Kategoriye göre gruplandırılmış içki türlerini döndürür
  Map<DrinkCategory, List<DrinkType>> get groupedTypes {
    final map = <DrinkCategory, List<DrinkType>>{};
    for (final category in DrinkCategory.values) {
      map[category] = _drinkRepo.getTypesByCategory(category);
    }
    return map;
  }

  /// Aktif marka listesi (arama filtrelenmiş)
  List<DrinkBrand> get filteredBrands {
    if (_selectedType == null) return [];
    if (_searchQuery.isEmpty) {
      return _drinkRepo.getBrandsByType(_selectedType!);
    }
    return _drinkRepo.searchBrands(_searchQuery, _selectedType!);
  }

  // ── İşlemler ──
  void selectType(DrinkType type) {
    _selectedType = type;
    _selectedBrand = null;
    _searchQuery = '';
    _currentStep = 1;
    notifyListeners();
  }

  void selectTypeForCocktail(DrinkType type) {
    _selectedType = type;
    _searchQuery = '';
    final brands = filteredBrands;
    _selectedBrand = brands.isNotEmpty ? brands.first : null;
    _currentStep = 2;
    notifyListeners();
  }

  void selectBrand(DrinkBrand brand) {
    _selectedBrand = brand;
    _currentStep = 2;
    notifyListeners();
  }

  void setVolume(double ml) {
    _volumeMl = ml;
    notifyListeners();
  }

  void setHoursAgo(double hours) {
    _hoursAgo = hours;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void goBack() {
    if (_currentStep > 0) {
      if (_currentStep == 2 && _selectedType != null) {
        final isCocktail = _drinkRepo.getTypesByCategory(DrinkCategory.cocktails).contains(_selectedType);
        if (isCocktail) {
          _currentStep = 0;
          notifyListeners();
          return;
        }
      }
      _currentStep--;
      notifyListeners();
    }
  }

  void reset() {
    _currentStep = 0;
    _selectedType = null;
    _selectedBrand = null;
    _volumeMl = 250.0;
    _hoursAgo = 0.0;
    _searchQuery = '';
    notifyListeners();
  }

  /// Formun onayla için hazır olup olmadığı
  bool get isReadyToConfirm =>
      _selectedType != null && _selectedBrand != null && _volumeMl > 0;
}
