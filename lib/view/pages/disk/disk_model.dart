import 'dart:io';

import 'package:dbus/dbus.dart';
import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:udisks/udisks.dart';

class DiskModel extends SafeChangeNotifier {
  UDisksClient? _client;
  Map<UDisksDrive, List<UDisksBlockDevice>> _drivePartitions = {};
  Set<String> _rootUUIDs = {};

  void init(UDisksClient client) {
    client.connect().then((_) {
      _client = client;
      _buildRootSet();
      _buildMap();
      client.driveAdded.listen((_) => notifyListeners());
      client.driveRemoved.listen((_) => notifyListeners());
      client.blockDeviceAdded.listen((_) => notifyListeners());
      client.blockDeviceRemoved.listen((_) => notifyListeners());
      notifyListeners();
    });
  }

  void _buildMap() {
    if (_client == null) {
     return;
    } else {
      /*for (final drive in _client!.drives) {
        print('=== ${drive.model} ===');
        for (final b in _client!.blockDevices) {
          if (_isSameDrive(drive, b.drive)) {
            print('  label="${b.idLabel}" '
                'usage="${b.idUsage}" '
                'type="${b.idType}" '
                'ignore=${b.hintIgnore} '
                'size=${b.size}');
          }
        }
      }*/
      _drivePartitions = {
       for (final drive in _client!.drives)
         drive: _client!.blockDevices
             .where((b) =>
         _isSameDrive(drive, b.drive) &&
             b.idUsage.isNotEmpty,
         ).toList(),
      };
      for (final entry in _drivePartitions.entries) {
        print('Drive: ${entry.key.model} → ${entry.value.length} partitions');
        for (final b in entry.value) {
          print('block drive.id="${b.drive?.id}" drive.serial="${b.drive?.serial}"');
          for (final c in b.configuration) {
            print('config type=${c.type} details=${c.details}' );
          }
        }
      }
      notifyListeners();
    }
  }

  List<UDisksDrive> get drives => _client?.drives ?? [];

  Map<UDisksDrive, List<UDisksBlockDevice>> get drivePartitions => _drivePartitions;

  bool isSsd(UDisksDrive drive) => drive.rotationRate == 0;
  bool isRemovable(UDisksDrive drive) => drive.removable == true;

  String formatSize(int bytes) {
    if (bytes <= 0) return '—';
    if (bytes >= 1e12) return '${(bytes / 1e12).toStringAsFixed(1)} TB';
    if (bytes >= 1e9) return '${(bytes / 1e9).toStringAsFixed(1)} GB';
    if (bytes >= 1e6) return '${(bytes / 1e6).toStringAsFixed(1)} MB';
    return '${(bytes / 1e3).toStringAsFixed(0)} KB';
  }


  bool _isSameDrive(UDisksDrive a, UDisksDrive? b) {
    if (b == null) return false;
    if (a.id.isNotEmpty) return a.id == b.id;
    if (a.serial.isNotEmpty) return a.serial == b.serial;
    if (a.wwn.isNotEmpty) return a.wwn == b.wwn;
    return false;
  }

  bool isRootPartition(UDisksBlockDevice partition) =>
      _rootUUIDs.contains(partition.idUUID);

  void _buildRootSet() {
    try {
      final mounts = File('/proc/mounts').readAsStringSync();
      // trova i device montati su /
      final rootDevices = mounts
          .split('\n')
          .where((line) {
        final parts = line.split(' ');
        return parts.length >= 2 && parts[1] == '/';
      })
          .map((line) => line.split(' ')[0])
          .toSet();

      // mappa da device path a UUID
      _rootUUIDs = _client!.blockDevices
          .where((b) {
        final dev = String.fromCharCodes(
          b.preferredDevice.where((c) => c != 0),
        );
        return rootDevices.contains(dev);
      })
          .map((b) => b.idUUID)
          .toSet();
    } on Exception catch (_) {
      _rootUUIDs = {};
    }
  }

  String? mountPoint(UDisksBlockDevice partition) {
    final fstab = partition.configuration
        .where((c) => c.type == 'fstab')
        .firstOrNull;

    if (fstab == null) return null;

    final dir = fstab.details['dir'];
    if (dir is! DBusArray) return null;

    final bytes = dir.children
        .map((e) => (e as DBusByte).value)
        .where((b) => b != 0)
        .toList();

    return String.fromCharCodes(bytes);
  }
}
