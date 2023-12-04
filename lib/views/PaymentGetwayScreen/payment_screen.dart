import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:firebase_ecommerce_app/helpers/payment_widget.dart';
import 'package:firebase_ecommerce_app/views/BottomNavBarView/bottom_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartData;
  final double amount;

  const PaymentScreen({super.key, required this.cartData, required this.amount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final bkash = FlutterBkash(
    bkashCredentials: const BkashCredentials(
      username: 'MerchountPhoneNumber/Go to live credential',
      password: 'MerchountPassword',
      appKey: 'MerchountAppKey',
      appSecret: 'MerchountAppSecret',
      isSandbox: false
    )
  );

  Future<void> createOrder({required String gtName, required String trxID}) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'email': user!.email,
      'time': Timestamp.now(),
      'items': widget.cartData,
      'gateway_name': gtName,
      'trx_id': trxID
    }).then((value) async {
      final cart = await FirebaseFirestore.instance.collection('users').doc(user!.email).collection('cart').get();
                    
      for(var item in cart.docs) {
        await item.reference.delete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: 'Payment Method'
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PaymentWidget(
                  image: Image.asset(
                    'assets/images/bkash.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  text: 'bKash',
                  onClecked: () async {
                    try {
                      final result = await bkash.pay(
                        context: context,
                        amount: widget.amount,
                        merchantInvoiceNumber: 'merchantInvoiceNumber'
                      );
                      createOrder(
                        gtName: 'bKash',
                        trxID: result.trxId
                      );
                    } on BkashFailure catch(e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  }
                ),
                PaymentWidget(
                  image: Image.asset(
                    'assets/images/nagad.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  text: 'Nagad',
                  onClecked: () {}
                ),
              ],
            ),
            const SizedBox(height: 22),
            PaymentWidget(
                  image: Image.asset(
                    'assets/images/cod.png',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  text: 'Cash on Delivery',
                  onClecked: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order Successfull')));
                    createOrder(
                      gtName: 'COD',
                      trxID: 'COD'
                    ).then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BottomBarScreen()), (route) => false);
                    });
                  }
                ),
          ],
        ),
      ),
    );
  }
}