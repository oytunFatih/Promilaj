import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promilaj/core/providers.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/core/theme/widgets/glass_card.dart';
import 'package:promilaj/data/models/user_profile.dart';
import 'package:promilaj/features/shared/widgets/language_picker_list.dart';
import 'package:promilaj/features/shared/widgets/country_picker_list.dart';
import 'package:promilaj/features/shared/widgets/vehicle_picker.dart';
import 'package:promilaj/features/shared/widgets/biological_sex_selector.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/l10n/app_localizations.dart';

/// Ayarlar ekranı — profil düzenleme ve dil seçimi.
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  BiologicalSex? _draftSex;
  VehicleType? _draftVehicleType;
  String? _draftLanguage;
  String? _draftCountryCode;
  bool? _draftShowBacCounter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = ref.read(settingsViewModelProvider);
      await vm.initialize();
      if (vm.profile != null) {
        _heightController.text = vm.profile!.heightCm.round().toString();
        _weightController.text = vm.profile!.weightKg.round().toString();
        _ageController.text = vm.profile!.age.toString();

        setState(() {
          _draftSex = vm.profile?.sex ?? BiologicalSex.male;
          _draftVehicleType = vm.profile?.vehicleType ?? VehicleType.car;
          _draftLanguage = vm.selectedLanguage;
          _draftCountryCode = vm.selectedCountryCode;
          _draftShowBacCounter = vm.showBacCounter;
        });
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(settingsViewModelProvider);
    final l10n = AppLocalizations.of(context);

    if (vm.isLoading || l10n == null) {
      return const Scaffold(
        backgroundColor: AppColors.midnight,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // drafts are local — no cleanup needed, just allow pop
      },
      child: Scaffold(
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
              // Üst bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(l10n.settings,
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              if (vm.isLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Profil bölümü
                        Text(l10n.profileSection,
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(height: 12),
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildField(l10n.heightLabel, _heightController,
                                  'cm'),
                              const SizedBox(height: 12),
                              _buildField(l10n.weightLabel, _weightController,
                                  'kg'),
                              const SizedBox(height: 12),
                              _buildField(
                                  l10n.ageLabel, _ageController, ''),
                              const SizedBox(height: 12),
                              // Cinsiyet
                              Text(l10n.sexLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium),
                              const SizedBox(height: 12),
                              BiologicalSexSelector(
                                selectedSex: _draftSex ?? vm.profile?.sex ?? BiologicalSex.male,
                                onChanged: (val) => setState(() => _draftSex = val),
                              ),
                              const SizedBox(height: 24),
                              Text(l10n.vehicleTypeSectionLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium),
                              const SizedBox(height: 12),
                              VehiclePicker(
                                selectedVehicle: _draftVehicleType ?? vm.profile?.vehicleType ?? VehicleType.car,
                                onChanged: (type) => setState(() => _draftVehicleType = type),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Kaydet butonu
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: vm.isSaving ? null : _saveProfile,
                            child: vm.isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : Text(l10n.save),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Dil bölümü
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.languageLabel,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              LanguagePickerList(
                                selectedLanguage: _draftLanguage ?? vm.selectedLanguage,
                                onLanguageSelected: (langCode) => setState(() => _draftLanguage = langCode),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Ülke bölümü
                        GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.countryLabel,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 12),
                              CountryPickerList(
                                selectedCountryCode: _draftCountryCode ?? vm.selectedCountryCode,
                                onCountrySelected: (code) => setState(() => _draftCountryCode = code),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SwitchListTile(
                            value: _draftShowBacCounter ?? vm.showBacCounter,
                            onChanged: (val) => setState(() => _draftShowBacCounter = val),
                            title: Text(_counterLabel(vm.selectedLanguage)),
                            subtitle: Text(_counterSubLabel(vm.selectedLanguage)),
                            activeColor: AppColors.accent,
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
    ));
  }

  Widget _buildField(
      String label, TextEditingController controller, String suffix) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
      ),
    );
  }


  String _counterLabel(String lang) {
    if (lang == 'tr') return 'Sayacı Göster';
    if (lang == 'az') return 'Sayğacı Göstər';
    return 'Show Counter';
  }

  String _counterSubLabel(String lang) {
    if (lang == 'tr') return 'Kapalıyken sayaç arka planda çalışmaya devam eder';
    if (lang == 'az') return 'Söndürüldükdə sayğac arxa planda işləməyə davam edir';
    return 'Counter keeps running in the background when off';
  }

  Future<void> _saveProfile() async {
    final vm = ref.read(settingsViewModelProvider);
    final h = double.tryParse(_heightController.text);
    final w = double.tryParse(_weightController.text);
    final a = int.tryParse(_ageController.text);
    
    await vm.updateProfile(
      heightCm: h,
      weightKg: w,
      age: a,
      sex: _draftSex,
      vehicleType: _draftVehicleType,
    );

    if (_draftLanguage != null) {
      await vm.setLanguage(_draftLanguage!);
    }
    if (_draftCountryCode != null) {
      await vm.setCountryCode(_draftCountryCode);
    }
    if (_draftShowBacCounter != null) {
      await vm.setShowBacCounter(_draftShowBacCounter!);
    }

    ref.read(homeViewModelProvider).refreshActiveProfile();

    if (mounted) Navigator.pop(context);
  }
}
