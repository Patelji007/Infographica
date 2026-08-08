import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Switch between light and dark themes"),
            secondary: const Icon(Icons.brightness_6),
            value: provider.isDarkMode,
            onChanged: (val) => provider.toggleTheme(),
          ),
          const Divider(),
          ListTile(
            title: const Text("About Infographica"),
            subtitle: const Text("Version 1.0.0"),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Infographica",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2026 Infographica Team",
                applicationIcon: const FlutterLogo(size: 40),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text("Infographica is an educational platform to explore high-quality infographics across various science and tech fields."),
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: const Text("Feedback"),
            leading: const Icon(Icons.feedback_outlined),
            onTap: () {
              // Would normally open email or a form
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thank you for your interest! Feedback system coming soon.")));
            },
          ),
          ListTile(
            title: const Text("Developer"),
            subtitle: const Text("Lead Flutter Developer"),
            leading: const Icon(Icons.code),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
