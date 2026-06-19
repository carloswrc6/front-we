import 'package:flutter/material.dart';

class MenuItem {
  final String titleKey;
  final String subTitleKey;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.titleKey,
    required this.subTitleKey,
    required this.link,
    required this.icon,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    titleKey: 'profile',
    subTitleKey: 'profileSubtitle',
    link: '/profile',
    icon: Icons.person_outline,
  ),
  MenuItem(
    titleKey: 'theme',
    subTitleKey: 'themeSubtitle',
    link: '/theme_changer',
    icon: Icons.palette_outlined,
  ),
];
