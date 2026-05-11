import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/constants.dart';
import 'package:settings/l10n/l10n.dart';
import 'package:settings/view/common/settings_section.dart';
import 'package:settings/view/pages/power/battery_model.dart';
import 'package:settings/view/pages/power/battery_widgets.dart';
import 'package:upower/upower.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

class BatterySection extends StatefulWidget {
  const BatterySection({super.key});

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<BatteryModel>(
      create: (_) => BatteryModel(),
      child: const BatterySection(),
    );
  }

  @override
  State<BatterySection> createState() => _BatterySectionState();
}

class _BatterySectionState extends State<BatterySection> {
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
    return SettingsSection(
      width: kDefaultWidth,
      headline: Text(context.l10n.batterySectionHeadline),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: YaruLinearProgressIndicator(
            value: model.percentage / 100.0,
            color: model.percentage > 80.0
                ? theme.colorScheme.success
                : model.percentage < 30.0
                    ? theme.colorScheme.error
                    : theme.colorScheme.warning,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BatteryStateLabel(
                state: model.state,
                percentage: model.percentage,
                timeToFull: model.timeToFull,
                timeToEmpty: model.timeToEmpty,
              ),
              Text(context.l10n.batteryPercentage(model.percentage.round())),
            ],
          ),
        ),

        YaruTile(
          title: Text(context.l10n.batteryEnergy),
          trailing: Text(
            '${model.energyWh.toStringAsFixed(1)} Wh',
            style: theme.textTheme.bodyMedium,
          ),
        ),

        YaruTile(
          title: Text(context.l10n.batteryEnergyFull),
          trailing: Text(
            '${model.energyFullWh.toStringAsFixed(1)} Wh',
            style: theme.textTheme.bodyMedium,
          ),
        ),

        YaruTile(
          title: Text(context.l10n.batteryEnergyFullDesign),
          trailing: Text(
            '${model.energyFullDesignWh.toStringAsFixed(1)} Wh',
            style: theme.textTheme.bodyMedium,
          ),
        ),

        // Health battery
        YaruTile(
          title: Text(context.l10n.batteryCapacity),
          trailing: Text(
            '${model.capacity.toStringAsFixed(1)} %',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: switch(model.capacity) {
                < 40.0 => theme.colorScheme.error,
                >= 40.0 && < 80.0 => theme.colorScheme.warning,
                >= 80.0 => theme.colorScheme.success,
                _ => theme.colorScheme.error
              },
            ),
          ),
        ),

        // Voltage
        YaruTile(
          title: Text(context.l10n.batteryVoltage),
          trailing: Text(
            '${model.voltage.toStringAsFixed(1)} V',
            style: theme.textTheme.bodyMedium,
          ),
        ),

        // Temperature
        if (model.temperature > 0.0)
          YaruTile(
            title: Text(context.l10n.batteryTemperature),
            trailing: Text(
              '${model.temperature.toStringAsFixed(1)} °C',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: switch(model.capacity) {
                < 40.0 => theme.colorScheme.error,
                >= 40.0 && < 80.0 => theme.colorScheme.warning,
                >= 80.0 => theme.colorScheme.success,
                _ => theme.colorScheme.error
                },
              ),
            ),
          ),

        // Instant consume
        if (model.energyRate > 0)
          YaruTile(
            title: Text(context.l10n.batteryInstantConsume),
            trailing: Text(
              '${model.energyRate.toStringAsFixed(2)} W',
              style: theme.textTheme.bodyMedium,
            ),
          ),

        // Producer
        if (model.vendor.isNotEmpty)
          YaruTile(
            title: Text(context.l10n.batteryVendor),
            trailing: Text(
              model.vendor,
              style: theme.textTheme.bodyMedium,
            ),
          ),

        if (model.model.isNotEmpty)
          YaruTile(
            title: Text(context.l10n.batteryModel),
            trailing: Text(
              model.model,
              style: theme.textTheme.bodyMedium,
            ),
          ),

      ],
    );
  }
}
