import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings/l10n/l10n.dart';
import 'package:settings/view/pages/accessibility/accessibility_page.dart';
import 'package:settings/view/pages/accounts/accounts_page.dart';
import 'package:settings/view/pages/appearance/appearance_page.dart';
import 'package:settings/view/pages/apps/apps_page.dart';
import 'package:settings/view/pages/bluetooth/bluetooth_page.dart';
import 'package:settings/view/pages/color/color_page.dart';
import 'package:settings/view/pages/connections/connections_page.dart';
import 'package:settings/view/pages/date_and_time/date_time_page.dart';
import 'package:settings/view/pages/default_apps/default_apps_page.dart';
import 'package:settings/view/pages/disk/disk_page.dart';
import 'package:settings/view/pages/displays/displays_page.dart';
import 'package:settings/view/pages/info/info_page.dart';
import 'package:settings/view/pages/keyboard/keyboard_page.dart';
import 'package:settings/view/pages/mouse_and_touchpad/mouse_and_touchpad_page.dart';
import 'package:settings/view/pages/multitasking/multi_tasking_page.dart';
import 'package:settings/view/pages/notifications/notifications_page.dart';
import 'package:settings/view/pages/online_accounts/online_accounts_page.dart';
import 'package:settings/view/pages/power/power_page.dart';
import 'package:settings/view/pages/privacy/privacy_page.dart';
import 'package:settings/view/pages/region_and_language/region_and_language_page.dart';
import 'package:settings/view/pages/removable_media/removable_media_page.dart';
import 'package:settings/view/pages/search/search_page.dart';
import 'package:settings/view/pages/settings_page_item.dart';
import 'package:settings/view/pages/sound/sound_page.dart';
import 'package:settings/view/pages/wallpaper/wallpaper_page.dart';
import 'package:yaru/yaru.dart';

List<SettingsPageItem> getPageItems(BuildContext context) => [
      SettingsPageItem(
        sectionTitle: context.l10n.sectionConnectivity,
        titleBuilder: ConnectionsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.network),
        builder: ConnectionsPage.create,
        searchMatches: ConnectionsPage.searchMatches,
        title: context.l10n.connectionsPageTitle,
        hasAppBar: false,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionConnectivity,
        titleBuilder: BluetoothPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.bluetooth),
        builder: BluetoothPage.create,
        searchMatches: BluetoothPage.searchMatches,
        title: context.l10n.bluetoothPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionLook,
        titleBuilder: WallpaperPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.wallpaper),
        builder: WallpaperPage.create,
        searchMatches: WallpaperPage.searchMatches,
        title: context.l10n.wallpaperPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionLook,
        titleBuilder: AppearancePage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.panel_look),
        builder: AppearancePage.create,
        searchMatches: AppearancePage.searchMatches,
        title: context.l10n.appearancePageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionLook,
        titleBuilder: DisplaysPage.createTitle,
        iconBuilder: (context, selected) =>
            const Icon(YaruIcons.display_layout),
        builder: DisplaysPage.create,
        searchMatches: DisplaysPage.searchMatches,
        title: context.l10n.displaysPageTitle,
        hasAppBar: false,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionLook,
        titleBuilder: ColorPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.colors),
        builder: ColorPage.create,
        searchMatches: ColorPage.searchMatches,
        title: context.l10n.displaysColorTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionPrivacy,
        titleBuilder: PrivacyPage.createTitle,
        builder: PrivacyPage.create,
        searchMatches: PrivacyPage.searchMatches,
        iconBuilder: (context, selected) => const Icon(YaruIcons.lock),
        title: context.l10n.privacyPageTitle,
        hasAppBar: false,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionPrivacy,
        titleBuilder: NotificationsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.bell),
        builder: NotificationsPage.create,
        searchMatches: NotificationsPage.searchMatches,
        title: context.l10n.notificationsPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionPrivacy,
        titleBuilder: SearchPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.search),
        builder: SearchPage.create,
        searchMatches: SearchPage.searchMatches,
        title: context.l10n.searchPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionSystem,
        titleBuilder: SoundPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.music_note),
        builder: SoundPage.create,
        searchMatches: SoundPage.searchMatches,
        title: context.l10n.soundPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionSystem,
        titleBuilder: PowerPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.power),
        builder: PowerPage.create,
        searchMatches: PowerPage.searchMatches,
        title: context.l10n.powerPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionSystem,
        titleBuilder: DiskPage.createTitle,
        iconBuilder: (context, selected) =>
            const Icon(YaruIcons.drive_harddisk),
        builder: DiskPage.create,
        //searchMatches: RemovableMediaPage.searchMatches,
        title: context.l10n.diskPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionSystem,
        titleBuilder: MultiTaskingPage.createTitle,
        builder: MultiTaskingPage.create,
        iconBuilder: (context, selected) => const Icon(YaruIcons.windows),
        searchMatches: MultiTaskingPage.searchMatches,
        title: context.l10n.multiTaskingPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionHardware,
        titleBuilder: MouseAndTouchpadPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.mouse),
        builder: MouseAndTouchpadPage.create,
        searchMatches: MouseAndTouchpadPage.searchMatches,
        title: context.l10n.mouseAndTouchPadPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionHardware,
        titleBuilder: KeyboardPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.keyboard),
        builder: KeyboardPage.create,
        searchMatches: KeyboardPage.searchMatches,
        title: context.l10n.keyboardPageTitle,
        hasAppBar: false,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionHardware,
        titleBuilder: (context) => const Text('Printers'),
        iconBuilder: (context, selected) => const Icon(YaruIcons.printer),
        builder: (_) => const Center(child: Text('Printers')),
        title: context.l10n.printersPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionHardware,
        titleBuilder: RemovableMediaPage.createTitle,
        iconBuilder: (context, selected) =>
            const Icon(YaruIcons.drive_removable_media),
        builder: RemovableMediaPage.create,
        searchMatches: RemovableMediaPage.searchMatches,
        title: context.l10n.removableMediaPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: AppsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.app_grid),
        builder: AppsPage.create,
        searchMatches: AppsPage.searchMatches,
        title: context.l10n.appsPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: OnlineAccountsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.cloud),
        builder: OnlineAccountsPage.create,
        searchMatches: OnlineAccountsPage.searchMatches,
        title: context.l10n.onlineAccountsPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: RegionAndLanguagePage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.localization),
        builder: RegionAndLanguagePage.create,
        searchMatches: RegionAndLanguagePage.searchMatches,
        title: context.l10n.regionAndLanguagePageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: AccessibilityPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.human),
        builder: AccessibilityPage.create,
        searchMatches: AccessibilityPage.searchMatches,
        title: context.l10n.accessibilityPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: AccountsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.users),
        builder: AccountsPage.create,
        searchMatches: AccountsPage.searchMatches,
        title: context.l10n.usersPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionUser,
        titleBuilder: DefaultAppsPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.star),
        builder: DefaultAppsPage.create,
        searchMatches: DefaultAppsPage.searchMatches,
        title: context.l10n.defaultAppsPageTitle,
      ),
      SettingsPageItem(
        sectionTitle: context.l10n.sectionInfo,
        titleBuilder: DateTimePage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.clock),
        builder: DateTimePage.create,
        searchMatches: DateTimePage.searchMatches,
        title: context.l10n.dateAndTimePageTitle,
      ),
      SettingsPageItem(
        titleBuilder: InfoPage.createTitle,
        iconBuilder: (context, selected) => const Icon(YaruIcons.information),
        builder: InfoPage.create,
        searchMatches: InfoPage.searchMatches,
        title: context.l10n.infoPageTitle,
      ),
    ];
