import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haddaf_ashboard/screens/add_screen.dart';
import 'package:haddaf_ashboard/screens/dashboard/components/header.dart';
import 'package:haddaf_ashboard/screens/dashboard/view_model/cubit.dart';

class MyAdds extends StatelessWidget {
   MyAdds({Key? key}) : super(key: key);

  final List<String> _collections = [
    'academyAds',
    'testReservationBannerAds',
    'testReservationSliderAds',
    'playerMarketAds',
    'coachBannerAds',
    'coachSliderAds',
    'clubAds',
    'tripAds',
    'homeFirstSlider',
    'homeSecondSlider',
    'homeThirdSlider',
    'playerMarketAdsBanner',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PortofolioCubit()..getAllDataPortofolio(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Header(),
             SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Ads",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddAdScreen(),
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text("New Ad"),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ..._collections.map((collection) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        collection,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(collection)
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
          
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
          
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                              child: Text('No ads found in $collection'));
                        }
          
                        final ads = snapshot.data!.docs;
                        for (var ad in ads) {
                          log('Ad data: ${ad.data()}');
                        }
          
                        return GridView.builder(
                          shrinkWrap: true,
                          physics:  NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.2
                          ),
                          itemCount: ads.length,
                          itemBuilder: (context, index) {
                            final ad = ads[index].data() as Map<String, dynamic>;
          
                            return SizedBox(
                              child: Card(
                                margin: EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Section
                                    SizedBox(
                                      height: 150,
                                      child: ad['imageUrl'] != null
                                          ? Image.network(
                                              ad['imageUrl'],
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                print(
                                                    'Error loading image: $error');
                                                return Icon(Icons.broken_image,
                                                    size: 100);
                                              },
                                            )
                                          : Icon(Icons.image_not_supported,
                                              size: 100),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ad['title'] ?? 'No Title',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            ad['status'] ?? 'No Status',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
