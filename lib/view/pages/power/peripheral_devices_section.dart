import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/view/common/settings_section.dart';
import 'package:settings/view/pages/power/battery_model.dart';
import 'package:upower/upower.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../../constants.dart';
import '../../../l10n/l10n.dart';

class PeripheralDevicesSection extends StatefulWidget {
  const PeripheralDevicesSection({super.key});

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<BatteryModel>(
      create: (_) => BatteryModel(),
      child: const PeripheralDevicesSection(),
    );
  }

  @override
  State<PeripheralDevicesSection> createState() => _PeripheralDevicesSectionState();
}

class _PeripheralDevicesSectionState extends State<PeripheralDevicesSection> {
  @override
  void initState() {
    super.initState();

    final model = context.read<BatteryModel>();
    model.init(di<UPowerClient>());
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = context.watch<BatteryModel>();
    final devices = model.peripheralDevices;

    return SettingsSection(
      width: kDefaultWidth,
      headline: Text(context.l10n.peripheralDevicesHeadline),
      children: devices.map(
          (device) {
            final color = switch(device.percentage) {
              >= 60.0 => theme.colorScheme.success,
              >= 30 && <60 => theme.colorScheme.warning,
              <30 => theme.colorScheme.error,
              _ => theme.colorScheme.primary
            };

            return YaruTile(
              leading: Icon(_deviceIcon(device.type)),
              title: Text(
                device.model.isNotEmpty ? device.model : _deviceTypeName(context, device.type),
              ),
              subtitle: LinearProgressIndicator(
                value: device.percentage / 100.0,
                color: color,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              trailing: Text(
                '${device.percentage.round()} %',
                style: theme.textTheme.bodyMedium?.copyWith(color: color),
              ),
            );
          }).toList(),
      );
  }


  IconData _deviceIcon(UPowerDeviceType type) {
    return switch (type) {
      UPowerDeviceType.mouse => YaruIcons.mouse,
      UPowerDeviceType.keyboard => YaruIcons.keyboard,
      UPowerDeviceType.phone => YaruIcons.phone,
      /*UPowerDeviceType.headset => YaruIcons.headphones,
      UPowerDeviceType.headphones => YaruIcons.headphones,
      UPowerDeviceType.touchpad => YaruIcons.input_touchpad,*/
      _ => YaruIcons.battery,
    };
  }

  String _deviceTypeName(BuildContext context, UPowerDeviceType type) {
    return switch (type) {
      UPowerDeviceType.mouse => context.l10n.peripheralMouse,
      UPowerDeviceType.keyboard => context.l10n.peripheralKeyboard,
      UPowerDeviceType.phone => context.l10n.peripheralPhone,
      /*UPowerDeviceType.headset => context.l10n.peripheralHeadset,
      UPowerDeviceType.headphones => context.l10n.peripheralHeadphones,
      UPowerDeviceType.touchpad => context.l10n.peripheralTouchpad,*/
      _ => context.l10n.peripheralUnknown,
    };
  }
}
