import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


Widget ShimmerEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      height: 500, // Adjust the height as needed
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(
          6, // Number of shimmer items you want
              (index) => Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 50.0,
          ),
        ),
      ),
    ),
  );
}