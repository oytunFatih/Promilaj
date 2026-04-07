import 'package:promilaj/core/utils/location_service.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/data/datasources/legal_limits_data.dart';

abstract class ICountryResolver {
  /// Returns the ISO country code to use for legal calculations.
  /// Priority: manual selection > GPS detection > fallback ('XX')
  String resolveCountryCode(SessionProfile profile);

  /// Resolves the specific limit based on country and vehicle type.
  double resolveLegalLimit(SessionProfile profile);
}

class CountryResolver implements ICountryResolver {
  final LocationService _locationService;

  CountryResolver(this._locationService);

  @override
  String resolveCountryCode(SessionProfile profile) {
    if (profile.selectedCountryCode != null) {
      return profile.selectedCountryCode ?? _locationService.countryCode ?? 'XX'; // Manual override wins
    }
    return _locationService.countryCode ?? 'XX'; // GPS fallback
  }

  @override
  double resolveLegalLimit(SessionProfile profile) {
    final code = resolveCountryCode(profile);
    final limits = legalBacLimits[code] ?? 
      const CountryLegalLimits(car: 0.0, motorcycle: 0.0, truckOrBus: 0.0);
      
    switch (profile.vehicleType) {
      case VehicleType.car:
        return limits.car;
      case VehicleType.motorcycle:
        return limits.motorcycle;
      case VehicleType.truckOrBus:
        return limits.truckOrBus;
    }
  }
}
