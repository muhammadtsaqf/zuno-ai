# ProGuard Rules for Zuno AI (Play Protect & Safety Verification)

# Keep Flutter Android embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep native methods & entrypoints
-keepclasseswithmembernames class * {
    native <methods>;
}

# Prevent reflection stripping for JSON serialization
-keepattributes Signature, InnerClasses, EnclosingMethod, *Annotation*

# Don't warn on missing optional libraries
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**