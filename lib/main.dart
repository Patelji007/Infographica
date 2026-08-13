import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'providers/app_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'services/notification_service.dart';
import 'services/data_service.dart';
import 'services/storage_service.dart';
import 'package:permission_handler/permission_handler.dart';
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize notifications in the background process
      await NotificationService.init();
      
      final dataService = DataService();
      final storageService = StorageService();
      
      // Fetch latest from GitHub
      final categories = await dataService.fetchCategories();
      final all = categories.expand((c) => c.infographics).toList();
      
      if (all.isNotEmpty) {
        final newestId = all.last.id;
        final lastSeenId = await storageService.getLastSeenId();

        // If lastSeenId is null, it's the first time running.
        // We set the current newest as "seen" to avoid notifying for the entire library.
        if (lastSeenId == null) {
          await storageService.setLastSeenId(newestId);
          return Future.value(true);
        }

        if (lastSeenId != newestId) {
          await NotificationService.showNotification(
            id: 99,
            title: "New Infographic Uploaded!",
            body: "Check out: ${all.last.title}",
          );
          await storageService.setLastSeenId(newestId);
        }
      }
    } catch (e) {
      debugPrint("Background task error: $e");
    }
    return Future.value(true);
  });
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await NotificationService.init();
  
  // Request notification permission for Android 13+
  await Permission.notification.request();
  
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  
  // Register a periodic task (runs every 3 hours)
  await Workmanager().registerPeriodicTask(
    "1",
    "checkNewInfographics",
    frequency: const Duration(hours: 3),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const InfographicaApp(),
    ),
  );
}

class InfographicaApp extends StatelessWidget {
  const InfographicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Infographica',
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              centerTitle: true,
              elevation: 0,
            ),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
