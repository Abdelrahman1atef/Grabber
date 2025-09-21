import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

 static  List  banners = [
    Assets.banners.slider1,
    Assets.banners.slider2,
    Assets.banners.slider3,
   ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: banners.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Image.asset(
          banners[index].path,
        );

      },
      options: CarouselOptions(
        height: 200,
          aspectRatio: 1,
          autoPlay: true,
        viewportFraction: 0.7,
        enlargeCenterPage: true
      ),

    );
  }
}































