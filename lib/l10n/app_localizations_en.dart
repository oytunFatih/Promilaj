// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Promilaj';

  @override
  String get welcomeSubtitle => 'Personal BAC Calculator & Tracker';

  @override
  String get heightLabel => 'Height';

  @override
  String get heightHint => 'Enter height in cm';

  @override
  String get weightLabel => 'Weight';

  @override
  String get weightHint => 'Enter weight in kg';

  @override
  String get sexLabel => 'Biological Sex';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get ageLabel => 'Age';

  @override
  String get ageHint => 'Enter age in years';

  @override
  String get continueButton => 'Continue';

  @override
  String get addDrink => 'Add Drink';

  @override
  String get selectDrinkType => 'Select Drink Type';

  @override
  String get selectBrand => 'Select Brand';

  @override
  String get searchBrands => 'Search brands...';

  @override
  String get amountAndTime => 'Amount & Time';

  @override
  String get amountLabel => 'Amount';

  @override
  String get hoursAgoLabel => 'How many hours ago?';

  @override
  String get hours => 'h';

  @override
  String get addButton => 'Add';

  @override
  String get soberStatus => 'Sober';

  @override
  String get timeToLegalLimit => 'Time to Legal Limit';

  @override
  String get withinLegalLimit => 'Within legal limit';

  @override
  String get timeToZero => 'Time to Zero';

  @override
  String get legalLimitLabel => 'Legal Limit';

  @override
  String get legalInfoButton => 'Legal Information';

  @override
  String get legalInfoNoLocation =>
      'Location not yet detected. Please grant location permission.';

  @override
  String get settings => 'Settings';

  @override
  String get profileSection => 'PROFILE';

  @override
  String get languageSection => 'LANGUAGE';

  @override
  String get save => 'Save';

  @override
  String get resetTitle => 'Reset Session';

  @override
  String get resetMessage =>
      'Do you want to clear all drinks and reset timers?';

  @override
  String get reset => 'Reset';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get waterReminderTitle => 'Stay Hydrated!';

  @override
  String get waterReminderMessage => 'Don\'t forget to drink water! 💧';

  @override
  String get legalWarningTitle => 'Warning';

  @override
  String get legalWarningMessage => '⚠️ You are over the legal driving limit.';

  @override
  String get locationPermissionTitle => 'Location Needed';

  @override
  String get locationPermissionMessage =>
      'We need your location to show the legal BAC limit for your country.';

  @override
  String get continueWithoutLocation => 'Continue without location';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get categoryBeer => 'BEER';

  @override
  String get categoryWine => 'WINE';

  @override
  String get categorySpirits => 'SPIRITS';

  @override
  String get categoryCocktails => 'COCKTAILS';

  @override
  String get typeLager => 'Lager';

  @override
  String get typePilsner => 'Pilsner';

  @override
  String get typeAle => 'Ale';

  @override
  String get typeStout => 'Stout';

  @override
  String get typeWheatBeer => 'Wheat Beer';

  @override
  String get typeIpa => 'IPA';

  @override
  String get typeRedWine => 'Red Wine';

  @override
  String get typeWhiteWine => 'White Wine';

  @override
  String get typeRose => 'Rosé';

  @override
  String get typeSparklingWine => 'Sparkling Wine';

  @override
  String get typeChampagne => 'Champagne';

  @override
  String get typeProsecco => 'Prosecco';

  @override
  String get typeVodka => 'Vodka';

  @override
  String get typeWhisky => 'Whisky';

  @override
  String get typeRum => 'Rum';

  @override
  String get typeGin => 'Gin';

  @override
  String get typeTequila => 'Tequila';

  @override
  String get typeBrandy => 'Brandy';

  @override
  String get typeRaki => 'Raki';

  @override
  String get typeOuzo => 'Ouzo';

  @override
  String get addGuestProfile => 'Add Guest Profile';

  @override
  String get removeGuestProfile => 'Remove Guest Profile';

  @override
  String get guestProfileDesc =>
      'Enter the guest\'s information to track their BAC separately.';

  @override
  String get removeGuestConfirm =>
      'Guest profile and all their drink records will be removed. Continue?';

  @override
  String addingFor(String name) {
    return 'Adding for: $name';
  }

  @override
  String resetConfirmFor(String name) {
    return 'All drink records for Profile $name will be cleared.';
  }

  @override
  String get languageLabel => 'Language';

  @override
  String get countryLabel => 'Country';

  @override
  String get autoDetect => '🌍 Auto-detect (GPS)';

  @override
  String get otherBrand => 'Other';

  @override
  String get manualAbvLabel => 'Enter ABV (%)';

  @override
  String get manualAbvError => 'Please enter a value between 0.1 and 96.0';

  @override
  String get infoScreenNext => 'Next';

  @override
  String get infoButtonTitle => 'Info';

  @override
  String get infoPlaceholderText =>
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';

  @override
  String get infoCloseButton => 'Close';

  @override
  String get vehicleTypeSectionLabel => 'Vehicle Type';

  @override
  String get vehicleMotorcycle => 'Motorcycle';

  @override
  String get vehicleCar => 'Car';

  @override
  String get vehicleTruckOrBus => 'Truck or Bus';
}
