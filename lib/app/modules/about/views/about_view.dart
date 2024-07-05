import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutController>(
      init: AboutController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('О приложении'),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/icon.png'),
                        radius: MediaQuery.of(context).size.width / 4,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NNTU Map',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Неофициальная интерактивная карта аудиторий НГТУ им. Р.Е.Алексеева',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Полезные ссылки'),
                    ListTile(
                      leading: Icon(Icons.launch_outlined),
                      title: Text('Группа приложения ВК'),
                      onTap: () {
                        launchUrlString(
                          'https://vk.com/nntu_apps',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.launch_outlined),
                      title: Text('Группа приложения Telegram'),
                      onTap: () {
                        launchUrlString(
                          'https://t.me/+hmtX4v-M6Uw3Njhi',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.file_open_outlined),
                      title: Text('Политика конфиденциальности'),
                      onTap: () {
                        launchUrlString(
                          'https://vvadev.ru/files/privacy_policy_nntu_map.html',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people_outline),
                      title: Text('Разработчик'),
                      onTap: () {
                        launchUrlString(
                          'https://vk.com/vvadev',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  child: Text(
                    "Версия: ${controller.packageInfo.version} (${controller.packageInfo.buildNumber})",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
