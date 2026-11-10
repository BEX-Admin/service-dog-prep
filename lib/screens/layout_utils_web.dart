import 'dart:html' as html;
import 'package:flutter/material.dart';

bool isWideLayoutImpl(BuildContext context) {
  // Force mobile on any touch / mobile-like device or narrow real window.
  final ua = (html.window.navigator.userAgent).toLowerCase();
  final isMobileUA = ua.contains('mobile') ||
      ua.contains('android') ||
      ua.contains('iphone') ||
      ua.contains('ipad') ||
      ua.contains('ipod') ||
      ua.contains('silk') ||
      ua.contains('kindle');
  if (isMobileUA) return false;

  final inner = html.window.innerWidth ?? 0;
  // Only true large desktop windows get the wide layout.
  return inner > 1400;
}
