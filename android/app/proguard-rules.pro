# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Play Core Library - Don't warn about missing classes
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task

# Keep all model classes for JSON serialization
-keep class com.optiaSpa.app.model.** { *; }
-keep class com.optiaSpa.app.** { *; }

# Keep all classes in the lib packages (your Dart models when compiled)
-keep class **.model.** { *; }

# Keep JSON serialization annotations and fields
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep dart:convert and JSON related
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep http package classes
-keep class dart.http.** { *; }
-keep class dart.io.** { *; }

# Keep SharedPreferences
-keep class android.content.SharedPreferences { *; }

# Prevent obfuscation of exception stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep GetX related classes
-keep class dev.flutter.plugins.** { *; }

# Keep all classes that might be used for reflection
-keepclassmembers class * {
    *** get*();
    void set*(***);
}
