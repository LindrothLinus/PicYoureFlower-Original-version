import 'package:flutter/material.dart';

class NewAddButton extends StatefulWidget {
  const NewAddButton({super.key,required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<NewAddButton> createState() =>
      _NewAddButtonState();
}
class _NewAddButtonState extends State<NewAddButton> {
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 45,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Icon(Icons.tune),
      ),
    );
  }
}