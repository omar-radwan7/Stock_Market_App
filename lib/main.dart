import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/screens/home/home_screen.dart';
import 'app/screens/portfolio/portfolio_screen.dart';
import 'app/screens/news/news_screen.dart';
import 'app/screens/stocks/tree_map.dart';
import 'app/screens/profile/profile.dart';
import 'app/screens/premium/premium.dart';
import 'app/providers/news_provider.dart';
import 'app/providers/portfolio_provider.dart';
import 'app/providers/stock_provider.dart';
import 'auth/sign_in_page.dart';
import 'auth/sign_up_page.dart';
import 'auth/auth_service.dart';
import 'app/providers/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
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
      title: 'Stock Market App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF4C336F),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4C336F),
          secondary: Color(0xFF3DE85F),
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1531),
        primaryColor: const Color(0xFF4C336F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4C336F),
          secondary: Color(0xFF3DE85F),
          background: Color(0xFF0D1531),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      themeMode: themeProvider.themeMode,
      home: const SignInPage(),
      routes: {
        '/home': (context) => const MainNavigation(),
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/profile': (context) => Profilepage(),
        '/premium': (context) => Premiumpage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building AuthenticationWrapper...");
    return FutureBuilder<bool>(
      future: AuthService().isSignedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print("Auth FutureBuilder state: ${snapshot.connectionState}");
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print("Auth FutureBuilder error: ${snapshot.error}");
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }

          final bool isSignedIn = snapshot.data ?? false;
          print("Is user signed in? $isSignedIn");

          if (isSignedIn) {
            print("Redirecting to MainNavigation (Home)...");
            return const MainNavigation();
          } else {
            print("Redirecting to SignInPage...");
            return const SignInPage();
          }
        } else {
          // While waiting for the future to complete, show a loading indicator.
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Homepage(),
    const PortfolioScreen(),
    NewsPage(),
    const TreeMapScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            _screens[_selectedIndex],
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.article), label: 'News'),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Market',
            ),
          ],
        ),
      ),
    );
  }
}
