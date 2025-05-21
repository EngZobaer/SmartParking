plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // Add this plugin here
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.spms_v1"

    // Set compileSdk to 34 to match the Firebase dependencies
    compileSdk = 34

    ndkVersion = "27.0.12077973" // Updated version for NDK support if required for native code

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.spms_v1"
        minSdk = 21 // Set the minimum SDK version
        targetSdk = 34 // Target SDK version
        versionCode = 1
        versionName = "1.0"
    }
}

dependencies {
    implementation("com.google.firebase:firebase-auth-ktx:22.1.1") // Firebase Authentication (KTX version)
    implementation("com.google.firebase:firebase-firestore-ktx:24.0.1")  // Firestore
    implementation("com.google.firebase:firebase-messaging-ktx:23.1.0")  // Firebase Messaging
}
