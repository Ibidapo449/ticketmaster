
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewImage extends StatelessWidget {
  const ViewImage({super.key, required this.image});

  final File? image;
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 500,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
           const Align(
              alignment: Alignment.center,
              child: Text(
                "View Image",
                style: TextStyle(   fontSize: 18,
                color: Colors.black,),
             
              ),
            ),
            const SizedBox(height: 20),
            Image.file(
              image!,
              height: 300,
              width: 200,
            )
          ],
        ),
      ),
    );
  }
}


