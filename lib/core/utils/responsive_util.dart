import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Responsive utility class for consistent sizing across devices
class ResponsiveUtil {
  // Spacing
  static double spacing(double value) => value.w;
  static double verticalSpacing(double value) => value.h;
  
  // Font sizes
  static double fontSize(double value) => value.sp;
  
  // Radius
  static double radius(double value) => value.r;
  
  // Icon sizes
  static double iconSize(double value) => value.w;
  
  // Padding
  static EdgeInsets padding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    if (all != null) {
      return EdgeInsets.all(all.w);
    }
    return EdgeInsets.only(
      left: (left ?? horizontal ?? 0).w,
      right: (right ?? horizontal ?? 0).w,
      top: (top ?? vertical ?? 0).h,
      bottom: (bottom ?? vertical ?? 0).h,
    );
  }
  
  // Screen dimensions
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  
  // Responsive breakpoints
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  static bool get isDesktop => screenWidth >= 900;
  
  // Grid columns based on screen size
  static int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }
  
  // Card aspect ratio based on screen size
  static double get cardAspectRatio {
    if (isDesktop) return 0.75;
    if (isTablet) return 0.7;
    return 0.65;
  }
}
