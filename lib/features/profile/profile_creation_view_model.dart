import 'package:flutter/material.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/models/user_profile.dart';
import 'package:promilaj/data/repositories/user_profile_repository.dart';

/// Misafir profili (Profile B) oluşturma ViewModel'i.
/// Form alanları Onboarding ile aynı: boy, kilo, cinsiyet, yaş.
/// İsim alanı yok — sadece "A" / "B" gösterilir.
class ProfileCreationViewModel extends ChangeNotifier {
  final IUserProfileRepository _userRepo;

  ProfileCreationViewModel(this._userRepo);

  // ── Form Değerleri ──
  double _heightCm = 170.0;
  double _weightKg = 70.0;
  BiologicalSex _sex = BiologicalSex.male;
  VehicleType _vehicleType = VehicleType.car;
  int _age = 25;
  bool _isSaving = false;

  // ── Getter'lar ──
  double get heightCm => _heightCm;
  double get weightKg => _weightKg;
  BiologicalSex get sex => _sex;
  VehicleType get vehicleType => _vehicleType;
  int get age => _age;
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

  /// Profili oluşturur ve SessionProfile döndürür
  Future<SessionProfile?> createProfile() async {
    if (!isValid) return null;

    _isSaving = true;
    notifyListeners();

    try {
      final profileA = await _userRepo.loadSessionProfile('A');
      
      final profile = SessionProfile(
        id: 'B',
        heightCm: _heightCm,
        weightKg: _weightKg,
        sex: _sex,
        age: _age,
        selectedLocale: profileA?.selectedLocale ?? const Locale('en'),
        selectedCountryCode: profileA?.selectedCountryCode,
        vehicleType: _vehicleType,
      );
      await _userRepo.saveSessionProfile(profile);
      return profile;
    } catch (e) {
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Formu sıfırla
  void reset() {
    _heightCm = 170.0;
    _weightKg = 70.0;
    _sex = BiologicalSex.male;
    _vehicleType = VehicleType.car;
    _age = 25;
    _isSaving = false;
    notifyListeners();
  }
}
