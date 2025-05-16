plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // Add this plugin here
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.spms_v1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // <-- Updated manually

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.spms_v1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0"
    }
}

dependencies {
    implementation("com.google.firebase:firebase-auth-ktx:22.1.1")
    // You can add other Firebase dependencies here if needed
}
