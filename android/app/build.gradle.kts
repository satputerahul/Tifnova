plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")

    // ✅ Add this line (without version / apply false)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.Tifnova"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.Tifnova"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Add Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // ✅ Add Firebase SDKs you’ll use
    implementation("com.google.firebase:firebase-analytics")
    // जर तू Firebase Auth (OTP) वापरणार असशील तर हे पुढे add कर:
    implementation("com.google.firebase:firebase-auth")
}
