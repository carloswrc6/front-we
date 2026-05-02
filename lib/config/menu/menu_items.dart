import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;
  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'profile',
    subTitle: 'profile subtitle',
    link: '/profile',
    icon: Icons.ac_unit_outlined,
  ),
  MenuItem(
    title: 'subscription',
    subTitle: 'subscription subtitle',
    link: '/subscription',
    icon: Icons.ac_unit_outlined,
  ),
  MenuItem(
    title: 'colors',
    subTitle: 'colors subtitle',
    link: '/theme_changer',
    icon: Icons.ac_unit_outlined,
  ),
  MenuItem(
    title: 'Other screen 1',
    subTitle: 'Other screen 1 subtitle',
    link: '/other-screen-1',
    icon: Icons.ac_unit_outlined,
  ),
  MenuItem(
    title: 'Other screen 2',
    subTitle: 'Other screen 2 subtitle',
    link: '/other-screen-2',
    icon: Icons.ac_unit_outlined,
  ),
  MenuItem(
    title: 'Other screen 3',
    subTitle: 'Other screen 3 subtitle',
    link: '/other-screen-3',
    icon: Icons.ac_unit_outlined,
  ),
];
