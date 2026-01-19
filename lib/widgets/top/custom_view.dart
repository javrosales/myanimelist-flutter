import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:provider/provider.dart';

class CustomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Provider.of<UserData>(context).gridView ? const Icon(Icons.view_headline) : const Icon(Icons.apps),
      key: const Key('top_view'),
      tooltip: 'Change view',
      onPressed: () {
        FirebaseAnalytics.instance.logEvent(name: 'top_view');
        Provider.of<UserData>(context, listen: false).toggleView();
      },
    );
  }
}
