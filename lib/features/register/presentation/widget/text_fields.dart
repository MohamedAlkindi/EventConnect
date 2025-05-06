import 'package:flutter/material.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  required IconData icon,
  bool isObsecure = false,
  void Function()? onTap,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      label: Text(labelText),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: Colors.orange.shade800,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.5,
          style: BorderStyle.solid,
          color: Colors.pink.shade200,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      hintText: hintText,
      suffixIcon: IconButton(
        icon: Icon(icon),
        onPressed: onTap ?? () {},
      ),
    ),
    obscureText: isObsecure,
  );
}
