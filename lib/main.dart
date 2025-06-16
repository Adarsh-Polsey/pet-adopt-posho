import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_adopt_posha/feature/home/view/home_screen.dart';
import 'package:pet_adopt_posha/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// TODO
// Writing tests
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(ProviderScope(child: const PetApp()));
}

class PetApp extends ConsumerWidget {
  const PetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: MyTheme.lightThemeMode,
      darkTheme: MyTheme.darkThemeMode,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
