import 'package:flutter/material.dart';

spinner(bool loading) {
  return loading ? SizedBox(child: LinearProgressIndicator(), height: 1.0) : SizedBox(height: 1.0);
}