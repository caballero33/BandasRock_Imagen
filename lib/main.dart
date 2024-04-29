import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:banda_de_rock_final/Nueva_Banda_Page.dart';
import 'package:banda_de_rock_final/firebase_options.dart';
import 'package:banda_de_rock_final/banda_de_rock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutterRock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BandasPage(),
      routes: {
        '/crear_banda': (context) => CrearBanda(),
        '/bandas': (context) => const BandasPage(),
      },
    );
  }
}
