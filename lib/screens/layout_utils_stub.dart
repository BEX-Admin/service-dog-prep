import 'package:flutter/material.dart';

bool isWideLayoutImpl(BuildContext context) {
  return MediaQuery.of(context).size.width > 600;
}
