import 'package:flutter/material.dart';
import 'package:promilaj/data/models/user_profile.dart'; // Still needed for BiologicalSex
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/repositories/user_profile_repository.dart';

/// Ayarlar ekranı ViewModel'i.
/// Profil düzenleme (Sadece Profil A) ve dil/ülke seçimi yönetimi.
class SettingsViewModel extends ChangeNotifier {
  final IUserProfileRepository _userRepo;

  SettingsViewModel(this._userRepo);

  SessionProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  Locale? _selectedLocale;

  SessionProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  Locale? get selectedLocale => _selectedLocale ?? _profile?.selectedLocale;
  String get selectedLanguage => _profile?.selectedLocale?.languageCode ?? 'en';
  String? get selectedCountryCode => _profile?.selectedCountryCode;

  /// Profil ve ayarları yükle
  Future<void> initialize() async {
    _isLoading = true;
    try {
      _profile = await _userRepo.loadSessionProfile('A');

      // Kayıtlı dili locale olarak uygula
      if (_profile != null && _profile!.selectedLocale != null) {
        _selectedLocale = _profile!.selectedLocale;
      }
    } catch (e) {
      debugPrint('SettingsViewModel initialize error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Profili güncelle (Profile A)
  Future<bool> updateProfile({
    double? heightCm,
    double? weightKg,
    BiologicalSex? sex,
    int? age,
    VehicleType? vehicleType,
  }) async {
    if (_profile == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      _profile = _profile?.copyWith(
        heightCm: heightCm,
        weightKg: weightKg,
        sex: sex,
        age: age,
        vehicleType: vehicleType,
      );
      if (_profile != null) {
        await _userRepo.saveSessionProfile(_profile!);
      }
      return true;
    } catch (e) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Dil değiştir — kalıcı olarak profil ile birlikte kaydedilir
  Future<void> setLanguage(String langCode) async {
    _selectedLocale = Locale(langCode);
    if (_profile != null) {
      _profile = _profile?.copyWith(selectedLocale: _selectedLocale);
      await _userRepo.saveSessionProfile(_profile!);
    }
    notifyListeners();
  }

  /// Ülke kodu değiştir — null = otomatik algıla
  Future<void> setCountryCode(String? countryCode) async {
    if (_profile != null) {
      _profile = _profile?.copyWith(selectedCountryCode: countryCode);
      await _userRepo.saveSessionProfile(_profile!);
    }
    notifyListeners();
  }

  /// Sadece locale güncelle (eski uyumluluk — SettingsView'dan çağrılır)
  void setLocale(Locale locale) {
    _selectedLocale = locale;
    notifyListeners();
  }
}

