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
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: AppColors.surface,
                                title: Text(l10n.infoButtonTitle),
                                content: Text(l10n.infoPlaceholderText),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text(l10n.infoCloseButton),
                                  ),
                                ],
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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Contact the Builders'),
        content: const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
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
