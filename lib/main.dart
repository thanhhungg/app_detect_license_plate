import 'package:flutter/material.dart';
import 'application.dart';
import 'getIt.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  runApp(const Application());
}
