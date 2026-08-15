import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      final dataService = DataService();
      final storageService = StorageService();
      
      // Perform background sync only. No notifications here.
      final categories = await dataService.fetchCategories();
      final all = categories.expand((c) => c.infographics).toList();
      
      if (all.isNotEmpty) {
        final newestId = all.last.id;
        await storageService.setLastSeenId(newestId);
      }
    } catch (e) {
      debugPrint("Background sync error: $e");
    }
    return Future.value(true);
  });
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase and FCM
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Subscribe to updates topic
    await FirebaseMessaging.instance.subscribeToTopic('infographica_updates');
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      if (message.notification != null) {
        NotificationService.showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? "New Infographic!",
          body: message.notification!.body ?? "Tap to explore new content.",
        );
      }
    });
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  await NotificationService.init();
  await Permission.notification.request();
  
  // Force True Full Screen / Edge-to-Edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );
  
  await Workmanager().registerPeriodicTask(
    "1",
    "syncInfographics", // Renamed to clarify purpose
    frequency: const Duration(hours: 3),
    existingWorkPolicy: ExistingWorkPolicy.keep,
    constraints: Constraints(networkType: NetworkType.connected),
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
              seedColor: const Color(0xFF673AB7),
              brightness: Brightness.light,
              surface: const Color(0xFFFBFBFF),
            ),
            scaffoldBackgroundColor: const Color(0xFFFBFBFF),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: provider.isDarkMode ? Brightness.light : Brightness.dark,
              ),
              titleTextStyle: const TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: const IconThemeData(color: Color(0xFF1A1C1E)),
            ),
            textTheme: const TextTheme(
              headlineLarge: TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: TextStyle(
                color: Color(0xFF1A1C1E),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              bodyLarge: TextStyle(color: Color(0xFF44474E), fontSize: 16),
              bodyMedium: TextStyle(color: Color(0xFF44474E), fontSize: 14),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF673AB7),
              brightness: Brightness.dark,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
            ),
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
