import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ironingboy/Screens/bottomnavigationbar.dart';
import 'package:ironingboy/Screens/cartextra.dart';
import 'package:ironingboy/Screens/cartitem.dart';
import 'package:ironingboy/Screens/checkoutpage.dart';
import 'package:ironingboy/Screens/confirmorder.dart';
import 'package:ironingboy/Screens/loginpage.dart';
import 'package:ironingboy/Screens/signuppage.dart';
import 'package:ironingboy/Screens/widgets/ChatScreen.dart';
import 'package:ironingboy/Screens/widgets/Orderscreen.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:ironingboy/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

 
  await Hive.initFlutter();
  

  Hive.registerAdapter(CartExtraAdapter());
await Hive.openBox<CartExtra>('cartExtraBox');
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cartBox');
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CartBloc()),
         BlocProvider(create: (_) => CartExtraBloc()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  MyApp({super.key});

  Future<bool?> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn");
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
      future: getLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        bool? isLoggedIn = snapshot.data;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white12,
            ),
            fontFamily: 'Poppins',
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Colors.black,
              selectionColor: Colors.black,
              selectionHandleColor: Colors.black,
            ),
          ),
          home: isLoggedIn == true ? const MainScreen() : const Loginpage(),
        );
      },
    );
  }
}
