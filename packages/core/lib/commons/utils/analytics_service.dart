import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);
}
