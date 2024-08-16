import 'package:flutter/material.dart';

const bottomNavBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.wb_sunny_outlined),
    activeIcon: Icon(Icons.sunny_snowing),
    label: 'weather',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_border_outlined),
    activeIcon: Icon(Icons.favorite),
    label: 'favorites',
  ),
];
