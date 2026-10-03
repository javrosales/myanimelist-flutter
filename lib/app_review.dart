import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> requestReviewIfNeeded() async {
  final prefs = await SharedPreferences.getInstance();
  final lastRequest = prefs.getInt('lastRequest');
  if (lastRequest != null) {
    final lastDate = DateTime.fromMillisecondsSinceEpoch(lastRequest);
    if (DateTime.now().difference(lastDate).inDays < 30) return;
  }

  final review = InAppReview.instance;
  if (await review.isAvailable()) {
    FirebaseAnalytics.instance.logEvent(name: 'rate');
    await review.requestReview();
    await prefs.setInt('lastRequest', DateTime.now().millisecondsSinceEpoch);
  }
}
