import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promilaj/core/providers.dart';
import 'package:promilaj/core/theme/liquid_glass_theme.dart';
import 'package:promilaj/core/utils/migration_service.dart';
import 'package:promilaj/features/onboarding/onboarding_view.dart';
import 'package:promilaj/features/onboarding/first_launch_info_view.dart';
import 'package:promilaj/features/home/home_view.dart';
import 'package:promilaj/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // v1.0.2 Migrasyon — mevcut veriyi çoklu profil formatına çevir
  await MigrationService.runIfNeeded(prefs);

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const PromilajApp(),
    ),
  );
}

class PromilajApp extends ConsumerStatefulWidget {
  const PromilajApp({super.key});

  @override
  ConsumerState<PromilajApp> createState() => _PromilajAppState();
}

class _PromilajAppState extends ConsumerState<PromilajApp> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    // Replaced synchronous start with Future.microtask
    _initFuture = _initialize();
  }

  Future<void> _initialize() async {
    // Profil ve ayarları yükle (özellikle selectedLanguage için)
    // SettingsViewModel.initialize() artık başlangıçta gereksiz notifyListeners() çağırmıyor.
    await ref.read(settingsViewModelProvider).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsViewModelProvider);
    final userRepo = ref.read(userProfileRepositoryProvider);

    return MaterialApp(
      title: 'Promilaj',
      debugShowCheckedModeBanner: false,
      theme: LiquidGlassTheme.darkTheme,
      // Localization setup
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('tr'),
        Locale('az'),
      ],
      locale: settings.selectedLocale,
      home: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return FutureBuilder<bool>(
            future: userRepo.hasProfile(),
            builder: (context, profileSnapshot) {
              if (profileSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (profileSnapshot.data == true) {
                return const HomeView();
              } else {
                final prefs = ref.read(sharedPreferencesProvider);
                final bool infoScreenShown =
                    prefs.getBool('info_screen_shown') ?? false;
                if (!infoScreenShown) {
                  return const FirstLaunchInfoView();
                }
                return const OnboardingView();
              }
            },
          );
        },
      ),
    );
  }
}
