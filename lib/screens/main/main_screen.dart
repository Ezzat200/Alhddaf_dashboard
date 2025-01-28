import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haddaf_ashboard/controllers/menu_app_controller.dart';
import 'package:haddaf_ashboard/responsive.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_clubs.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_trips.dart';
import 'package:haddaf_ashboard/screens/dashboard/dashboard_screen.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/my_adds.dart';
import 'package:haddaf_ashboard/screens/main/components/my_academy.dart';
import 'package:haddaf_ashboard/screens/main/components/addclub.dart';
import 'package:haddaf_ashboard/screens/main/components/club.dart';
import 'package:haddaf_ashboard/screens/main/components/addtrips.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: SideMenu(
        onItemSelected: (route) {
          _navigatorKey.currentState?.pushReplacementNamed(route);
          Navigator.of(context).pop(); // إغلاق القائمة الجانبية بعد الاختيار
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(
                  onItemSelected: (route) {
                    _navigatorKey.currentState?.pushReplacementNamed(route);
                  },
                ),
              ),
            Expanded(
              flex: 5,
              child: Navigator(
                key: _navigatorKey,
                initialRoute: '/myadds',
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case '/myadds':
                      return MaterialPageRoute(builder: (context) => MyAdds());
                    case '/mytrips':
                      return MaterialPageRoute(builder: (context) => MyTrips());
                      case '/myacademy':
                      return MaterialPageRoute(builder: (context) => MyAcademy());
                      case '/myclubs':
                      return MaterialPageRoute(builder: (context) => MyClubs());
                      case '/addclup':
                      return MaterialPageRoute(builder: (context) => AddClubScreen());
                    default:
                      return MaterialPageRoute(builder: (context) => DashboardScreen());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
