import 'package:flutter/material.dart';
import 'package:promilaj/core/theme/app_colors.dart';
import 'package:promilaj/data/models/session_profile.dart';
import 'package:promilaj/l10n/app_localizations.dart';

class VehiclePicker extends StatelessWidget {
  final VehicleType selectedVehicle;
  final ValueChanged<VehicleType> onChanged;

  const VehiclePicker({
    super.key,
    required this.selectedVehicle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _VehicleOption(
            label: l10n.vehicleMotorcycle,
            emoji: '🏍',
            isSelected: selectedVehicle == VehicleType.motorcycle,
            onTap: () => onChanged(VehicleType.motorcycle),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _VehicleOption(
            label: l10n.vehicleCar,
            emoji: '🚗',
            isSelected: selectedVehicle == VehicleType.car,
            onTap: () => onChanged(VehicleType.car),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _VehicleOption(
            label: l10n.vehicleTruckOrBus,
            emoji: '🚛',
            isSelected: selectedVehicle == VehicleType.truckOrBus,
            onTap: () => onChanged(VehicleType.truckOrBus),
          ),
        ),
      ],
    );
  }
}

class _VehicleOption extends StatelessWidget {
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleOption({
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
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
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
