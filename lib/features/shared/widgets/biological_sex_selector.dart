import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/data/models/user_profile.dart';
import 'package:promilaj/l10n/app_localizations.dart';

class BiologicalSexSelector extends StatelessWidget {
  final BiologicalSex selectedSex;
  final ValueChanged<BiologicalSex> onChanged;

  const BiologicalSexSelector({
    super.key,
    required this.selectedSex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    // Size the widgets responsively based on available horizontal width.
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // Calculate item width based on available space minus wrap spacing
        // If there isn't enough space (e.g. < 200px), they will stack vertically.
        double? itemWidth;
        if (availableWidth != double.infinity && availableWidth > 200) {
          itemWidth = (availableWidth - 12) / 2;
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildOption(
              label: l10n.male,
              icon: CupertinoIcons.person,
              value: BiologicalSex.male,
              itemWidth: itemWidth,
            ),
            _buildOption(
              label: l10n.female,
              icon: CupertinoIcons.person,
              value: BiologicalSex.female,
              itemWidth: itemWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildOption({
    required String label,
    required IconData icon,
    required BiologicalSex value,
    required double? itemWidth,
  }) {
    final isSelected = selectedSex == value;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: itemWidth,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withAlpha(30)
              : AppColors.glassSubtle,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
