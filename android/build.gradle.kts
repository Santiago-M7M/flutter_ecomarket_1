// 1) Importa la extensión de librerías Android
import com.android.build.api.dsl.LibraryExtension


// 2) Habilita buildConfig en todas las Android Library (incluye firebase_auth)
subprojects {
plugins.withId("com.android.library") {
    extensions.configure<LibraryExtension> {
        buildFeatures {
            buildConfig = true
            }
        }
    }
}

buildscript {
    repositories {
    google()
    mavenCentral()
    }
        dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
    google()
    mavenCentral()
    }
}

// (Opcional) si reubicas tu buildDir:
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
