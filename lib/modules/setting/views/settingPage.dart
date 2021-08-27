import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '/util/lang/translation_service.dart';
import '/util/constants/locale_keys.dart';
import '/modules/common/commons.dart';
import '/modules/modules.dart';
import '/models/models.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _selectedLang = TranslationService.languageCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings.tr),
      ),
      body: _buildLayoutSection(context),
    );
  }

  Widget _buildLayoutSection(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      children: <Widget>[
        languageListTile(context),
        themeListTile(context),
      ],
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems() {
    var list = <DropdownMenuItem<String>>[];
    TranslationService.langs.forEach((key, value) {
      list.add(DropdownMenuItem<String>(
        value: key,
        child: Text(value),
      ));
    });
    return list;
  }

  // * Đổi ngôn ngữ
  languageListTile(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text(
            'language'.tr,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down),
            value: _selectedLang,
            items: _buildDropdownMenuItems(),
            onChanged: (String? newValue) {
              setState(() => _selectedLang = newValue.toString());
              TranslationService.changeLocale(newValue.toString());
            },
          ),
        ),
      ],
    );
  }

  // * Đổi chủ đề System | Light | Dark
  themeListTile(BuildContext context) {
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(
          key: "system", value: 'system'.tr, icon: Icons.brightness_4),
      MenuOptionsModel(
          key: "light", value: 'light'.tr, icon: Icons.brightness_low),
      MenuOptionsModel(key: "dark", value: 'dark'.tr, icon: Icons.brightness_3)
    ];
    return GetBuilder<ThemeController>(
      builder: (controller) => Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text('theme'.tr, style: TextStyle(fontSize: 16.0)),
          ),
          Expanded(
            flex: 3,
            child: SegmentedSelector(
              selectedOption: controller.currentTheme,
              menuOptions: themeOptions,
              onValueChanged: (value) {
                controller.setThemeMode(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
