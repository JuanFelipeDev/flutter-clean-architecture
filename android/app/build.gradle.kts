plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.americanassist.affiliate_app"
    // Bumped to 36: package_info_plus requires libraries compiled against
    // API 36+. (flutter.compileSdkVersion defaults lower.)
    compileSdk = 36
    // NDK intentionally not pinned: the project's plugins ship prebuilt .so
    // and don't compile native code. Pinning flutter.ndkVersion forces Gradle
    // to install a specific (incomplete-on-this-machine) NDK and fails the
    // build. Re-enable + install that NDK if a future plugin needs to compile.

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Matches AFILIADO's default applicationId so the AFILIADO-issued
        // Google Maps key (restricted to com.americanassist.afiliado) authorizes
        // the native GoogleMap widget. Change to a dedicated package + your own
        // Maps key for production. NOTE: also requires the debug SHA-1 of this
        // machine to be registered on that key (same debug keystore AFILIADO
        // uses, ~/.android/debug.keystore).
        applicationId = "com.americanassist.afiliado"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
