-keep public class com.google.android.gms.** { public protected *; }
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.firebase.** { *; }
-keep class io.flutter.** { *; }

# Keep Start.io SDK classes
-keep class com.startapp.** { *; }

# Keep Flutter plugin wrapper classes
-keep class com.startapp.flutter.sdk.** { *; }

# Keep WebView JavaScript interfaces (if used)
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Optional: Keep line numbers for better crash logs
-keepattributes SourceFile,LineNumberTable

# Ignore warnings to prevent build failures due to missing references
-ignorewarnings
