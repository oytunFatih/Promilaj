import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:promilaj/core/constants/constants.dart';
import 'package:promilaj/core/providers.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/core/theme/widgets/glass_card.dart';
import 'package:promilaj/data/models/drink_entry.dart';
import 'package:promilaj/data/models/drink_type.dart';
import 'package:promilaj/data/models/drink_brand.dart';
import 'package:promilaj/l10n/app_localizations.dart';

/// İçki ekleme bottom sheet — 4 adımlı akış.
class AddDrinkView extends ConsumerStatefulWidget {
  final String activeProfileId;

  const AddDrinkView({
    super.key,
    this.activeProfileId = 'A',
  });

  @override
  ConsumerState<AddDrinkView> createState() => _AddDrinkViewState();
}

class _AddDrinkViewState extends ConsumerState<AddDrinkView> {
  final _volumeController = TextEditingController(text: '250');
  final _hoursController = TextEditingController(text: '0');
  final _searchController = TextEditingController();
  final _manualAbvController = TextEditingController();
  bool _isManualAbvMode = false;

  @override
  void dispose() {
    _volumeController.dispose();
    _hoursController.dispose();
    _searchController.dispose();
    _manualAbvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(addDrinkViewModelProvider);
    final l10n = AppLocalizations.of(context);
    
    if (l10n == null) return const SizedBox.shrink();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Tutma çubuğu
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.glassBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Başlık
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (vm.currentStep > 0)
                        IconButton(
                          icon: const Icon(CupertinoIcons.back),
                          onPressed: () {
                            if (_isManualAbvMode && vm.currentStep == 1) {
                              setState(() => _isManualAbvMode = false);
                            } else {
                              vm.goBack();
                              if (vm.currentStep == 0) {
                                _searchController.clear();
                              }
                            }
                          },
                        )
                      else
                        const SizedBox(width: 48),
                      Text(
                        _getStepTitle(vm.currentStep, l10n),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.xmark),
                        onPressed: () {
                          vm.reset();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.glassBorder, height: 1),
                // Aktif profil attribution
                if (widget.activeProfileId.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    color: AppColors.accent.withAlpha(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.person,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text(
                          l10n.addingFor(widget.activeProfileId),
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                // İçerik
                Expanded(child: _buildStepContent(vm, l10n, scrollController)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getStepTitle(int step, AppLocalizations l10n) {
    switch (step) {
      case 0:
        return l10n.selectDrinkType;
      case 1:
        return l10n.selectBrand;
      case 2:
        return l10n.amountAndTime;
      default:
        return '';
    }
  }

  Widget _buildStepContent(
    dynamic vm,
    AppLocalizations l10n,
    ScrollController scrollController,
  ) {
    switch (vm.currentStep) {
      case 0:
        return _buildTypeSelector(vm, l10n, scrollController);
      case 1:
        return _buildBrandSelector(vm, l10n, scrollController);
      case 2:
        return _buildAmountTimeInput(vm, l10n);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Adım 1 — İçki türü seçimi
  Widget _buildTypeSelector(
    dynamic vm,
    AppLocalizations l10n,
    ScrollController scrollController,
  ) {
    final grouped = vm.groupedTypes as Map<DrinkCategory, List<DrinkType>>;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _categoryName(entry.key, l10n),
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entry.value.map((type) {
                return ActionChip(
                  label: Text(_typeName(type, l10n)),
                  backgroundColor: AppColors.glassWhite,
                  side: const BorderSide(color: AppColors.glassBorder),
                  labelStyle: const TextStyle(color: AppColors.textPrimary),
                  onPressed: () {
                    final isOther = _typeName(type, l10n) == l10n.otherBrand;
                    if (isOther) {
                      vm.selectType(type);
                      setState(() => _isManualAbvMode = true);
                    } else if (entry.key == DrinkCategory.cocktails) {
                      vm.selectType(type);
                      Future.microtask(() {
                        if (vm.filteredBrands.isNotEmpty) {
                          vm.selectBrand(vm.filteredBrands.first);
                        }
                      });
                    } else {
                      vm.selectType(type);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  /// Adım 2 — Marka seçimi (aranabilir) VEYA Manuel ABV
  Widget _buildBrandSelector(
    dynamic vm,
    AppLocalizations l10n,
    ScrollController scrollController,
  ) {
    if (_isManualAbvMode) {
      final valStr = _manualAbvController.text.replaceAll(',', '.');
      final val = double.tryParse(valStr) ?? 0.0;
      final isValid = val >= 0.1 && val <= 96.0;

      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.manualAbvLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _manualAbvController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [HoursInputFormatter()],
              style: const TextStyle(color: AppColors.textPrimary),
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                suffixText: '%',
                errorText: _manualAbvController.text.isNotEmpty && !isValid
                    ? l10n.manualAbvError
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: isValid
                    ? () {
                        final customBrand = DrinkBrand(
                          name: l10n.otherBrand,
                          type: vm.selectedType,
                          abv: val,
                        );
                        vm.selectBrand(customBrand);
                      }
                    : null,
                child: Text('OK'),
              ),
            ),
          ],
        ),
      );
    }

    final brands = vm.filteredBrands as List<DrinkBrand>;

    return Column(
      children: [
        // Arama alanı
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.searchBrands,
              prefixIcon: const Icon(CupertinoIcons.search),
            ),
            onChanged: (v) => vm.setSearchQuery(v),
          ),
        ),
        // Marka listesi
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length + 1,
            itemBuilder: (context, index) {
              if (index == brands.length) {
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.otherBrand,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(CupertinoIcons.chevron_right, color: AppColors.accent),
                    onTap: () => setState(() => _isManualAbvMode = true),
                  ),
                );
              }

              final brand = brands[index];
              return GlassCard(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    brand.name,
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${brand.abv}%',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => vm.selectBrand(brand),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Adım 3 — Miktar ve zaman girişi + onay
  Widget _buildAmountTimeInput(dynamic vm, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Seçilen içki bilgisi
          if (vm.selectedBrand != null)
            GlassCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.drop, color: AppColors.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${vm.selectedBrand!.name} (${vm.selectedBrand!.abv}%)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Miktar (mL)
          Text(
            l10n.amountLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _volumeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(suffixText: 'ml'),
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null) vm.setVolume(val);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: vm.volumeMl.clamp(kMinVolumeMl, kMaxVolumeMl),
                  min: kMinVolumeMl,
                  max: kMaxVolumeMl,
                  divisions: ((kMaxVolumeMl - kMinVolumeMl) / kVolumeStepMl)
                      .round(),
                  label: '${vm.volumeMl.round()} ml',
                  onChanged: (v) {
                    vm.setVolume(v);
                    _volumeController.text = v.round().toString();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Kaç saat önce
          Text(
            l10n.hoursAgoLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _hoursController,
                  inputFormatters: [HoursInputFormatter()],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(suffixText: l10n.hours),
                  onChanged: (v) {
                    final val = double.tryParse(v);
                    if (val != null) {
                      // v0.1.5: Mantıksal değer ham ondalık kalır (hassas hesaplama için)
                      // Slider görseli _getSliderIndex() içinde otomatik mıknatıslanır.
                      vm.setHoursAgo(val.clamp(0.0, 12.0));
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _getSliderIndex(vm.hoursAgo),
                  min: 0,
                  max: (kTimeSteps.length - 1).toDouble(),
                  divisions: kTimeSteps.length - 1,
                  label: _formatSliderLabel(vm.hoursAgo),
                  onChanged: (v) {
                    // Slider -> VM & TextField: Raw decimal
                    final hours = kTimeSteps[v.round()];
                    vm.setHoursAgo(hours);
                    _hoursController.text = hours.toString();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Onayla butonu
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: vm.isReadyToConfirm ? () => _confirm(vm) : null,
              child: Text(l10n.addButton),
            ),
          ),
        ],
      ),
    );
  }

  void _confirm(dynamic vm) {
    final now = DateTime.now();
    final consumedAt = now.subtract(
      Duration(minutes: (vm.hoursAgo * 60).round()),
    );

    final isManual = vm.selectedBrand!.name == AppLocalizations.of(context)!.otherBrand;

    final entry = DrinkEntry(
      id: now.millisecondsSinceEpoch.toString(),
      brandName: vm.selectedBrand!.name,
      drinkType: vm.selectedType!,
      abv: vm.selectedBrand!.abv,
      volumeMl: vm.volumeMl,
      consumedAt: consumedAt,
      addedAt: now,
      isManualAbv: isManual,
    );

    vm.reset();
    setState(() {
      _isManualAbvMode = false;
      _manualAbvController.clear();
    });
    Navigator.pop(context, entry);
  }

  String _categoryName(DrinkCategory cat, AppLocalizations l10n) {
    switch (cat) {
      case DrinkCategory.beer:
        return l10n.categoryBeer;
      case DrinkCategory.wine:
        return l10n.categoryWine;
      case DrinkCategory.spirits:
        return l10n.categorySpirits;
      case DrinkCategory.cocktails:
        return l10n.categoryCocktails;
    }
  }

  String _typeName(DrinkType type, AppLocalizations l10n) {
    switch (type) {
      case DrinkType.lager:
        return l10n.typeLager;
      case DrinkType.pilsner:
        return l10n.typePilsner;
      case DrinkType.ale:
        return l10n.typeAle;
      case DrinkType.stout:
        return l10n.typeStout;
      case DrinkType.wheatBeer:
        return l10n.typeWheatBeer;
      case DrinkType.ipa:
        return l10n.otherBrand;
      case DrinkType.redWine:
        return l10n.typeRedWine;
      case DrinkType.whiteWine:
        return l10n.typeWhiteWine;
      case DrinkType.rose:
        return l10n.typeRose;
      case DrinkType.sparklingWine:
        return l10n.typeSparklingWine;
      case DrinkType.champagne:
        return l10n.typeChampagne;
      case DrinkType.prosecco:
        return l10n.otherBrand;
      case DrinkType.vodka:
        return l10n.typeVodka;
      case DrinkType.whisky:
        return l10n.typeWhisky;
      case DrinkType.rum:
        return l10n.typeRum;
      case DrinkType.gin:
        return l10n.typeGin;
      case DrinkType.tequila:
        return l10n.typeTequila;
      case DrinkType.brandy:
        return l10n.typeBrandy;
      case DrinkType.raki:
        return l10n.typeRaki;
      case DrinkType.ouzo:
        return l10n.otherBrand;
      case DrinkType.mojito:
        return 'Mojito';
      case DrinkType.margarita:
        return 'Margarita';
      case DrinkType.cosmopolitan:
        return 'Cosmopolitan';
      case DrinkType.negroni:
        return 'Negroni';
      case DrinkType.oldFashioned:
        return 'Old Fashioned';
      case DrinkType.aperolSpritz:
        return 'Aperol Spritz';
      case DrinkType.pinaColada:
        return 'Piña Colada';
      case DrinkType.longIslandIcedTea:
        return 'Long Island Iced Tea';
      case DrinkType.daiquiri:
        return 'Daiquiri';
      case DrinkType.espressoMartini:
        return 'Espresso Martini';
      case DrinkType.bloodyMary:
        return 'Bloody Mary';
      case DrinkType.sexOnTheBeach:
        return 'Sex on the Beach';
      case DrinkType.moscowMule:
        return l10n.otherBrand;
    }
  }

  // ── Yardımcı Metotlar (v0.1.5) ──

  double _snapToStep(double input) {
    return kTimeSteps.reduce(
      (a, b) => (input - a).abs() < (input - b).abs() ? a : b,
    );
  }

  double _getSliderIndex(double hours) {
    final snapped = _snapToStep(hours);
    final index = kTimeSteps.indexOf(snapped);
    return index >= 0 ? index.toDouble() : 0.0;
  }

  String _formatSliderLabel(double hours) {
    if (hours == 0.0) return '0 min';
    if (hours < 1.0) return '${(hours * 60).round()} min';
    if (hours % 1 == 0) return '${hours.toInt()} h';
    final wholeHours = hours.floor();
    final minutes = ((hours - wholeHours) * 60).round();
    return '${wholeHours} h $minutes min';
  }
}

/// v0.1.5: Kaç saat önce metin alanı kısıtlamaları
class HoursInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Virgülü nokta ile değiştir
    final sanitised = newValue.text.replaceAll(',', '.');

    // Sadece rakamlar ve tek bir nokta
    final isValid = RegExp(r"^\d*\.?\d*$").hasMatch(sanitised);

    if (!isValid) return oldValue;
    return newValue.copyWith(text: sanitised);
  }
}
