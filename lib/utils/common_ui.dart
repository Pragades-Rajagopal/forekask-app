import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const bottomNavBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.sun_max),
    activeIcon: Icon(Icons.sunny_snowing),
    label: 'weather',
  ),
  BottomNavigationBarItem(
    icon: Icon(CupertinoIcons.heart),
    activeIcon: Icon(CupertinoIcons.heart_fill),
    label: 'favorites',
  ),
];
