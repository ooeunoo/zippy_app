import 'package:flutter/services.dart';

void onLightVibration() {
  HapticFeedback.lightImpact();
}

void onMediumVibration() {
  HapticFeedback.mediumImpact();
}

void onHeavyVibration() {
  HapticFeedback.heavyImpact();
}
