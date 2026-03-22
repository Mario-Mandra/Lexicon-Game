# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }

# Google Play Core - prevents R8 from stripping split install classes
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# RevenueCat
-keep class com.revenuecat.** { *; }

# AdMob
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# Google Mobile Ads
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**