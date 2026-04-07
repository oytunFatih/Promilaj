/// Ülkelere göre yasal kan alkol limitleri (‰ — promil).
/// ISO 3166-1 alpha-2 ülke kodu → yasal BAC limiti.
/// Harici API çağrısı YAPILMAZ — tüm veriler burada gömülüdür.
class CountryLegalLimits {
  final double car;
  final double motorcycle;
  final double truckOrBus;

  const CountryLegalLimits({
    required this.car,
    required this.motorcycle,
    required this.truckOrBus,
  });
}

const Map<String, CountryLegalLimits> legalBacLimits = {
  // Avrupa
  'TR': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'DE': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'GB': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.80),
  'FR': CountryLegalLimits(car: 0.50, motorcycle: 0.20, truckOrBus: 0.20),
  'ES': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.30),
  'IT': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'PT': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'NL': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'BE': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'AT': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'CH': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'SE': CountryLegalLimits(car: 0.20, motorcycle: 0.20, truckOrBus: 0.10),
  'NO': CountryLegalLimits(car: 0.20, motorcycle: 0.20, truckOrBus: 0.0),
  'DK': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'FI': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'PL': CountryLegalLimits(car: 0.20, motorcycle: 0.20, truckOrBus: 0.0),
  'CZ': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.00),
  'SK': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'HU': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'RO': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'BG': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'HR': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'SI': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'RS': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'GR': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'IE': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'IS': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'LU': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'EE': CountryLegalLimits(car: 0.20, motorcycle: 0.20, truckOrBus: 0.0),
  'LV': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'LT': CountryLegalLimits(car: 0.40, motorcycle: 0.40, truckOrBus: 0.0),
  'UA': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'BY': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'MD': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'AL': CountryLegalLimits(car: 0.10, motorcycle: 0.10, truckOrBus: 0.0),
  'MK': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'BA': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'ME': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'RU': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.00),

  // Asya
  'AZ': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.00),
  'GE': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'JP': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'KR': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'CN': CountryLegalLimits(car: 0.20, motorcycle: 0.20, truckOrBus: 0.0),
  'IN': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'TH': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'VN': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'PH': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'MY': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.0),
  'SG': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.0),
  'ID': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'IL': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'AE': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'SA': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'KZ': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),

  // Amerika
  'US': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.40),
  'CA': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.0),
  'MX': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.0),
  'BR': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'AR': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'CL': CountryLegalLimits(car: 0.30, motorcycle: 0.30, truckOrBus: 0.0),
  'CO': CountryLegalLimits(car: 0.40, motorcycle: 0.40, truckOrBus: 0.0),
  'PE': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),

  // Afrika & Okyanusya
  'ZA': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'AU': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'NZ': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'EG': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'NG': CountryLegalLimits(car: 0.50, motorcycle: 0.50, truckOrBus: 0.0),
  'KE': CountryLegalLimits(car: 0.80, motorcycle: 0.80, truckOrBus: 0.0),
  'MA': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
  'TN': CountryLegalLimits(car: 0.00, motorcycle: 0.00, truckOrBus: 0.0),
};
