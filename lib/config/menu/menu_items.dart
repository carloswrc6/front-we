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
    titleKey: 'wheel',
    subTitleKey: 'wheelSubtitle',
    link: '/ruleta',
    icon: Icons.casino,
  ),
  MenuItem(
    titleKey: 'dishes',
    subTitleKey: 'dishesSubtitle',
    link: '/platos',
    icon: Icons.dining,
  ),
  MenuItem(
    titleKey: 'favorites',
    subTitleKey: 'favoritesSubtitle',
    link: '/favoritos',
    icon: Icons.favorite_border,
  ),
  MenuItem(
    titleKey: 'history',
    subTitleKey: 'historySubtitle',
    link: '/historial',
    icon: Icons.history,
  ),
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
