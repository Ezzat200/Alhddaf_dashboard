import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:haddaf_ashboard/screens/add_screen.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/header.dart';
import 'package:haddaf_ashboard/screens/main/components/add_academy.dart';

class MyAcademy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Academies",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAcademy()),
                    );
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Academy"),
                ),
              ],
            ),
            SizedBox(height: 16.0),
          Expanded(
  child: FutureBuilder<QuerySnapshot>(
    future: FirebaseFirestore.instance
        .collection('acadmy')
        
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No academies found'));
      }

      final academies = snapshot.data!.docs;

      return ListView.builder(
        itemCount: academies.length,
        itemBuilder: (context, index) {
          final academy = academies[index].data() as Map<String, dynamic>;
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: academy['image'] ?? '',
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.image_not_supported),
            ),
            title: Text(academy['nameArabic'] ?? 'No Name'),
            subtitle: Text(academy['locationArabic'] ?? 'No Location'),
          );
        },
      );
    },
  ),
)

          
          ],
        ),
      ),
    );
  }
}
