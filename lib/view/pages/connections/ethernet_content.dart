import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/constants.dart';
import 'package:settings/view/pages/settings_page.dart';
import 'package:yaru/yaru.dart';

import '../../../l10n/l10n.dart';
import '../../common/settings_section.dart';
import 'models/ethernet_model.dart';

class EthernetDevicesContent extends StatelessWidget {
  const EthernetDevicesContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ethernetModel = context.watch<EthernetModel>();

    if (ethernetModel.hasEthernetDevice) {
      return SettingsPage(
        children: [
          for (final device in ethernetModel.ethernetDevices)
            AnimatedBuilder(
              animation: device,
              builder: (_, __) => SettingsSection(
                width: kDefaultWidth,
                headline: Text(
                  device.connectionName.isNotEmpty ? device.connectionName : context.l10n.ethernetSectionHeadline,
                ),
                children: [
                  YaruTile(
                    leading : Icon(
                      device.isConnected ? YaruIcons.network_wired : YaruIcons.network_wired_filled,
                      color: device.isConnected ? Theme.of(context).colorScheme.success : Theme.of(context).colorScheme.error,
                    ),
                    title: Text(context.l10n.ethernetStatus),
                    trailing: Text(
                      device.isConnected ? context.l10n.connected : context.l10n.disconnected,
                      style: TextStyle(
                        color: device.isConnected
                            ? Theme.of(context).colorScheme.success
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),

                  if (device.ipv4Addresses.isNotEmpty)
                    YaruTile(
                      title: Text(context.l10n.ethernetIpv4),
                      trailing: Text(device.ipv4Addresses.join(', ')),
                    ),

                  if (device.gateway.isNotEmpty)
                    YaruTile(
                      title: Text(context.l10n.ethernetGateway),
                      trailing: Text(device.gateway),
                    ),
                  if (device.dnsServers.isNotEmpty)
                    YaruTile(
                      title: Text(context.l10n.ethernetDns),
                      trailing: Text(device.dnsServers.join(', ')),
                    ),
                  if (device.speed > 0)
                    YaruTile(
                      title: Text(context.l10n.ethernetSpeed),
                      trailing: Text('${device.speed} Mb/s'),
                    ),
                  YaruTile(
                    title: Text(context.l10n.ethernetMac),
                    trailing: Text(device.macAddress),
                  ),
                ],
              ),
            ),
        ],
      );
    } else {
      return const EthernetAdapterNotFound();
    }
  }
}

class EthernetAdapterNotFound extends StatelessWidget {
  const EthernetAdapterNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const FractionallySizedBox(
          widthFactor: .5,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Icon(YaruIcons.network_cellular_no_route),
          ),
        ),
        Text(
          context.l10n.ethernetNotFound,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
