import 'package:frontwe/l10n/app_localizations.dart';
import 'package:frontwe/presentation/auth/widgets/custom_header.dart';
import 'package:frontwe/presentation/shared/widgets/SideMenu.dart';
import 'package:flutter/material.dart';

class OtherScreen2 extends StatelessWidget {
  const OtherScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(actions: []),
      drawer: SideMenu(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('OtherScreen2'),
            CustomHeader(
              icon: Icon(Icons.touch_app, size: 32),
              title: t!.title,
              subtitle: t.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
