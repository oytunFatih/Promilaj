import 'dart:async';
import 'package:flutter/material.dart';
import 'package:promilaj/core/constants/constants.dart';
import 'package:promilaj/core/utils/bac_calculator.dart';
import 'package:promilaj/core/utils/location_service.dart';

import 'package:promilaj/core/services/country_resolver.dart';
import 'package:promilaj/data/models/drink_entry.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/models/user_profile.dart';
import 'package:promilaj/data/repositories/session_repository.dart';
import 'package:promilaj/data/repositories/user_profile_repository.dart';

/// Ana ekran ViewModel'i.
/// Çoklu profil desteği — her profil bağımsız BAC takibine sahiptir.
/// Aktif profil switch edildiğinde tüm UI değerleri güncellenir.
class HomeViewModel extends ChangeNotifier {
  final IUserProfileRepository _userRepo;
  final ISessionRepository _sessionRepo;
  final LocationService _locationService;
  final ICountryResolver _countryResolver;

  HomeViewModel(this._userRepo, this._sessionRepo, this._locationService, this._countryResolver);

  // ── Profil Durumu ──
  String _activeProfileId = 'A';
  SessionProfile? _profileA;
  SessionProfile? _profileB;
  List<DrinkEntry> _entriesA = [];
  List<DrinkEntry> _entriesB = [];

  // ── Hesaplanmış Değerler (Aktif Profil) ──
  double _currentBac = 0.0;
  String _timeToLegal = '00:00:00';
  String _timeToZero = '00:00:00';
  bool _isLoading = true;
  Timer? _updateTimer;
  bool _hasShownLegalWarning = false;
  bool _wasAboveLegal = false;
  int _sessionDrinkCountA = 0;
  int _sessionDrinkCountB = 0;

  // ── Getter'lar ──
  String get activeProfileId => _activeProfileId;
  SessionProfile? get activeProfile =>
      _activeProfileId == 'A' ? _profileA : _profileB;
  SessionProfile? get profileA => _profileA;
  SessionProfile? get profileB => _profileB;
  bool get hasGuestProfile => _profileB != null;

  List<DrinkEntry> get entries =>
      _activeProfileId == 'A' ? _entriesA : _entriesB;
  double get currentBac => _currentBac;
  String get timeToLegal => _timeToLegal;
  String get timeToZero => _timeToZero;
  bool get isLoading => _isLoading;
  String? get countryCode => activeProfile == null 
      ? _locationService.countryCode 
      : _countryResolver.resolveCountryCode(activeProfile!);
      
  double get legalLimit {
    if (activeProfile == null) return kDefaultLegalLimit;
    return _countryResolver.resolveLegalLimit(activeProfile!);
  }
  bool get isAboveLegalLimit => _currentBac > legalLimit;
  bool get isSober => _currentBac <= 0.0;
  bool get isWithinLegalLimit => _currentBac <= legalLimit && _currentBac > 0;

  int get sessionDrinkCount =>
      _activeProfileId == 'A' ? _sessionDrinkCountA : _sessionDrinkCountB;

  /// Eski API uyumluluğu — aktif profilin UserProfile dönüşümü
  UserProfile? get profile => activeProfile?.toUserProfile();

  Future<void> refreshActiveProfile() async {
    final updated = await _userRepo.loadSessionProfile(_activeProfileId);
    if (updated != null) {
      if (_activeProfileId == 'A') {
        _profileA = updated;
      } else {
        _profileB = updated;
      }
      notifyListeners();
    }
  }

  /// Yasal limit uyarısının gösterilmesi gerekip gerekmediğini döndürür.
  /// Salt-okunur — build() içinden güvenle çağrılabilir.
  /// BUG FIX: Eski getter build() sırasında state mutasyonu yapıyordu
  /// (_hasShownLegalWarning ve _wasAboveLegal'ı set ediyordu).
  /// Bu, notifyListeners() çağrılmadan gizli state desync'e neden oluyordu.
  /// Şimdi CQS (Command-Query Separation) prensibi uygulanıyor:
  /// getter sorgular, markLegalWarningShown() komut verir.
  bool get shouldShowLegalWarning {
    if (_hasShownLegalWarning) return false;
    return !_wasAboveLegal && isAboveLegalLimit;
  }

