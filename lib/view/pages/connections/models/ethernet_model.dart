import 'package:nm/nm.dart';
import 'package:settings/view/pages/connections/models/property_stream_notifier.dart';

class EthernetDeviceModel extends PropertyStreamNotifier{

  EthernetDeviceModel(this._device) {
    addProperties(_device.propertiesChanged);
    addPropertyListener('State', notifyListeners);
    addPropertyListener('ActiveConnection', notifyListeners);
    addPropertyListener('Ip4Config', notifyListeners);
  }

  final NetworkManagerDevice _device;

  bool get isConnected => _device.state == NetworkManagerDeviceState.activated;

  String get macAddress => _device.wired?.permHwAddress ?? '';

  int get speed => _device.wired?.speed ?? 0;

  String get connectionName => _device.activeConnection?.id ?? '';

  List<String> get ipv4Addresses =>
      _device.ip4Config?.addressData
          .map((a) => '${a['address']}/${a['prefix']}')
          .toList() ??
          [];

  List<String> get dnsServers =>
      _device.ip4Config?.nameserverData
          .map((d) => d['address']?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList() ??
          [];

  String get gateway => _device.ip4Config?.gateway ?? '';
}

class EthernetModel extends PropertyStreamNotifier {
  EthernetModel(this._client) {
    addProperties(_client.propertiesChanged);
    addPropertyListener('Devices', notifyListeners);
  }

  final NetworkManagerClient _client;

  List<EthernetDeviceModel> get ethernetDevices => _client.devices
      .where((d) => d.wired != null)
      .map(EthernetDeviceModel.new)
      .toList();

  bool get hasEthernetDevice => ethernetDevices.isNotEmpty;
}
