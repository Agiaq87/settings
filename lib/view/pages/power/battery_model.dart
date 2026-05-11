import 'package:safe_change_notifier/safe_change_notifier.dart';
import 'package:upower/upower.dart';

export 'package:settings/services/power_profile_service.dart' show PowerProfile;

class BatteryModel extends SafeChangeNotifier {
  UPowerClient? _client;

  void init(UPowerClient client) {
    client.connect().then((_) {
      _client = client;
      client.deviceAdded.listen((_) => notifyListeners());
      client.deviceRemoved.listen((_) => notifyListeners());
      notifyListeners();
    });
  }

  UPowerDevice? get _device => _client?.displayDevice;
  UPowerDevice? get _batteryDevice => _client?.devices.where(
      (d) => d.type == UPowerDeviceType.battery && d.isPresent,
  ).firstOrNull;

  UPowerDeviceState? get state => _device?.state;

  double get percentage => _device?.percentage ?? 0;

  int get timeToEmpty => _device?.timeToEmpty ?? 0;

  int get timeToFull => _device?.timeToFull ?? 0;

  double get capacity => _batteryDevice?.capacity ?? 0;

  double get temperature => _batteryDevice?.temperature ?? 0;

  double get energyRate => _batteryDevice?.energyRate ?? 0;

  double get energyWh => _batteryDevice?.energy ?? 0.0;

  double get energyFullWh => _batteryDevice?.energyFull ?? 0;

  double get energyFullDesignWh => _batteryDevice?.energyFullDesign ?? 0;

  double get voltage => _batteryDevice?.voltage ?? 0;

  double get healthPercentage => energyFullDesignWh > 0
      ? (energyFullWh / energyFullDesignWh * 100).clamp(0, 100)
      : 0;

  List<UPowerDevice> get peripheralDevices =>
      _client?.devices
          .where((d) =>
              d.type != UPowerDeviceType.battery &&
              d.type != UPowerDeviceType.unknown &&
              d.percentage > 0,)
          .toList() ??
      [];

  String get vendor => _device?.vendor ?? '';

  String get model => _device?.model ?? '';
}
