import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings/l10n/l10n.dart';
import 'package:udisks/udisks.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import 'disk_card.dart';
import 'disk_model.dart';

class DiskPage extends StatefulWidget {
  const DiskPage({super.key});

  static Widget createTitle(BuildContext context) =>
      Text(context.l10n.diskPageTitle);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<DiskModel>(
      create: (_) => DiskModel(),
      child: const DiskPage(),
    );
  }

  @override
  State<DiskPage> createState() => _DiskPageState();
}

class _DiskPageState extends State<DiskPage>{

  @override
  void initState() {
    super.initState();
    context.read<DiskModel>().init(di<UDisksClient>());
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DiskModel>();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(kYaruPagePadding),
          child: Column(
            children: <Widget>[
              for (final entry in model.drivePartitions.entries.toList()..sort((a,b) => a.key.removable ? 1 : -1))
                DiskCard(
                  drive: entry.key,
                  partitions: entry.value,
                  model: model,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
