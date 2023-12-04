import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_button.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/utils/colors.dart';
import 'package:firebase_ecommerce_app/views/PaymentGetwayScreen/payment_screen.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final user = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot> cartItems = [];
  double totalAmount = 0.0;

  double calculateAmount(List<QueryDocumentSnapshot> cartData) {
    double allAmount = 0.0;

    for(var data in cartData) {
      double price = double.parse(data['price']);
      int quantity = data['quantity'];

      allAmount += price * quantity;
    }

    return allAmount;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').doc(user!.email).collection('cart').snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          cartItems = snapshot.data!.docs;
          double amount = calculateAmount(cartItems);
          totalAmount = amount;
          
          return Scaffold(
            appBar: customAppBar(
              context: context,
              title: 'My Cart'
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEBEB),
                      borderRadius: BorderRadius.circular(16)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Center(
                              child: Image.network(
                                data['image']
                              )
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(.6)
                                ),
                              ),
                              Text(
                                '\$${data['price']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              data['variant'] != 'null' ? Text(
                                'Size : ${data['variant']}',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(.5)
                                ),
                              ) : const SizedBox(),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if(data['quantity'] > 1) {
                                              FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.email)
                                              .collection('cart')
                                              .doc(data.id)
                                              .update({
                                                'quantity': data['quantity'] - 1
                                              });
                                            } else {
                                              FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.email)
                                              .collection('cart')
                                              .doc(data.id)
                                              .delete();
                                            }
                                          },
                                          child: Icon(data['quantity'] == 1 ? Icons.delete : Icons.remove)
                                        ),
                                        Text(
                                          data['quantity'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user!.email)
                                            .collection('cart')
                                            .doc(data.id)
                                            .update({
                                              'quantity': data['quantity'] + 1
                                            });
                                          },
                                          child: const Icon(Icons.add)
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
            bottomNavigationBar: Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                        Text(
                          '\$$totalAmount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor
                          ),
                        )
                      ],
                    ),
                    CustomButton(
                      buttonTitle: 'Buy Now',
                      onTap: () {
                        List<Map<String, dynamic>> cartData = cartItems.map((item) => item.data() as Map<String, dynamic>).toList();
                  
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(cartData: cartData, amount: totalAmount,)));
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }
      }
    );
  }
}
