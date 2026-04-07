import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/models/user_profile.dart';

/// v1.0.2 migrasyon servisi.
/// Mevcut tek profil verisini çoklu profil formatına dönüştürür.
/// Bir seferlik çalışır, idempotent'tir, veri kaybı olmaz.
class MigrationService {
  static const String _migrationFlag = 'migration_v1_0_3_done';
  static const String _legacyProfileKey = 'user_profile';
  static const String _legacyEntriesKey = 'drink_entries';
  static const String _sessionProfilePrefix = 'session_profile_';
  static const String _sessionEntriesPrefix = 'drink_entries_';

  MigrationService._();

  /// Migrasyon gerekiyorsa çalıştırır.
  /// Mevcut user_profile → session_profile_A
  /// Mevcut drink_entries → drink_entries_A
  static Future<void> runIfNeeded(SharedPreferences prefs) async {
    // Zaten migrate edilmişse atla
    if (prefs.getBool(_migrationFlag) == true) return;

    // Eski profil verisi var mı kontrol et
    final legacyProfileJson = prefs.getString(_legacyProfileKey);
    if (legacyProfileJson != null) {
      try {
        // 1. Eski profili oku ve SessionProfile'a dönüştür
        final legacyMap = json.decode(legacyProfileJson) as Map<String, dynamic>;
        final legacyProfile = UserProfile.fromJson(legacyMap);
        final sessionProfile = SessionProfile.fromLegacyUserProfile(legacyProfile).copyWith(
          selectedCountryCode: null,
          selectedLocale: null,
        );

        // 2. Yeni formatta kaydet
        final sessionJson = json.encode(sessionProfile.toJson());
        await prefs.setString('${_sessionProfilePrefix}A', sessionJson);

        // 3. Drink entries'i profil bazlı key'e taşı
        final legacyEntries = prefs.getString(_legacyEntriesKey);
        if (legacyEntries != null) {
          await prefs.setString('${_sessionEntriesPrefix}A', legacyEntries);
        }
      } catch (e) {
        // Migrasyon hatası durumunda eski veri korunur
        // Bir sonraki açılışta tekrar denenecek
        return;
      }
    }

    // Migrasyon tamamlandı flag'ini set et
    await prefs.setBool(_migrationFlag, true);
  }
}
