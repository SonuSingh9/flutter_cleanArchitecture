import 'package:flutter/material.dart';

class AuthFeild extends StatelessWidget {

final String hintText;
  const AuthFeild({
    super.key,
    required this.hintText
    });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText
      ),
    );
  }
}