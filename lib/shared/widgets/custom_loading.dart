import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class CustomLoading extends StatelessWidget {
  final double? size;

  const CustomLoading({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final loadingSize = size ?? 150.w;

    return Center(
      child: SizedBox(
        width: loadingSize,
        height: loadingSize,
        child: Lottie.network(
          'https://assets5.lottiefiles.com/packages/lf20_t9gkkhz4.json',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