  /// Yasal limit uyarısı gösterildi olarak işaretle.
  /// View katmanı, uyarıyı gösterdikten SONRA çağırmalıdır — build() içinde DEĞİL.
  void markLegalWarningShown() {
    _hasShownLegalWarning = true;
    _wasAboveLegal = true;
  }

  /// Su hatırlatıcısı gösterilmeli mi?
  bool shouldShowWaterReminder(int newTotal) {
    return newTotal == kWaterReminderDrinkCount;
  }

  /// Başlangıç yüklemesi — profiller, konum, kayıtlar
  Future<void> initialize() async {
    _isLoading = true;
    try {
      // Session profillerini yükle
      _profileA = await _userRepo.loadSessionProfile('A');
      _profileB = await _userRepo.loadSessionProfile('B');

      // Eğer session profile yoksa ama eski profil varsa (migrasyon sonrası)
      if (_profileA == null) {
        final legacyProfile = await _userRepo.loadProfile();
        if (legacyProfile != null) {
          _profileA = SessionProfile.fromLegacyUserProfile(legacyProfile);
          await _userRepo.saveSessionProfile(_profileA!);
        }
      }

      // İçki kayıtlarını yükle
      _entriesA = await _sessionRepo.loadEntries(profileId: 'A');
      _entriesB = await _sessionRepo.loadEntries(profileId: 'B');
      _sessionDrinkCountA = _entriesA.length;
      _sessionDrinkCountB = _entriesB.length;

      // İlk BAC hesaplaması
      _recalculateBac();

      // 30 saniyelik periyodik güncelleme başlat
      _startPeriodicUpdate();
    } catch (e) {
      debugPrint('HomeViewModel initialize error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Profil değiştir (A ↔ B)
  void switchProfile(String profileId) {
    if (_activeProfileId == profileId) return;
    _activeProfileId = profileId;
    _hasShownLegalWarning = false;
    _wasAboveLegal = false;
    _recalculateBac();
    notifyListeners();
  }

  /// Misafir profili (B) ekle
  Future<void> addGuestProfile(SessionProfile profile) async {
    _profileB = profile;
    await _userRepo.saveSessionProfile(profile);
    _entriesB = [];
    _sessionDrinkCountB = 0;
    notifyListeners();
  }

  /// Misafir profilini (B) sil
  Future<void> removeGuestProfile() async {
    _profileB = null;
    // BUG FIX: .clear() ile yerinde mutasyon yerine yeni liste oluştur.
    // Eski yaklaşımda timer callback'i ve build() aynı liste referansını
    // paylaşıyordu — eşzamanlı iterasyon + mutasyon çökmesine yol açıyordu.
    _entriesB = [];
    _sessionDrinkCountB = 0;
    await _userRepo.deleteSessionProfile('B');
    await _sessionRepo.clearAll(profileId: 'B');

    // Eğer aktif profil B ise A'ya geç
    if (_activeProfileId == 'B') {
      _activeProfileId = 'A';
    }

    _recalculateBac();
    notifyListeners();
  }

  /// Konum iznini iste
  Future<bool> requestLocation() async {
    final result = await _locationService.requestAndDetectCountry();
    _recalculateBac();
    notifyListeners();
    return result;
  }

  /// Konum izninin reddedilip reddedilmediği
  bool get isLocationDenied => _locationService.isPermissionDenied;

  /// Yeni içki ekle — aktif profil için
  Future<void> addDrink(DrinkEntry entry) async {
    if (_activeProfileId == 'A') {
      // BUG FIX: Yeni liste oluştur, eski listeyi yerinde mutasyona uğratma.
      // .add() ile yerinde mutasyon, timer callback'inin _recalculateBac()
      // sırasında aynı listeyi iterasyona almasıyla çakışıyordu — await
      // arasındaki microtask yield'de ConcurrentModificationError (debug) veya
      // iterator bozulması → sonsuz döngü (release) oluşuyordu.
      _entriesA = [..._entriesA, entry];
      _sessionDrinkCountA++;
      await _sessionRepo.addEntry(entry, profileId: 'A');
    } else {
      // BUG FIX: Aynı immutable liste düzeltmesi — Profile B için.
      _entriesB = [..._entriesB, entry];
      _sessionDrinkCountB++;
      await _sessionRepo.addEntry(entry, profileId: 'B');
    }
    _recalculateBac();
    notifyListeners();
  }

  /// Belirli ID'ye sahip içkiyi her iki listeden de sil
  void removeEntry(String entryId) {
    _entriesA = _entriesA.where((e) => e.id != entryId).toList();
    _entriesB = _entriesB.where((e) => e.id != entryId).toList();
    _recalculateBac();
    notifyListeners();
  }

  /// Aktif profilin son içkisini sil
  void removeLastEntry() {
    if (_activeProfileId == 'A' && _entriesA.isNotEmpty) {
      _entriesA = _entriesA.sublist(0, _entriesA.length - 1);
    } else if (_activeProfileId == 'B' && _entriesB.isNotEmpty) {
      _entriesB = _entriesB.sublist(0, _entriesB.length - 1);
    }
    _recalculateBac();
    notifyListeners();
  }

  /// Aktif profilin kayıtlarını sıfırla
  Future<void> resetSession() async {
    if (_activeProfileId == 'A') {
      // BUG FIX: .clear() yerine yeni boş liste — immutable state güncellemesi.
      _entriesA = [];
      _sessionDrinkCountA = 0;
      await _sessionRepo.clearAll(profileId: 'A');
    } else {
      // BUG FIX: .clear() yerine yeni boş liste — immutable state güncellemesi.
      _entriesB = [];
      _sessionDrinkCountB = 0;
      await _sessionRepo.clearAll(profileId: 'B');
    }
    _hasShownLegalWarning = false;
    _wasAboveLegal = false;
    _recalculateBac();
    notifyListeners();
  }

  /// BAC ve geri sayımları yeniden hesapla — aktif profil için
  void _recalculateBac() {
    final profile = activeProfile;
    if (profile == null) {
      _currentBac = 0.0;
      _timeToLegal = '00:00:00';
      _timeToZero = '00:00:00';
      return;
    }

    final userProfile = profile.toUserProfile();
    final activeEntries = _activeProfileId == 'A' ? _entriesA : _entriesB;

    _currentBac = BacCalculator.calculateBac(
      profile: userProfile,
      entries: activeEntries,
    );

    _hoursToLegal =
        BacCalculator.hoursToLegalLimit(_currentBac, legalLimit);
    _hoursToZero = BacCalculator.hoursToZero(_currentBac);

    _timeToLegal = BacCalculator.formatDuration(_hoursToLegal);
    _timeToZero = BacCalculator.formatDuration(_hoursToZero);
  }

  double _hoursToLegal = 0.0;
  double _hoursToZero = 0.0;
  int _tickCount = 0;

  /// 1 saniyelik periyodik güncelleme
  void _startPeriodicUpdate() {
    _updateTimer?.cancel();
    _tickCount = 0;
    _updateTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _tickCount++;
        // Her 30 saniyede bir (30 tick) ağır _recalculateBac() fonksiyonunu çalıştırıyoruz.
        if (_tickCount >= 30) {
          _recalculateBac();
          _tickCount = 0;
        } else {
          // Diğer saniyelerde (hafif işlem) saniye düşümü yaparak ekranı güncelliyoruz.
          if (_hoursToLegal > 0) {
            _hoursToLegal = (_hoursToLegal - (1.0 / 3600.0)).clamp(0.0, double.infinity);
            _timeToLegal = BacCalculator.formatDuration(_hoursToLegal);
          }
          if (_hoursToZero > 0) {
            _hoursToZero = (_hoursToZero - (1.0 / 3600.0)).clamp(0.0, double.infinity);
            _timeToZero = BacCalculator.formatDuration(_hoursToZero);
          }
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}
