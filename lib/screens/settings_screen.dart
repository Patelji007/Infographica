import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Customize your experience.",
                    style: TextStyle(color: Color(0xFF74777F), fontSize: 16),
                  ),
                ],
              ),
            ),
            
            _buildSettingsGroup(
              "Appearance",
              [
                SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: const Text("Dark Mode", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Switch between light and dark themes"),
                  secondary: const Icon(Icons.brightness_6_rounded, color: Color(0xFF673AB7)),
                  value: provider.isDarkMode,
                  onChanged: (val) => provider.toggleTheme(),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildSettingsGroup(
              "General",
              [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: const Text("About / Developer", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Meet the creator of Infographica"),
                  leading: const Icon(Icons.person_outline_rounded, color: Color(0xFF673AB7)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    );
                  },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: const Text("App Information", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Infographica v1.0.0+1"),
                  leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF673AB7)),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "Infographica",
                      applicationVersion: "1.0.0+1",
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: const Text("Feedback", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Help us improve your experience"),
                  leading: const Icon(Icons.feedback_outlined, color: Color(0xFF673AB7)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thank you for your interest! Feedback system coming soon."))
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 120), // Bottom spacing for nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF673AB7),
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}
