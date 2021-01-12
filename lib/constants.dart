import 'package:flutter/material.dart';

const kLabelStyle = TextStyle(
  fontFamily: 'Spartan MB',
  color: Colors.yellow,
  fontSize: 20.0,
);

const kDataStyle = TextStyle(
  fontFamily: 'Spartan MB',
  color: Colors.white,
  fontSize: 16.0,
);

const kPlotStyle = TextStyle(
  fontFamily: 'Spartan MB',
  color: Colors.white,
  fontSize: 16.0,
);

const kButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontFamily: 'Spartan MB',
);

const kTextFieldInputDecoration = InputDecoration(
  suffixIcon: IconButton(
    icon: Icon(Icons.search),
    iconSize: 40.0,
  ),
  filled: true,
  fillColor: Colors.white,
  hintText: 'Enter Movie',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide.none,
  ),
);

// TextField(
// controller: _controller,
// decoration: InputDecoration(
// hintText: "Enter a message",
// suffixIcon: IconButton(
// onPressed: () => _controller.clear(),
// icon: Icon(Icons.clear),
// ),
// ),
// )