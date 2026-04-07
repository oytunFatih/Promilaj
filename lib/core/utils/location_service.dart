import 'dart:ui' as ui;

/// Konum servisi — GPS ile ülke tespiti yapar.
/// Konum izni verilmezse varsayılan olarak en muhafazakar limit kullanılır.
class LocationService {
  String? _countryCode;
  bool _permissionDenied = false;

  /// Tespit edilen ülke kodu (ISO 3166-1 alpha-2)
  String? get countryCode => _countryCode;

  /// Konum izni reddedildi mi?
  bool get isPermissionDenied => _permissionDenied;



  /// Konum izni iste ve ülkeyi tespit et.
  /// Başarılıysa true, izin reddedildiyse false döner.
  Future<bool> requestAndDetectCountry() async {
    // BUG FIX (v0.1.11): Geolocator plugin on Windows and some Android Emulators 
    // makes blocking native calls that freeze the entire Flutter UI thread.
    // Instead of forcing a GPS check at startup, we safely read the platform's locale.
    try {
      final localeCountry = ui.PlatformDispatcher.instance.locale.countryCode;
      if (localeCountry != null && localeCountry.isNotEmpty) {
        _countryCode = localeCountry.toUpperCase();
        _permissionDenied = false;
        return true;
      }
    } catch (_) {}

    // Fallback if platform locale is inaccessible
    _countryCode = 'XX';
    _permissionDenied = true;
    return false;
  }

  /// Ülke kodunu manuel olarak ayarla (ör. kullanıcı seçimi veya fallback)
  void setCountryCode(String code) {
    _countryCode = code.toUpperCase();
    _permissionDenied = false;
  }
}
