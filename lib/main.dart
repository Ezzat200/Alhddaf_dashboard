import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haddaf_ashboard/constants.dart';
import 'package:haddaf_ashboard/controllers/menu_app_controller.dart';
import 'package:haddaf_ashboard/screens/add_screen.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_adds.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_clubs.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_trips.dart';

import 'package:haddaf_ashboard/screens/dashboard/view_model/cubit.dart';
import 'package:haddaf_ashboard/screens/main/components/add_academy.dart';
import 'package:haddaf_ashboard/screens/main/components/my_academy.dart';
import 'package:haddaf_ashboard/screens/main/components/addclub.dart';
import 'package:haddaf_ashboard/screens/main/components/club.dart';
import 'package:haddaf_ashboard/screens/main/components/addtrips.dart';
import 'package:haddaf_ashboard/screens/main/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the correct configuration
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD9M5jZioAQRugLDKRnIL9DOvuplAZjl2A",
      appId: "1:730829734986:web:d41a5576a3c69dcda452b3",
      messagingSenderId: "730829734986",
      projectId: "alhadaf-a3fa2",
      storageBucket: "alhadaf-a3fa2.appspot.com",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        BlocProvider(
          create: (context) => PortofolioCubit(),
        ),
      ],
      child: MaterialApp(
  title: 'Elhddaf Dashboard',
  debugShowCheckedModeBanner: false,
  theme: ThemeData.dark().copyWith(
    scaffoldBackgroundColor: bgColor,
    textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
        .apply(bodyColor: Colors.white),
    canvasColor: secondaryColor,
  ),
  home: MainScreen(), // Set the home property
  routes: {
    // '/dashboard': (context) => DashboardScreen(),
    '/addscreen':(context)=>AddAdScreen(),
    // '/myfieles':(context)=>MyAdds(),
    '/myclubs':(context)=>MyClubs(),
    '/addclup':(context)=>AddClubScreen(),
    '/addAcademy':(context)=>AddAcademy(),
    '/myadds':(context)=>MyAdds(),
    '/mytrips':(context)=>MyTrips(),
    '/myacademy':(context)=>MyAcademy()
  },
));

  }
}
