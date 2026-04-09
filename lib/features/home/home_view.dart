import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:promilaj/core/providers.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/core/theme/widgets/glass_button.dart';
import 'package:promilaj/core/utils/popups.dart';
import 'package:promilaj/data/datasources/legal_info_urls_data.dart';
import 'package:promilaj/features/home/widgets/bac_indicator_widget.dart';
import 'package:promilaj/features/home/widgets/countdown_widget.dart';
import 'package:promilaj/features/home/widgets/profile_switcher_widget.dart';
import 'package:promilaj/data/models/session_profile.dart'; // For VehicleType
import 'package:promilaj/features/add_drink/add_drink_view.dart';
import 'package:promilaj/features/profile/profile_creation_view.dart';
import 'package:promilaj/features/settings/settings_view.dart';
import 'package:promilaj/l10n/app_localizations.dart';

/// Ana ekran — BAC göstergesi, geri sayımlar, profil değiştirme ve eylem butonları.
class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {

  @override
  void initState() {
    super.initState();
    // İlk yükleme
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = ref.read(homeViewModelProvider);
      await vm.initialize();
      // Konum iznini iste
      final granted = await vm.requestLocation();
      if (!granted && mounted) {
        AppPopups.showLocationPermissionDialog(context, () async {
          await vm.requestLocation();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(homeViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (vm.isLoading || l10n == null) {
      return const Scaffold(
        backgroundColor: AppColors.midnight,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Yasal limit aşımı uyarısı
    // BUG FIX: markLegalWarningShown() artık build() dışında çağrılıyor.
    // Eski kodda shouldShowLegalWarning getter'ı build() sırasında state
    // mutasyonu yapıyordu — bu gizli desync'e neden oluyordu.
    // Yasal limit aşımı uyarısı
    if (vm.shouldShowLegalWarning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          vm.markLegalWarningShown();
          AppPopups.showLegalLimitWarning(context);
        }
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.midnight],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Üst bar — ayarlar ikonu + misafir profil ekleme
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Promilaj',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Persistent info button
                        IconButton(
                          icon: const Icon(CupertinoIcons.info,
                              color: AppColors.textSecondary),
                          tooltip: l10n.infoButtonTitle,
                          onPressed: () {
                            final lang = ref.read(settingsViewModelProvider).selectedLanguage;

                            const sections = {
                              'tr': [
                                ('Promilaj Nedir?',
                                    'Promilaj, kan alkol seviyenizi (BAC) Widmark formülüyle hesaplayan bir araçtır. '
                                    'Bulunduğunuz ülkenin yasal limitlerini gösterir ve ne zaman araç kullanabileceğinizi tahmin eder.'),
                                ('Lütfen Dikkat',
                                    'Alkollüyken araç kullanmayın. Bu uygulama bir alkol ölçer cihazının yerini tutmaz; '
                                    'yalnızca tahmini bir hesaplama sunar. Emin olmak için her zaman bekleyin.'),
                                ('Konum İzni',
                                    'Bulunduğunuz ülkeye göre yasal alkol limitini otomatik gösterebilmek için konumunuza '
                                    'ihtiyaç duyuyoruz. Konum bilginiz cihazınızda kalır, hiçbir sunucuya gönderilmez.'),
                                ('Neden Bu Bilgileri İstiyoruz?',
                                    'Ağırlık, boy ve içtiğiniz içeceğin türü kan alkol seviyenizi doğrudan etkiler. '
                                    'Girdiğiniz bilgiler yalnızca hesaplama amacıyla kullanılır, saklanmaz veya paylaşılmaz.'),
                                ('Biyolojik Cinsiyet mi, Cinsiyet mi?',
                                    'Widmark formülü vücuttaki su ve yağ oranına dayandığından biyolojik cinsiyet (erkek/kadın) sorar. '
                                    'Bu soru cinsiyet kimliğinizle ilgili değildir; yalnızca metabolizma hesabı içindir.'),
                                ('Promil (‰) Nedir?',
                                    'Promil, binde bir anlamına gelir. Kanda 1‰ alkol, her 1.000 gram kanda 1 gram alkol demektir. '
                                    'Yüzde yerine binde kullanılır çünkü kan alkol seviyeleri çok küçük miktarlarla ifade edilir.'),
                                ('Yasal Uyarı',
                                    'Bu uygulama yalnızca bilgilendirme amaçlıdır. Sunulan değerler tahminidir; gerçek kan alkol '
                                    'seviyeniz farklılık gösterebilir. Yaş, ilaç kullanımı, tokluk durumu ve genetik faktörler her '
                                    'bireyin metabolizmasını etkiler. Yasal bir karar öncesinde onaylı bir alkol ölçer kullanınız. '
                                    'Geliştirici ve uygulama, bu bilgiler doğrultusunda alınan kararlardan sorumlu tutulamaz.'),
                              ],
                              'az': [
                                ('Promilaj Nədir?',
                                    'Promilaj, Widmark düsturu ilə qan spirt səviyyənizi (BAC) hesablayan bir vasitədir. '
                                    'Ölkənizdəki qanuni limitləri göstərir və avtomobil sürə biləcəyiniz vaxtı təxmin edir.'),
                                ('Diqqət Edin',
                                    'Spirt içkisi içdikdən sonra avtomobil sürmə. Bu tətbiq alkomat cihazının əvəzini tutmur; '
                                    'yalnız təxmini hesablama təqdim edir. Əmin olmaq üçün həmişə gözləyin.'),
                                ('Məkan İcazəsi',
                                    'Ölkənizə görə qanuni spirt limitini avtomatik göstərmək üçün məkanınıza ehtiyacımız var. '
                                    'Məkan məlumatlarınız cihazınızda qalır, heç bir serverə göndərilmir.'),
                                ('Niyə Bu Məlumatları İstəyirik?',
                                    'Çəki, boy və içdiyiniz içkinin növü qan spirt səviyyənizə birbaşa təsir edir. '
                                    'Daxil etdiyiniz məlumatlar yalnız hesablama məqsədilə istifadə olunur, saxlanmır və paylaşılmır.'),
                                ('Bioloji Cins mi, Gender mi?',
                                    'Widmark düsturu bədəndəki su və yağ nisbətinə əsaslandığından bioloji cinsi (kişi/qadın) soruşur. '
                                    'Bu sual cinsiyet kimliyinizlə əlaqəli deyil; yalnız metabolizm hesabı üçündür.'),
                                ('Promil (‰) Nədir?',
                                    'Promil mində bir deməkdir. Qanda 1‰ spirt hər 1.000 qram qanda 1 qram spirt deməkdir. '
                                    'Faiz əvəzinə mində istifadə olunur, çünki qan spirt səviyyələri çox kiçik miqdarlarla ifadə edilir.'),
                                ('Hüquqi Xəbərdarlıq',
                                    'Bu tətbiq yalnız məlumat məqsədilə nəzərdə tutulmuşdur. Təqdim olunan dəyərlər təxminidir; '
                                    'real qan spirt səviyyəniz fərqli ola bilər. Yaş, dərman istifadəsi, toxluq vəziyyəti və genetik '
                                    'amillər hər fərdin metabolizminə təsir edir. Hər hansı hüquqi qərar əvvəl sertifikatlı alkomat '
                                    'istifadə edin. Proqramçı və tətbiq bu məlumatlar əsasında qəbul edilən qərarlardan məsul tutula bilməz.'),
                              ],
                              'en': [
                                ('What Is Promilaj?',
                                    'Promilaj is a tool that estimates your blood alcohol concentration (BAC) using the Widmark formula. '
                                    'It shows the legal limits for your country and estimates when you can safely drive again.'),
                                ('Please Note',
                                    'Never drive under the influence of alcohol. This app is not a substitute for a breathalyzer; '
                                    'it provides estimates only. When in doubt, always wait.'),
                                ('Location Permission',
                                    'We use your location to automatically display the legal alcohol limit for your country. '
                                    'Your location stays on your device and is never sent to any server.'),
                                ('Why Do We Ask for This Information?',
                                    'Your weight, height, and the type of drink you consumed directly affect your blood alcohol level. '
                                    'The information you enter is used solely for calculation and is never stored or shared.'),
                                ('Biological Sex vs. Gender',
                                    'The Widmark formula is based on body water and fat ratios, so it asks for your biological sex '
                                    '(male/female). This question is not about your gender identity; it is used only for metabolic calculation.'),
                                ('What Is Promille (‰)?',
                                    'Promille means per thousand. A BAC of 1‰ means 1 gram of alcohol per 1,000 grams of blood. '
                                    'Promille is used instead of percent because blood alcohol levels are expressed in very small amounts.'),
                                ('Legal Disclaimer',
                                    'This app is for informational purposes only. The values provided are estimates; your actual blood '
                                    'alcohol level may differ. Age, medication, food intake, and genetic factors affect each individual\'s '
                                    'metabolism differently. Use a certified breathalyzer before making any legal decision. The developer '
                                    'and this application cannot be held responsible for any decisions made based on this information.'),
                              ],
                            };

                            final items = sections[lang]!;

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (ctx) => DraggableScrollableSheet(
                                initialChildSize: 0.85,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                expand: false,
                                builder: (_, scrollController) => Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      Container(
                                        width: 40,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: AppColors.textSecondary.withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Expanded(
                                        child: ListView.separated(
                                          controller: scrollController,
                                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                                          itemCount: items.length,
                                          separatorBuilder: (_, __) => const SizedBox(height: 20),
                                          itemBuilder: (_, i) => Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items[i].$1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      color: AppColors.textPrimary,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.3,
                                                    ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                items[i].$2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: AppColors.textPrimary
                                                          .withOpacity(0.75),
                                                      height: 1.6,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        // Misafir profil ekleme butonu — sadece B yokken
                        if (!vm.hasGuestProfile)
                          IconButton(
                            icon: const Icon(CupertinoIcons.person_add,
                                color: AppColors.textSecondary),
                            tooltip: l10n.addGuestProfile,
                            onPressed: () => _openAddGuestProfile(vm),
                          ),
                        // Contact the builders butonu
                        IconButton(
                          icon: const Icon(CupertinoIcons.bubble_left,
                              color: AppColors.textSecondary),
                          tooltip: 'Contact the Builders',
                          onPressed: () => _showContactBuildersPopup(context),
                        ),
                        // Ayarlar butonu
                        IconButton(
                          icon: const Icon(CupertinoIcons.gear,
                              color: AppColors.textSecondary),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsView()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profil switcher — sadece B varken
              if (vm.hasGuestProfile)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ProfileSwitcherWidget(
                    activeProfileId: vm.activeProfileId,
                    hasGuestProfile: vm.hasGuestProfile,
                    onSwitch: (id) => vm.switchProfile(id),
                  ),
                ),

              // İçerik
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: SingleChildScrollView(
                    key: ValueKey(vm.activeProfileId),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // BAC Göstergesi
                        BacIndicatorWidget(
                          bac: vm.currentBac,
                          legalLimit: vm.legalLimit,
                        ),
                        const SizedBox(height: 8),

                        // Durum mesajı
                        _buildStatusMessage(vm, l10n),
                        const SizedBox(height: 24),

                        // Geri sayımlar
                        if (!vm.isSober) ...[
                          CountdownWidget(
                            label: l10n.timeToLegalLimit,
                            time: vm.isWithinLegalLimit
                                ? '✓ ${l10n.withinLegalLimit}'
                                : vm.timeToLegal,
                            icon: CupertinoIcons.car,
                            accentColor: vm.isWithinLegalLimit
                                ? AppColors.bacSafe
                                : AppColors.bacCaution,
                          ),
                          const SizedBox(height: 12),
                          CountdownWidget(
                            label: l10n.timeToZero,
                            time: vm.timeToZero,
                            icon: CupertinoIcons.clock,
                            accentColor: AppColors.accent,
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Ülke & yasal limit bilgisi
                        if (vm.countryCode != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getVehicleEmoji(vm.activeProfile?.vehicleType),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${l10n.legalLimitLabel}: ${vm.legalLimit.toStringAsFixed(2)} ‰ (${vm.countryCode})',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Eylem butonları
                        Row(
                          children: [
                            // İçki ekle
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton.icon(
                                  onPressed: () => _openAddDrink(vm),
                                  icon: const Icon(CupertinoIcons.add),
                                  label: Text(l10n.addDrink),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Sıfırla
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: GlassButton(
                                  onPressed: () => _confirmReset(vm, l10n),
                                  child: Icon(
                                    CupertinoIcons.refresh,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Yasal bilgi butonu
                        GlassButton(
                          width: double.infinity,
                          onPressed: () => _openLegalInfo(vm, l10n),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.info,
                                  color: AppColors.info, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                l10n.legalInfoButton,
                                style: const TextStyle(
                                    color: AppColors.info),
                              ),
                            ],
                          ),
                        ),

                        // Misafir profili kaldır butonu
                        if (vm.hasGuestProfile) ...[
                          const SizedBox(height: 12),
                          GlassButton(
                            width: double.infinity,
                            onPressed: () => _confirmRemoveGuest(vm, l10n),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(CupertinoIcons.person_badge_minus,
                                    color: AppColors.error, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.removeGuestProfile,
                                  style: const TextStyle(
                                      color: AppColors.error),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getVehicleEmoji(VehicleType? type) {
    if (type == null) return '🚗';
    switch (type) {
      case VehicleType.car: return '🚗';
      case VehicleType.motorcycle: return '🏍';
      case VehicleType.truckOrBus: return '🚛';
    }
  }

  Widget _buildStatusMessage(dynamic vm, AppLocalizations l10n) {
    if (vm.isSober) {
      return Text(
        l10n.soberStatus,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.bacSafe,
          fontWeight: FontWeight.w500,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _openAddDrink(dynamic vm) async {
    final entry = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddDrinkView(
        activeProfileId: vm.activeProfileId,
      ),
    );

    if (entry != null) {
      final previousCount = vm.sessionDrinkCount;
      await vm.addDrink(entry);

      // Su hatırlatıcısı
      if (mounted && vm.shouldShowWaterReminder(previousCount + 1)) {
        AppPopups.showWaterReminder(context);
      }
    }
  }

  void _openAddGuestProfile(dynamic vm) async {
    final profile = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ProfileCreationView(),
    );

    if (profile != null) {
      await vm.addGuestProfile(profile);
    }
  }

  void _showContactBuildersPopup(BuildContext context) {
    final lang = ref.read(settingsViewModelProvider).selectedLanguage;

    // Localized labels
    final labels = {
      'tr': (
        title: 'Geliştiricilerle İletişim',
        namePlaceholder: 'Ad Soyad',
        emailPlaceholder: 'E-posta',
        messagePlaceholder: 'Öneri veya şikayetiniz...',
        sendButton: 'Gönder',
        successMessage: 'Mesajınız iletildi, teşekkürler!',
        errorMessage: 'Gönderilemedi. Lütfen tekrar deneyin.',
        validationName: 'Ad soyad gerekli.',
        validationEmail: 'Geçerli bir e-posta girin.',
        validationMessage: 'Mesaj en az 15 karakter olmalı.',
      ),
      'az': (
        title: 'Tərtibatçılarla Əlaqə',
        namePlaceholder: 'Ad Soyad',
        emailPlaceholder: 'E-poçt',
        messagePlaceholder: 'Təklif və ya şikayətiniz...',
        sendButton: 'Göndər',
        successMessage: 'Mesajınız çatdırıldı, təşəkkürlər!',
        errorMessage: 'Göndərilmədi. Zəhmət olmasa yenidən cəhd edin.',
        validationName: 'Ad soyad tələb olunur.',
        validationEmail: 'Düzgün e-poçt daxil edin.',
        validationMessage: 'Mesaj ən az 15 simvol olmalıdır.',
      ),
      'en': (
        title: 'Contact the Builders',
        namePlaceholder: 'Full Name',
        emailPlaceholder: 'Email Address',
        messagePlaceholder: 'Your suggestion or complaint...',
        sendButton: 'Send',
        successMessage: 'Your message has been sent, thank you!',
        errorMessage: 'Failed to send. Please try again.',
        validationName: 'Full name is required.',
        validationEmail: 'Enter a valid email address.',
        validationMessage: 'Message must be at least 15 characters.',
      ),
    };

    final l = labels[lang] ?? labels['en']!;

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final messageController = TextEditingController();
    String? errorText;
    bool isSending = false;
    bool sent = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) => Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    l.title,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  // Full Name
                  TextField(
                    controller: nameController,
                    maxLength: 30,
                    maxLines: 1,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: l.namePlaceholder,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                      counterStyle: const TextStyle(color: AppColors.textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Email
                  TextField(
                    controller: emailController,
                    maxLength: 30,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: l.emailPlaceholder,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                      counterStyle: const TextStyle(color: AppColors.textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Message
                  TextField(
                    controller: messageController,
                    maxLength: 200,
                    maxLines: 6,
                    minLines: 6,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: l.messagePlaceholder,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.6),
                      ),
                      counterStyle: const TextStyle(color: AppColors.textSecondary),
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.accent),
                      ),
                    ),
                  ),
                  if (errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      errorText!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  if (sent) ...[
                    const SizedBox(height: 8),
                    Text(
                      l.successMessage,
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSending || sent
                          ? null
                          : () async {
                              final name = nameController.text.trim();
                              final email = emailController.text.trim();
                              final message = messageController.text.trim();

                              if (name.isEmpty) {
                                setState(() => errorText = l.validationName);
                                return;
                              }
                              if (!email.contains('@') || !email.contains('.')) {
                                setState(() => errorText = l.validationEmail);
                                return;
                              }
                              if (message.length < 15) {
                                setState(() => errorText = l.validationMessage);
                                return;
                              }

                              setState(() {
                                errorText = null;
                                isSending = true;
                              });

                              try {
                                final response = await http.post(
                                  Uri.parse(
                                    'https://api.emailjs.com/api/v1.0/email/send',
                                  ),
                                  headers: {
                                    'Content-Type': 'application/json',
                                  },
                                  body: jsonEncode({
                                    'service_id': 'service_hms2up2',
                                    'template_id': 'template_vyl17rf',
                                    'user_id': 'MWWvejw1vHdMBh5Tf',
                                    'template_params': {
                                      'from_name': name,
                                      'from_email': email,
                                      'message': message,
                                    },
                                  }),
                                );

                                if (response.statusCode == 200) {
                                  setState(() {
                                    sent = true;
                                    isSending = false;
                                  });
                                } else {
                                  setState(() {
                                    errorText = l.errorMessage;
                                    isSending = false;
                                  });
                                }
                              } catch (_) {
                                setState(() {
                                  errorText = l.errorMessage;
                                  isSending = false;
                                });
                              }
                            },
                      child: isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l.sendButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmReset(dynamic vm, AppLocalizations l10n) {
    final profileLabel = vm.activeProfileId as String;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.resetTitle),
        content: Text(
          l10n.resetConfirmFor(profileLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              vm.resetSession();
              Navigator.pop(ctx);
            },
            child: Text(l10n.reset,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _confirmRemoveGuest(dynamic vm, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.removeGuestProfile),
        content: Text(l10n.removeGuestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              vm.removeGuestProfile();
              Navigator.pop(ctx);
            },
            child: Text(l10n.reset,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _openLegalInfo(dynamic vm, AppLocalizations l10n) async {
    // Sadece izin gerçekten reddedilmişse snackbar göster
    if (vm.isLocationDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.legalInfoNoLocation)),
      );
      return;
    }

    // Ülke kodu yoksa (izin var ama konum alınamadıysa) veya haritada yoksa XX'e düş
    final url = legalInfoUrls[vm.countryCode] ?? legalInfoUrls['XX'];
    if (url != null) {
      final uri = Uri.parse(url);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch \$url');
      }
    }
  }
}
