import 'package:flutter/material.dart';

class PaymentWidget extends StatelessWidget {
  final String? text;
  final Image? image;
  final void Function() onClecked;

  const PaymentWidget({
    super.key,
    this.text,
    this.image,
    required this.onClecked
  });

  @override
  Widget build(BuildContext context) => Container(
      height: 180,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 2, color: Colors.indigo)
          ),
      child: MaterialButton(
        onPressed: onClecked,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            image!,
            Text(text!)
          ],
        ),
      ),
    );
}