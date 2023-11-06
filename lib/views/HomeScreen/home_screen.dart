import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/views/ProductByCategory/product_by_categorys.dart';
import 'package:firebase_ecommerce_app/views/ProductDetails/product_details.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fireStore = FirebaseFirestore.instance;

  List firebaseSlider = [];

  Future<void> getSliders() async {
    fireStore.collection('banners').get().then((value) {
      firebaseSlider = value.docs;
    });
  }

  /*
  List<Map<String, dynamic>> products = [
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'price' : '40',
    },
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name' : 'Apple Watch - 6',
    },
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name' : 'Casino Watch',
      'price' : '80',
    },
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name' : 'Redmi Note 4',
      'price' : '40',
    },
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name' : 'Apple Watch - 6',
      'price' : '100',
    },
    {
      'image' : 'https://i.ibb.co/8BntMyD/6-44mm-blu-889c7c8b-e883-41ab-856c-38c9dd970d12-1200x-removebg-preview-2.png',
      'name' : 'Casino Watch',
      'price' : '80',
    },
  ];

  // Create products folder in firebase and add products info.
  Future addProducts() async {
    for(var product in products) {
      fireStore.collection('products').add(products as Map<String, dynamic>);
    }
  }
  */

  @override
  void initState() {
    super.initState();

    getSliders();

    //addProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        isLeading: const Icon(Icons.menu),
        action: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search))
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greetings
              const Text(
                'Hello Mehedi  🖐️',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              Text(
                "Let's start shopping!",
                style: TextStyle(color: Colors.black.withOpacity(.5)),
              ),
              firebaseSlider.isEmpty ? const Center(child: CircularProgressIndicator()) : Container(
                height: 150,
                margin: const EdgeInsets.only(top: 20, bottom: 15),
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: firebaseSlider.length,
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(firebaseSlider[index]['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.easeInOut,
                    enlargeCenterPage: true,
                  ),
                ),
              ),
              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Categories',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              StreamBuilder(
                stream: fireStore.collection('categories').snapshots(),
                builder: (_, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox(
                      height: 62,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductByCategorys(category: snapshot.data!.docs[index],)));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF2F2F2),
                                border: Border.all(color: const Color(0xFFD8D3D3))
                              ),
                              child: Center(
                                child: Image.network(
                                  snapshot.data!.docs[index]['icon'],
                                  width: 40,
                                  color: Colors.black.withOpacity(.7),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
              ),
              // Recent Product
              const SizedBox(height: 15),
              const Text(
                'Recent Products',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
              const SizedBox(height: 15),
              StreamBuilder(
                stream: fireStore.collection('products').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        childAspectRatio: .8
                      ),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: data)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(data['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_border,
                                          color: Colors.black.withOpacity(.5),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? 'Comming soon',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '\$${data['price'] ?? 'Up Comming'}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}