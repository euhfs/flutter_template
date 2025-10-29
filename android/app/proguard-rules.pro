# Flutter and plugin classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep your own app code
-keep class com.example.flutter_template.** { *; }

# Keep annotation data
-keepattributes *Annotation*

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Sometimes needed for reflection-based libraries (optional)
# -keep class androidx.lifecycle.** { *; }
# -keep class androidx.core.** { *; }

# Don't warn about Flutter and Kotlin
-dontwarn io.flutter.**
-dontwarn kotlin.**
