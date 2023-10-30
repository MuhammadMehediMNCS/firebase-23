import 'package:firebase_ecommerce_app/global_widgets/custom_button.dart';
import 'package:firebase_ecommerce_app/global_widgets/custom_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, String> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  List<String> producyVarient = [
      '35',
      '36',
      '37',
      '38',
      '39',
      '40'
    ];

    int selectedIndex = 0;
    
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppBar(
        backgroundColor: Colors.transparent,
        context: context
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Container(
              height: size.height * .3,
              width: double.infinity,
              color: const Color(0xFFEEEDED),
              child: Center(
                child: Image.network(
                  widget.product['image']!,
                  height: 200,
                  width: 250,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name Section
                  Text(
                    widget.product['name'] ?? 'Dafult Name',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  // Product Rating Section
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.orangeAccent, size: 20,),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 20,),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 20,),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 20,),
                      Icon(Icons.star, color: Colors.orangeAccent, size: 20,)
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Product Price Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${widget.product['price'] ?? 'Not Available'}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        'Available in Stock',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(.5)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  // About Product
                  const Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    "The upgraded S6 S/P runs up to 20 percent faster, allowing apps to also launch 20 percent faster, while maintaining the same all-day 18-hour battery life",
                    style: TextStyle(
                      color: Colors.black.withOpacity(.5)
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      // Product Varient Section
      bottomNavigationBar: Container(
        height: 150,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12)
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 35,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? Theme.of(context).primaryColor : null,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFD8D3D3), width: 1.5)
                      ),
                      child: Center(
                        child: Text(
                          producyVarient[index],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: selectedIndex == index ? Colors.white : Colors.black
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
            const CustomButton(
              buttonTitle: 'Add to Cart'
            )
          ],
        ),
      ),
    );
  }
}