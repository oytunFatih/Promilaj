import 'package:flutter/material.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/models/user_profile.dart';
import 'package:promilaj/data/repositories/user_profile_repository.dart';
import 'dart:ui' as ui;

/// Onboarding ekranı ViewModel'i.
/// Form verilerini yönetir ve profil kaydetme işlemini gerçekleştirir.
class OnboardingViewModel extends ChangeNotifier {
  final IUserProfileRepository _userRepo;

  OnboardingViewModel(this._userRepo) {
    // Web ve Mobil uyumlu güvenli locale alımı
    try {
      final locale = ui.PlatformDispatcher.instance.locale.languageCode;
      _selectedLanguage = ['tr', 'az', 'en', 'es', 'fr'].contains(locale) ? locale : 'en';
    } catch (_) {
      _selectedLanguage = 'en';
    }
  }

  // ── Form Değerleri ──
  double _heightCm = 170.0;
  double _weightKg = 70.0;
  BiologicalSex _sex = BiologicalSex.male;
  VehicleType _vehicleType = VehicleType.car;
  int _age = 25;
  String _selectedLanguage = 'en';
  String? _selectedCountryCode;
  bool _isSaving = false;

  // ── Getter'lar ──
  double get heightCm => _heightCm;
  double get weightKg => _weightKg;
  BiologicalSex get sex => _sex;
  VehicleType get vehicleType => _vehicleType;
  int get age => _age;
  String get selectedLanguage => _selectedLanguage;
  String? get selectedCountryCode => _selectedCountryCode;
  bool get isSaving => _isSaving;

  /// Form değerlerinin geçerli olup olmadığını kontrol eder
  bool get isValid =>
      _heightCm >= 100 &&
      _heightCm <= 250 &&
      _weightKg >= 30 &&
      _weightKg <= 300 &&
      _age >= 18 &&
      _age <= 120;

  // ── Setter'lar ──
  void setHeight(double value) {
    _heightCm = value;
    notifyListeners();
  }

  void setWeight(double value) {
    _weightKg = value;
    notifyListeners();
  }

  void setSex(BiologicalSex value) {
    _sex = value;
    notifyListeners();
  }

  void setVehicleType(VehicleType value) {
    _vehicleType = value;
    notifyListeners();
  }

  void setAge(int value) {
    _age = value;
    notifyListeners();
  }

  void setLanguage(String langCode) {
    _selectedLanguage = langCode;
    notifyListeners();
  }

  void setCountryCode(String? countryCode) {
    // null gelirse "Otomatik Algıla" seçilmiştir
    _selectedCountryCode = countryCode;
    notifyListeners();
  }

  /// Profili kaydeder ve başarılıysa true döndürür
  Future<bool> saveProfile() async {
    if (!isValid) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final profile = SessionProfile(
        id: 'A',
        heightCm: _heightCm,
        weightKg: _weightKg,
        sex: _sex,
        age: _age,
        selectedLocale: Locale(_selectedLanguage),
        selectedCountryCode: _selectedCountryCode,
        vehicleType: _vehicleType,
      );
      await _userRepo.saveSessionProfile(profile);
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
