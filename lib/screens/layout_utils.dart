import 'package:flutter/material.dart';
import 'layout_utils_stub.dart'
    if (dart.library.html) 'layout_utils_web.dart';

bool isWideLayout(BuildContext context) {
  return isWideLayoutImpl(context);
}
