import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(String) onItemSelected;

  const SideMenu({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DrawerListTile(
              title: "Advertisements",
              leadingIcon: Icon(Icons.campaign, color: Colors.white54),
              press: () => onItemSelected('/myadds'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DrawerListTile(
              title: "myAcademy",
              leadingIcon: Icon(Icons.school, color: Colors.white54),
              press: () => onItemSelected('/myacademy'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DrawerListTile(
              title: "Trips",
              leadingIcon: Icon(Icons.airplane_ticket, color: Colors.white54),
              press: () => onItemSelected('/mytrips'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DrawerListTile(
              title: "myclubs",
              leadingIcon: Icon(Icons.sports_soccer, color: Colors.white54),
              press: () => onItemSelected('/myclubs'),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.leadingIcon,
    required this.press,
  }) : super(key: key);

  final String title;
  final Icon leadingIcon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: leadingIcon, 
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
