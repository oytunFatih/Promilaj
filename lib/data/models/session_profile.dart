
import 'package:flutter/material.dart';
import 'package:promilaj/data/models/user_profile.dart';

/// Çoklu profil desteği için oturum profili modeli.
/// Mevcut UserProfile'ı genişletir — her profil kendi BAC takibine sahiptir.
/// Mimari N profil desteği için hazırdır; şimdilik max 2 profil (A + B).
enum VehicleType {
  motorcycle, // Motorcycle / Motosiklet
  car,        // Car / Otomobil
  truckOrBus, // Truck or Bus / Kamyon veya Otobüs
}

class SessionProfile {
  /// Profil kimliği — 'A' (birincil) veya 'B' (misafir)
  final String id;

  /// Boy (santimetre)
  final double heightCm;

  /// Kilo (kilogram)
  final double weightKg;

  /// Biyolojik cinsiyet
  final BiologicalSex sex;

  /// Yaş (yıl)
  final int age;

  /// Seçilen dil ('tr', 'en' vb.)
  final Locale? selectedLocale;

  /// Seçilen ülke kodu (Manuel seçim. Otomatik için null)
  final String? selectedCountryCode;

  /// Kullanıcının seçtiği araç tipi
  final VehicleType vehicleType;

  const SessionProfile({
    required this.id,
    required this.heightCm,
    required this.weightKg,
    required this.sex,
    required this.age,
    this.selectedLocale,
    this.selectedCountryCode,
    this.vehicleType = VehicleType.car,
  });

  /// Eski UserProfile'dan SessionProfile oluşturma (migrasyon için)
  factory SessionProfile.fromLegacyUserProfile(UserProfile legacy) {
    return SessionProfile(
      id: 'A',
      heightCm: legacy.heightCm,
      weightKg: legacy.weightKg,
      sex: legacy.sex,
      age: legacy.age,
      selectedLocale: null, // Cihaz dili varsayılan
      selectedCountryCode: null, // GPS otomatik
      vehicleType: VehicleType.car, // Varsayılan araç tipi
    );
  }

  /// UserProfile'a dönüştürme (geriye uyumluluk)
  UserProfile toUserProfile() {
    return UserProfile(
      heightCm: heightCm,
      weightKg: weightKg,
      sex: sex,
      age: age,
    );
  }

  /// JSON dönüşümü — SharedPreferences ile kayıt için
  Map<String, dynamic> toJson() => {
        'id': id,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'sex': sex.name,
        'age': age,
        'selectedLocale': selectedLocale?.languageCode,
        'selectedCountryCode': selectedCountryCode,
        'vehicleType': vehicleType.name,
      };

  /// JSON'dan nesne oluşturma
  factory SessionProfile.fromJson(Map<String, dynamic> json) => SessionProfile(
        id: json['id'] as String,
        heightCm: (json['heightCm'] as num).toDouble(),
        weightKg: (json['weightKg'] as num).toDouble(),
        sex: BiologicalSex.values.byName(json['sex'] as String),
        age: json['age'] as int,
        selectedLocale: json['selectedLocale'] != null ? Locale(json['selectedLocale'] as String) : (json['selectedLanguage'] != null ? Locale(json['selectedLanguage'] as String) : null),
        selectedCountryCode: json['selectedCountryCode'] as String?,
        vehicleType: json['vehicleType'] != null 
            ? VehicleType.values.byName(json['vehicleType'] as String) 
            : VehicleType.car,
      );

  /// Güncelleme kolaylığı için kopyalama metodu
  SessionProfile copyWith({
    String? id,
    double? heightCm,
    double? weightKg,
    BiologicalSex? sex,
    int? age,
    Locale? selectedLocale,
    String? selectedCountryCode,
    VehicleType? vehicleType,
  }) {
    return SessionProfile(
      id: id ?? this.id,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      selectedLocale: selectedLocale ?? this.selectedLocale,
      selectedCountryCode: selectedCountryCode ?? this.selectedCountryCode,
      vehicleType: vehicleType ?? this.vehicleType,
    );
  }
}
