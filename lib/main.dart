import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_shell.dart';
import 'services/database_service.dart';
import 'utils/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  FIREBASE CONFIGURATION
//
//  This app runs in LOCAL MODE by default (no Firebase required).
//  To enable full Firebase + Firestore support:
//
//  1. Install FlutterFire CLI:
//       dart pub global activate flutterfire_cli
//  2. From the project root, run:
//       flutterfire configure
//     This generates `lib/firebase_options.dart` automatically.
//  3. Uncomment the import and options line below.
//
// import 'firebase_options.dart';
//
// Then in _initFirebase(), change:
//   await Firebase.initializeApp();
// to:
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// ─────────────────────────────────────────────────────────────────────────────

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool firebaseReady = await _initFirebase();
  DatabaseService().initialize(firebaseReady: firebaseReady);

  runApp(const SafeStepsApp());
}

/// Attempt to initialize Firebase. Returns true on success, false on failure.
/// The app runs perfectly in local mode if Firebase is unavailable.
Future<bool> _initFirebase() async {
  try {
    await Firebase.initializeApp();

    // Enable Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    debugPrint('[Firebase] Initialized successfully ✅');
    return true;
  } catch (e) {
    debugPrint('[Firebase] Not configured — running in local mode. $e');
    return false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class SafeStepsApp extends StatelessWidget {
  const SafeStepsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeSteps',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}