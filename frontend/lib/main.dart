import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawsome/pages/login_signup/login_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode, // Apply global dark mode
      home: LoginPage(),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _saveTheme(isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> _saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }
}

final ThemeData lightThemeData = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
  ),
);

final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.amber,
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey),
  ),
);
