// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get welcomeTitle => 'Promilaj';

  @override
  String get welcomeSubtitle => 'Kişisel Kan Alkol Hesaplayıcı ve Takipçi';

  @override
  String get heightLabel => 'Boy';

  @override
  String get heightHint => 'Boyunuzu cm cinsinden girin';

  @override
  String get weightLabel => 'Kilo';

  @override
  String get weightHint => 'Kilonuzu kg cinsinden girin';

  @override
  String get sexLabel => 'Biyolojik Cinsiyet';

  @override
  String get male => 'Erkek';

  @override
  String get female => 'Kadın';

  @override
  String get ageLabel => 'Yaş';

  @override
  String get ageHint => 'Yaşınızı girin';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get addDrink => 'İçki Ekle';

  @override
  String get selectDrinkType => 'İçki Türü Seçin';

  @override
  String get selectBrand => 'Marka Seçin';

  @override
  String get searchBrands => 'Marka ara...';

  @override
  String get amountAndTime => 'Miktar ve Zaman';

  @override
  String get amountLabel => 'Miktar';

  @override
  String get hoursAgoLabel => 'Kaç saat önce içildi?';

  @override
  String get hours => 'sa';

  @override
  String get addButton => 'Ekle';

  @override
  String get soberStatus => 'Ayık';

  @override
  String get timeToLegalLimit => 'Yasal Limite Kalan Süre';

  @override
  String get withinLegalLimit => 'Yasal limit dahilinde';

  @override
  String get timeToZero => 'Tamamen Temizlenme Süresi';

  @override
  String get legalLimitLabel => 'Yasal Limit';

  @override
  String get legalInfoButton => 'Yasal Bilgi';

  @override
  String get legalInfoNoLocation =>
      'Konum henüz tespit edilmedi. Lütfen konum izni verin.';

  @override
  String get settings => 'Ayarlar';

  @override
  String get profileSection => 'PROFİL';

  @override
  String get languageSection => 'DİL';

  @override
  String get save => 'Kaydet';

  @override
  String get resetTitle => 'Oturumu Sıfırla';

  @override
  String get resetMessage =>
      'Tüm içki kayıtlarını temizlemek ve zamanlayıcıları sıfırlamak istiyor musunuz?';

  @override
  String get reset => 'Sıfırla';

  @override
  String get cancel => 'İptal';

  @override
  String get ok => 'Tamam';

  @override
  String get waterReminderTitle => 'Susuz Kalmayın!';

  @override
  String get waterReminderMessage => 'Su içmeyi unutmayın! 💧';

  @override
  String get legalWarningTitle => 'Uyarı';

  @override
  String get legalWarningMessage => '⚠️ Yasal sürüş limitinin üzerindesiniz.';

  @override
  String get locationPermissionTitle => 'Konum İzni Gerekli';

  @override
  String get locationPermissionMessage =>
      'Ülkenizin yasal alkol limitini gösterebilmemiz için konum bilginize ihtiyacımız var.';

  @override
  String get continueWithoutLocation => 'Konum olmadan devam et';

  @override
  String get grantPermission => 'İzin Ver';

  @override
  String get categoryBeer => 'BİRA';

  @override
  String get categoryWine => 'ŞARAP';

  @override
  String get categorySpirits => 'SERT İÇKİLER';

  @override
  String get categoryCocktails => 'KOKTEYLLER';

  @override
  String get typeLager => 'Açık Bira';

  @override
  String get typePilsner => 'Pilsner';

  @override
  String get typeAle => 'Ale';

  @override
  String get typeStout => 'Siyah Bira';

  @override
  String get typeWheatBeer => 'Buğday Birası';

  @override
  String get typeIpa => 'IPA';

  @override
  String get typeRedWine => 'Kırmızı Şarap';

  @override
  String get typeWhiteWine => 'Beyaz Şarap';

  @override
  String get typeRose => 'Roze';

  @override
  String get typeSparklingWine => 'Köpüklü Şarap';

  @override
  String get typeChampagne => 'Şampanya';

  @override
  String get typeProsecco => 'Prosecco';

  @override
  String get typeVodka => 'Votka';

  @override
  String get typeWhisky => 'Viski';

  @override
  String get typeRum => 'Rom';

  @override
  String get typeGin => 'Cin';

  @override
  String get typeTequila => 'Tekila';

  @override
  String get typeBrandy => 'Brandy';

  @override
  String get typeRaki => 'Rakı';

  @override
  String get typeOuzo => 'Uzo';

  @override
  String get addGuestProfile => 'Misafir Profil Ekle';

  @override
  String get removeGuestProfile => 'Misafir Profili Kaldır';

  @override
  String get guestProfileDesc =>
      'Misafirin BAC\'ını ayrı takip etmek için bilgilerini girin.';

  @override
  String get removeGuestConfirm =>
      'Misafir profili ve tüm içki kayıtları kaldırılacak. Devam edilsin mi?';

  @override
  String addingFor(String name) {
    return '$name için ekleniyor';
  }

  @override
  String resetConfirmFor(String name) {
    return 'Profil $name için tüm içki kayıtları silinecek.';
  }

  @override
  String get languageLabel => 'Dil';

  @override
  String get countryLabel => 'Ülke';

  @override
  String get autoDetect => '🌍 Auto-detect (GPS)';

  @override
  String get otherBrand => 'Diğer / Bilmiyorum';

  @override
  String get manualAbvLabel => 'ABV Girin (%)';

  @override
  String get manualAbvError => 'Lütfen 0,1 ile 96,0 arasında bir değer girin';

  @override
  String get infoScreenNext => 'İleri';

  @override
  String get infoButtonTitle => 'Bilgi';

  @override
  String get infoPlaceholderText =>
      'Promilaj Nedir?\\nPromilaj, kan alkol seviyenizi (BAC) Widmark formülüyle hesaplayan bir araçtır. Bulunduğunuz ülkenin yasal limitlerini gösterir ve ne zaman araç kullanabileceğinizi tahmin eder.\\n\\nLütfen Dikkat\\nAlkollüyken araç kullanmayın. Bu uygulama bir alkol ölçer cihazının yerini tutmaz; yalnızca tahmini bir hesaplama sunar. Emin olmak için her zaman bekleyin.\\n\\nKonum İzni\\nBulunduğunuz ülkeye göre yasal alkol limitini otomatik gösterebilmek için konumunuza ihtiyaç duyuyoruz. Konum bilginiz cihazınızda kalır, hiçbir sunucuya gönderilmez.\\n\\nNeden Bu Bilgileri İstiyoruz?\\nAğırlık, boy ve içtiğiniz içeceğin türü kan alkol seviyenizi doğrudan etkiler. Girdiğiniz bilgiler yalnızca hesaplama amacıyla kullanılır, saklanmaz veya paylaşılmaz.\\n\\nBiyolojik Cinsiyet mi, Cinsiyet mi?\\nWidmark formülü vücuttaki su ve yağ oranına dayandığından biyolojik cinsiyet (erkek/kadın) sorar. Bu soru cinsiyet kimliğinizle ilgili değildir; yalnızca metabolizma hesabı içindir.\\n\\nPromil (‰) Nedir?\\nPromil, binde bir anlamına gelir. Kanda 1‰ alkol, her 1.000 gram kanda 1 gram alkol demektir. Yüzde yerine binde kullanılır çünkü kan alkol seviyeleri çok küçük miktarlarla ifade edilir.\\n\\nYasal Uyarı\\nBu uygulama yalnızca bilgilendirme amaçlıdır. Sunulan değerler tahminidir; gerçek kan alkol seviyeniz farklılık gösterebilir. Yaş, ilaç kullanımı, tokluk durumu ve genetik faktörler her bireyin metabolizmasını etkiler. Yasal bir karar öncesinde onaylı bir alkol ölçer kullanınız. Geliştirici ve uygulama, bu bilgiler doğrultusunda alınan kararlardan sorumlu tutulamaz.';

  @override
  String get infoCloseButton => 'Kapat';

  @override
  String get vehicleTypeSectionLabel => 'Araç Türü';

  @override
  String get vehicleMotorcycle => 'Motosiklet';

  @override
  String get vehicleCar => 'Otomobil';

  @override
  String get vehicleTruckOrBus => 'Kamyon veya Otobüs';
}
