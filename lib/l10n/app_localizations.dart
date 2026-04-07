import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_az.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('az'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Promilaj'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Personal BAC Calculator & Tracker'**
  String get welcomeSubtitle;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get heightLabel;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'Enter height in cm'**
  String get heightHint;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightLabel;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg'**
  String get weightHint;

  /// No description provided for @sexLabel.
  ///
  /// In en, this message translates to:
  /// **'Biological Sex'**
  String get sexLabel;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter age in years'**
  String get ageHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @addDrink.
  ///
  /// In en, this message translates to:
  /// **'Add Drink'**
  String get addDrink;

  /// No description provided for @selectDrinkType.
  ///
  /// In en, this message translates to:
  /// **'Select Drink Type'**
  String get selectDrinkType;

  /// No description provided for @selectBrand.
  ///
  /// In en, this message translates to:
  /// **'Select Brand'**
  String get selectBrand;

  /// No description provided for @searchBrands.
  ///
  /// In en, this message translates to:
  /// **'Search brands...'**
  String get searchBrands;

  /// No description provided for @amountAndTime.
  ///
  /// In en, this message translates to:
  /// **'Amount & Time'**
  String get amountAndTime;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @hoursAgoLabel.
  ///
  /// In en, this message translates to:
  /// **'How many hours ago?'**
  String get hoursAgoLabel;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hours;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @soberStatus.
  ///
  /// In en, this message translates to:
  /// **'Sober'**
  String get soberStatus;

  /// No description provided for @timeToLegalLimit.
  ///
  /// In en, this message translates to:
  /// **'Time to Legal Limit'**
  String get timeToLegalLimit;

  /// No description provided for @withinLegalLimit.
  ///
  /// In en, this message translates to:
  /// **'Within legal limit'**
  String get withinLegalLimit;

  /// No description provided for @timeToZero.
  ///
  /// In en, this message translates to:
  /// **'Time to Zero'**
  String get timeToZero;

  /// No description provided for @legalLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Legal Limit'**
  String get legalLimitLabel;

  /// No description provided for @legalInfoButton.
  ///
  /// In en, this message translates to:
  /// **'Legal Information'**
  String get legalInfoButton;

  /// No description provided for @legalInfoNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Location not yet detected. Please grant location permission.'**
  String get legalInfoNoLocation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileSection;

  /// No description provided for @languageSection.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get languageSection;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Session'**
  String get resetTitle;

  /// No description provided for @resetMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to clear all drinks and reset timers?'**
  String get resetMessage;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @waterReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated!'**
  String get waterReminderTitle;

  /// No description provided for @waterReminderMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to drink water! 💧'**
  String get waterReminderMessage;

  /// No description provided for @legalWarningTitle.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get legalWarningTitle;

  /// No description provided for @legalWarningMessage.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You are over the legal driving limit.'**
  String get legalWarningMessage;

  /// No description provided for @locationPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Needed'**
  String get locationPermissionTitle;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We need your location to show the legal BAC limit for your country.'**
  String get locationPermissionMessage;

  /// No description provided for @continueWithoutLocation.
  ///
  /// In en, this message translates to:
  /// **'Continue without location'**
  String get continueWithoutLocation;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @categoryBeer.
  ///
  /// In en, this message translates to:
  /// **'BEER'**
  String get categoryBeer;

  /// No description provided for @categoryWine.
  ///
  /// In en, this message translates to:
  /// **'WINE'**
  String get categoryWine;

  /// No description provided for @categorySpirits.
  ///
  /// In en, this message translates to:
  /// **'SPIRITS'**
  String get categorySpirits;

  /// No description provided for @categoryCocktails.
  ///
  /// In en, this message translates to:
  /// **'COCKTAILS'**
  String get categoryCocktails;

  /// No description provided for @typeLager.
  ///
  /// In en, this message translates to:
  /// **'Lager'**
  String get typeLager;

  /// No description provided for @typePilsner.
  ///
  /// In en, this message translates to:
  /// **'Pilsner'**
  String get typePilsner;

  /// No description provided for @typeAle.
  ///
  /// In en, this message translates to:
  /// **'Ale'**
  String get typeAle;

  /// No description provided for @typeStout.
  ///
  /// In en, this message translates to:
  /// **'Stout'**
  String get typeStout;

  /// No description provided for @typeWheatBeer.
  ///
  /// In en, this message translates to:
  /// **'Wheat Beer'**
  String get typeWheatBeer;

  /// No description provided for @typeIpa.
  ///
  /// In en, this message translates to:
  /// **'IPA'**
  String get typeIpa;

  /// No description provided for @typeRedWine.
  ///
  /// In en, this message translates to:
  /// **'Red Wine'**
  String get typeRedWine;

  /// No description provided for @typeWhiteWine.
  ///
  /// In en, this message translates to:
  /// **'White Wine'**
  String get typeWhiteWine;

  /// No description provided for @typeRose.
  ///
  /// In en, this message translates to:
  /// **'Rosé'**
  String get typeRose;

  /// No description provided for @typeSparklingWine.
  ///
  /// In en, this message translates to:
  /// **'Sparkling Wine'**
  String get typeSparklingWine;

  /// No description provided for @typeChampagne.
  ///
  /// In en, this message translates to:
  /// **'Champagne'**
  String get typeChampagne;

  /// No description provided for @typeProsecco.
  ///
  /// In en, this message translates to:
  /// **'Prosecco'**
  String get typeProsecco;

  /// No description provided for @typeVodka.
  ///
  /// In en, this message translates to:
  /// **'Vodka'**
  String get typeVodka;

  /// No description provided for @typeWhisky.
  ///
  /// In en, this message translates to:
  /// **'Whisky'**
  String get typeWhisky;

  /// No description provided for @typeRum.
  ///
  /// In en, this message translates to:
  /// **'Rum'**
  String get typeRum;

  /// No description provided for @typeGin.
  ///
  /// In en, this message translates to:
  /// **'Gin'**
  String get typeGin;

  /// No description provided for @typeTequila.
  ///
  /// In en, this message translates to:
  /// **'Tequila'**
  String get typeTequila;

  /// No description provided for @typeBrandy.
  ///
  /// In en, this message translates to:
  /// **'Brandy'**
  String get typeBrandy;

  /// No description provided for @typeRaki.
  ///
  /// In en, this message translates to:
  /// **'Raki'**
  String get typeRaki;

  /// No description provided for @typeOuzo.
  ///
  /// In en, this message translates to:
  /// **'Ouzo'**
  String get typeOuzo;

  /// No description provided for @addGuestProfile.
  ///
  /// In en, this message translates to:
  /// **'Add Guest Profile'**
  String get addGuestProfile;

  /// No description provided for @removeGuestProfile.
  ///
  /// In en, this message translates to:
  /// **'Remove Guest Profile'**
  String get removeGuestProfile;

  /// No description provided for @guestProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the guest\'s information to track their BAC separately.'**
  String get guestProfileDesc;

  /// No description provided for @removeGuestConfirm.
  ///
  /// In en, this message translates to:
  /// **'Guest profile and all their drink records will be removed. Continue?'**
  String get removeGuestConfirm;

  /// No description provided for @addingFor.
  ///
  /// In en, this message translates to:
  /// **'Adding for: {name}'**
  String addingFor(String name);

  /// No description provided for @resetConfirmFor.
  ///
  /// In en, this message translates to:
  /// **'All drink records for Profile {name} will be cleared.'**
  String resetConfirmFor(String name);

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'🌍 Auto-detect (GPS)'**
  String get autoDetect;

  /// No description provided for @otherBrand.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherBrand;

  /// No description provided for @manualAbvLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter ABV (%)'**
  String get manualAbvLabel;

  /// No description provided for @manualAbvError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value between 0.1 and 96.0'**
  String get manualAbvError;

  /// No description provided for @infoScreenNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get infoScreenNext;

  /// No description provided for @infoButtonTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoButtonTitle;

  /// No description provided for @infoPlaceholderText.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'**
  String get infoPlaceholderText;

  /// No description provided for @infoCloseButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get infoCloseButton;

  /// No description provided for @vehicleTypeSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleTypeSectionLabel;

  /// No description provided for @vehicleMotorcycle.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get vehicleMotorcycle;

  /// No description provided for @vehicleCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get vehicleCar;

  /// No description provided for @vehicleTruckOrBus.
  ///
  /// In en, this message translates to:
  /// **'Truck or Bus'**
  String get vehicleTruckOrBus;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['az', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'az':
      return AppLocalizationsAz();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
