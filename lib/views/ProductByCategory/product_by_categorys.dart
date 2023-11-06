import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class ProductByCategorys extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> category;

  const ProductByCategorys({super.key, required this.category});

  @override
  State<ProductByCategorys> createState() => _ProductByCategorysState();
}

class _ProductByCategorysState extends State<ProductByCategorys> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        context: context,
        title: widget.category['name']
      ),
      body: StreamBuilder(
        stream: fireStore.collection('products').where('cat-id', isEqualTo: widget.category['id']).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Card(
                  child: ListTile(
                    title: Text(data['name']),
                    subtitle: Text('\$${data['price']}'),
                  ),
                );
              }
            );
          }
        }
      )
    );
  }
}