import 'package:exif2/screens/tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request permissions for gallery & storage
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,  // For devices below Android 10
    Permission.photos,   // For Android 13+
  ].request();

  // Check if permissions are granted
  if (statuses[Permission.storage]!.isGranted ||
      statuses[Permission.photos]!.isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
  }
}

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestPermissions(); 
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark, seedColor: Colors.purple),
      ),
      home: const TabScreen(),
    );
  }
}
