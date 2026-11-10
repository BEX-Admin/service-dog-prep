import 'dart:html' as html;
import 'package:flutter/material.dart';

bool isWideLayoutImpl(BuildContext context) {
  final ua = (html.window.navigator.userAgent).toLowerCase();
  final isMobileUA = ua.contains('mobile') ||
      ua.contains('android') ||
      ua.contains('iphone') ||
      ua.contains('ipad') ||
      ua.contains('ipod');
  if (isMobileUA) return false;

  final inner = html.window.innerWidth ?? 0;
  final mq = MediaQuery.of(context).size.width;
  final width = inner > 0 ? inner : mq;
  return width > 1100;
}
