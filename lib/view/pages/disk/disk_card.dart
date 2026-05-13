import 'package:flutter/material.dart';
import 'package:udisks/udisks.dart';
import 'package:yaru/icons.dart';
import 'package:yaru/widgets.dart';

import '../../../l10n/l10n.dart';
import 'disk_model.dart';

class DiskCard extends StatelessWidget {
  const DiskCard({
    super.key,
    required this.drive,
    required this.partitions,
    required this.model,
});

  final UDisksDrive drive;
  final List<UDisksBlockDevice> partitions;
  final DiskModel model;

  IconData _partitionIcon(String idType, bool isRootPartition) => switch (idType) {
    'vfat'            => YaruIcons.drive_harddisk_usb,
    'ext4' || 'ext3'  => isRootPartition ? YaruIcons.ubuntu_logo_simple : YaruIcons.drive_harddisk,
    'swap'            => YaruIcons.refresh,
    'ntfs'            => YaruIcons.windows,
    _                 => YaruIcons.drive_harddisk,
  };

  YaruInfoType _partitionInfoType(String idType) => switch (idType) {
    'swap'            => YaruInfoType.warning,
    'vfat'            => YaruInfoType.important,
    'ext4' || 'ext3'  => YaruInfoType.success,
    _                 => YaruInfoType.information,
  };

  @override
  Widget build(BuildContext context) =>
      YaruBorderContainer(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    drive.removable
                        ? YaruIcons.usb_stick
                        : model.isSsd(drive)
                        ? YaruIcons.drive_solidstatedisk
                        : YaruIcons.drive_harddisk,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${drive.vendor} ${drive.model}'.trim(),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        Text(
                          '${model.formatSize(drive.size)}'
                              ' · S/N: ${drive.serial}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  YaruInfoBadge(
                    yaruInfoType: drive.removable
                        ? YaruInfoType.warning
                        : model.isSsd(drive)
                        ? YaruInfoType.success
                        : YaruInfoType.information,
                    title: Text(
                      drive.removable
                          ? 'USB'
                          : model.isSsd(drive)
                          ? 'SSD'
                          : 'HDD',
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MetaColumn(
                      label: context.l10n.diskCapacity,
                      value: model.formatSize(drive.size),
                    ),
                  ),
                  Expanded(
                    child: _MetaColumn(
                      label: context.l10n.diskType,
                      value: drive.removable
                          ? context.l10n.diskRemovable
                          : model.isSsd(drive)
                          ? 'SSD'
                          : '${drive.rotationRate} RPM',
                    ),
                  ),
                  Expanded(
                    child: _MetaColumn(
                      label: context.l10n.diskVendor,
                      value: drive.vendor.isEmpty
                          ? '—'
                          : drive.vendor,
                    ),
                  ),
                  Expanded(
                    child: _MetaColumn(
                      label: context.l10n.diskRevision,
                      value: drive.revision.isEmpty
                          ? '—'
                          : drive.revision,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            YaruSection(
              headline: Text(context.l10n.diskPartitions),
              child: Column(
                children: [
                  for (final partition in partitions)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            _partitionIcon(partition.idType, model.isRootPartition(partition)),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      partition.idLabel.isNotEmpty
                                          ? partition.idLabel
                                          : partition.idType,
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      model.formatSize(partition.size),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                YaruLinearProgressIndicator(
                                  value: drive.size > 0
                                      ? partition.size / drive.size
                                      : 0,
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: [
                                    if (partition.idType.isNotEmpty)
                                      YaruInfoBadge(
                                        yaruInfoType: _partitionInfoType(
                                          partition.idType,
                                        ),
                                        title: Text(partition.idType),
                                      ),
                                    if (partition.idLabel.isNotEmpty)
                                      YaruInfoBadge(
                                        yaruInfoType: YaruInfoType.information,
                                        title: Text(partition.idLabel),
                                      ),
                                    if (partition.idUUID.isNotEmpty)
                                      YaruInfoBadge(
                                        yaruInfoType: YaruInfoType.information,
                                        title: Text(
                                          partition.idUUID.substring(0, 8),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _MetaColumn extends StatelessWidget {
  const _MetaColumn({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
