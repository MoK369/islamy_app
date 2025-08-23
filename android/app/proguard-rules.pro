# Keep everything from ExoPlayer (used by just_audio)
-keep class com.google.android.exoplayer2.** { *; }

# Keep everything from just_audio
-keep class com.ryanheise.just_audio.** { *; }

# Keep everything from audio_session
-keep class com.ryanheise.audio_session.** { *; }

# Keep Flutter plugin classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Prevent stripping of methods annotated with @JavascriptInterface (if using WebView)
-keepclassmembers class * {
    @android.webkit.JavascriptInterface public *;
}

# Ignore missing Play Core classes if not using deferred components
-dontwarn com.google.android.play.**
