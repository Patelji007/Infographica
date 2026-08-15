import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 24, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Developer",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "The person behind the screen.",
                      style: TextStyle(color: Color(0xFF74777F), fontSize: 16),
                    ),
                  ],
                ),
              ),
              
              // Developer Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "❤️",
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Made with love by",
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "PRIYANSHU PATEL",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Color(0xFF1A1C1E),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    Text(
                      "\"Built with curiosity, creativity, and a love for learning.\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // About Section
              const Text(
                "ABOUT INFOGRAPHICA",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF74777F),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Infographica is designed to make complex concepts easier to understand through beautiful, detailed and educational infographics.",
                style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFF44474E)),
              ),
              const SizedBox(height: 16),
              Text(
                "Learn. Explore. Understand.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // App Information Card
              const Text(
                "APP INFORMATION",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF74777F),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(context, "Version", "1.0.0+1"),
                    const Divider(height: 32),
                    _buildInfoRow(context, "Made with", "Flutter"),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Bottom Message
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Made with ❤️ by Priyanshu Patel",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF74777F),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Thank you for learning with Infographica.",
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF74777F).withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF44474E),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1C1E),
          ),
        ),
      ],
    );
  }
}
