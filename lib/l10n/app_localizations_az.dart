// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Azerbaijani (`az`).
class AppLocalizationsAz extends AppLocalizations {
  AppLocalizationsAz([String locale = 'az']) : super(locale);

  @override
  String get welcomeTitle => 'Promilaj';

  @override
  String get welcomeSubtitle => 'Şəxsi Qan Alkoqol Hesablayıcısı və İzləyicisi';

  @override
  String get heightLabel => 'Boy';

  @override
  String get heightHint => 'Boyu cm ilə daxil edin';

  @override
  String get weightLabel => 'Çəki';

  @override
  String get weightHint => 'Çəkini kg ilə daxil edin';

  @override
  String get sexLabel => 'Bioloji Cinsiyyət';

  @override
  String get male => 'Kişi';

  @override
  String get female => 'Qadın';

  @override
  String get ageLabel => 'Yaş';

  @override
  String get ageHint => 'Yaşı daxil edin';

  @override
  String get continueButton => 'Davam Et';

  @override
  String get addDrink => 'İçki Əlavə Et';

  @override
  String get selectDrinkType => 'İçki Növünü Seçin';

  @override
  String get selectBrand => 'Brend Seçin';

  @override
  String get searchBrands => 'Brend axtar...';

  @override
  String get amountAndTime => 'Miqdar və Zaman';

  @override
  String get amountLabel => 'Miqdar';

  @override
  String get hoursAgoLabel => 'Neçə saat əvvəl içilib?';

  @override
  String get hours => 'sa';

  @override
  String get addButton => 'Əlavə Et';

  @override
  String get soberStatus => 'Ayıq';

  @override
  String get timeToLegalLimit => 'Qanuni Limitə Qalan Vaxt';

  @override
  String get withinLegalLimit => 'Qanuni limit daxilində';

  @override
  String get timeToZero => 'Tamamilə Təmizlənmə Vaxtı';

  @override
  String get legalLimitLabel => 'Qanuni Limit';

  @override
  String get legalInfoButton => 'Qanuni Məlumat';

  @override
  String get legalInfoNoLocation =>
      'Məkan hələ müəyyən edilməyib. Zəhmət olmasa məkan icazəsi verin.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profileSection => 'PROFİL';

  @override
  String get languageSection => 'DİL';

  @override
  String get save => 'Yadda Saxla';

  @override
  String get resetTitle => 'Sessiyanı Sıfırla';

  @override
  String get resetMessage =>
      'Bütün içki qeydlərini təmizləmək və taymerləri sıfırlamaq istəyirsiniz?';

  @override
  String get reset => 'Sıfırla';

  @override
  String get cancel => 'Ləğv Et';

  @override
  String get ok => 'Tamam';

  @override
  String get waterReminderTitle => 'Susuz Qalmayın!';

  @override
  String get waterReminderMessage => 'Su içməyi unutmayın! 💧';

  @override
  String get legalWarningTitle => 'Xəbərdarlıq';

  @override
  String get legalWarningMessage =>
      '⚠️ Qanuni sürücülük limitindən yuxarıdasınız.';

  @override
  String get locationPermissionTitle => 'Məkan İzni Lazımdır';

  @override
  String get locationPermissionMessage =>
      'Ölkənizin qanuni alkoqol limitini göstərə bilməyimiz üçün məkan məlumatınıza ehtiyacımız var.';

  @override
  String get continueWithoutLocation => 'Məkan olmadan davam et';

  @override
  String get grantPermission => 'İzin Ver';

  @override
  String get categoryBeer => 'PİVƏ';

  @override
  String get categoryWine => 'ŞƏRAB';

  @override
  String get categorySpirits => 'SERT İÇKİLƏR';

  @override
  String get categoryCocktails => 'KOKTEYLLƏR';

  @override
  String get typeLager => 'Lager';

  @override
  String get typePilsner => 'Pilsner';

  @override
  String get typeAle => 'Ale';

  @override
  String get typeStout => 'Stout';

  @override
  String get typeWheatBeer => 'Buğda Pivəsi';

  @override
  String get typeIpa => 'IPA';

  @override
  String get typeRedWine => 'Qırmızı Şərab';

  @override
  String get typeWhiteWine => 'Ağ Şərab';

  @override
  String get typeRose => 'Roze';

  @override
  String get typeSparklingWine => 'Köpüklü Şərab';

  @override
  String get typeChampagne => 'Şampan';

  @override
  String get typeProsecco => 'Prosecco';

  @override
  String get typeVodka => 'Araq';

  @override
  String get typeWhisky => 'Viski';

  @override
  String get typeRum => 'Rom';

  @override
  String get typeGin => 'Cin';

  @override
  String get typeTequila => 'Tekila';

  @override
  String get typeBrandy => 'Brendi';

  @override
  String get typeRaki => 'Raqı';

  @override
  String get typeOuzo => 'Uzo';

  @override
  String get addGuestProfile => 'Qonaq Profili Əlavə Et';

  @override
  String get removeGuestProfile => 'Qonaq Profilini Sil';

  @override
  String get guestProfileDesc =>
      'Qonağın BAC-ını ayrıca izləmək üçün məlumatlarını daxil edin.';

  @override
  String get removeGuestConfirm =>
      'Qonaq profili və bütün içki qeydləri silinəcək. Davam edilsin?';

  @override
  String addingFor(String name) {
    return '$name üçün əlavə edilir';
  }

  @override
  String resetConfirmFor(String name) {
    return 'Profil $name üçün bütün içki qeydləri silinəcək.';
  }

  @override
  String get languageLabel => 'Dil';

  @override
  String get countryLabel => 'Ölkə';

  @override
  String get autoDetect => '🌍 Avtomatik Aşkar Et (GPS)';

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
  String get vehicleTypeSectionLabel => 'Nəqliyyat Növü';

  @override
  String get vehicleMotorcycle => 'Motosiklet';

  @override
  String get vehicleCar => 'Avtomobil';

  @override
  String get vehicleTruckOrBus => 'Yük maşını və ya Avtobus';
}
