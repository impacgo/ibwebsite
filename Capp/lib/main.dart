// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:hive_flutter/adapters.dart';
// import 'package:ironingboy/Screens/bottomnavigationbar.dart';
// import 'package:ironingboy/Screens/cartextra.dart';
// import 'package:ironingboy/Screens/cartitem.dart';
// import 'package:ironingboy/Screens/loginpage.dart';
// import 'package:ironingboy/cartpage.dart';
// import 'package:ironingboy/firebase_options.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Stripe.publishableKey =
//       'pk_test_51S3E4YCaf76ntwTVeWFgmkQ36JR8AiiKCchLX9yrB9svrJzLbmC6ZrOgDWRY8rtpXnjxLMpYp7n466LPUuHWr71u00ZqU89aAn';
//       await Stripe.instance.applySettings();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await Hive.initFlutter();
//   try {
//     if (!Hive.isAdapterRegistered(0)) {
//       Hive.registerAdapter(CartExtraAdapter());
//     }
//     if (!Hive.isAdapterRegistered(1)) {
//       Hive.registerAdapter(CartItemAdapter());
//     }
//     await Hive.openBox<CartExtra>('cartExtraBox');
//     await Hive.openBox<CartItem>('cartBox');
//   } catch (e) {
//     debugPrint("Hive init failed: $e");
//   }  
//   runApp(
//     MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => CartBloc()),
//         BlocProvider(create: (_) => CartExtraBloc()),
//       ],
//       child:  MyApp(),
//     ),
//   );
// }
// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   Future<bool?> getLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getBool("isLoggedIn");
//   }
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool?>(
//       future: getLoginStatus(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const MaterialApp(
//             home: Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             ),
//           );
//         }
//         bool? isLoggedIn = snapshot.data;
//         return MaterialApp(
//            navigatorKey: navigatorKey,
//           debugShowCheckedModeBanner: false,
//           theme: ThemeData(
//             colorScheme: ColorScheme.fromSeed(
//               seedColor: Colors.white12,
//             ),
//             fontFamily: 'Poppins',
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             hoverColor: Colors.transparent,
//             textSelectionTheme: const TextSelectionThemeData(
//               cursorColor: Colors.black,
//               selectionColor: Colors.black,
//               selectionHandleColor: Colors.black,
//             ),
//           ),
//           home: isLoggedIn == true ? const MainScreen() : const Loginpage(),
//         );
//       },
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ironingboy/Screens/bottomnavigationbar.dart';
import 'package:ironingboy/Screens/cartextra.dart';
import 'package:ironingboy/Screens/cartitem.dart';
import 'package:ironingboy/cartpage.dart';
import 'package:ironingboy/firebase_options.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Stripe.publishableKey =
       'pk_test_51S3E4YCaf76ntwTVeWFgmkQ36JR8AiiKCchLX9yrB9svrJzLbmC6ZrOgDWRY8rtpXnjxLMpYp7n466LPUuHWr71u00ZqU89aAn';
       await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  try {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CartExtraAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CartItemAdapter());
    }
    await Hive.openBox<CartExtra>('cartExtraBox');
    await Hive.openBox<CartItem>('cartBox');
  } catch (e) {
    debugPrint("Hive init failed: $e");
  }
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
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
      home: const MainScreen(),
    );
  }
}
