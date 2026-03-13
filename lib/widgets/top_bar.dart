import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0), // roughly 0.5px grey line equivalent
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Instagram',
              style: TextStyle(
                fontFamily: 'Helvetica Neue', // Using default sans/cursive approximation if custom font isn't loaded
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.favorite_border, size: 26, color: Colors.black),
                ),
              ),
              InkWell(
                onTap: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                  child: Transform.rotate(
                    angle: -0.4, // Rotated slightly to look like Instagram's paper plane
                    child: const Icon(Icons.send_outlined, size: 26, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
