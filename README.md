# 🎵 Reproductor de Música - Proyecto en Flutter

¡Bienvenidos a mi Reproductor de Música! Este es un proyecto que estoy desarrollando con mucho cariño usando Flutter, y estoy súper emocionado con cómo está quedando. La idea es crear una app que permita a los usuarios disfrutar de su música local de manera sencilla y con un diseño atractivo. Aunque aún está en desarrollo, ya tiene varias funcionalidades geniales que me encantan, y quiero compartirlas contigo.

## 🚀 ¿Qué es este proyecto?

Este reproductor de música es una aplicación móvil diseñada para reproducir canciones almacenadas localmente en tu dispositivo. Me inspiré en la idea de tener una app minimalista pero funcional, con un diseño moderno que incluya elementos como arte de álbumes, controles intuitivos y un fondo con gradientes que le dan un toque especial. Estoy trabajando en hacerlo lo más fluido y bonito posible, y hasta ahora, ¡me encanta el progreso!

## ✨ Características Implementadas

Aquí están las cosas que ya funcionan y que me tienen muy emocionado:

- **Reproducción de Canciones Locales**: La app puede cargar y reproducir canciones almacenadas en tu dispositivo.
- **Controles de Reproducción**: Incluye botones para play/pause, avanzar y retroceder.
- **Diseño Moderno**:
  - Arte de álbumes visible mientras se reproduce una canción.
  - Fondo con gradientes que cambian según la canción.
  - Interfaz responsive en dispositivos físicos y emuladores.
- **Compatibilidad Multiplataforma**: Probado en Android (API 34 y 36), Windows, Chrome y Edge.

## 🛠️ Tecnologías Usadas

- **Flutter**: Framework principal para construir la app.
- **Dart**: Lenguaje para programar la lógica de la app.
- **Gradle**: Manejo de dependencias y compilación en Android.
- **Android Studio**: Entorno de desarrollo para pruebas.

## 📋 Requisitos para Probarlo

- Flutter SDK (versión 3.x o superior).
- Dart (incluido con Flutter).
- Android Studio o VS Code.
- Dispositivo Android (Android 14 o emulador con Android 16).
- Conexión a Internet para descargar dependencias.

## ⚙️ Instalación

### Clona el Repositorio

> *Nota: Este paso es para el futuro cuando suba el proyecto a GitHub.*

```bash
git clone <URL-del-repositorio>
cd reproductor
```

### Instala las Dependencias

```bash
flutter pub get
```

### Configura Gradle

Archivo `android/build.gradle.kts`:

```kotlin
val kotlinVersion = "1.8.10"

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

Archivo `android/gradle/wrapper/gradle-wrapper.properties`:

```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-all.zip
```

### Limpia el Proyecto

```bash
flutter clean
flutter pub get
```

### Ejecuta la App

Conecta un dispositivo Android o inicia un emulador:

```bash
flutter run
```

## 🖥️ Dispositivos Probados

- Teléfono Físico: 23049PCD8G con Android 14 (API 34).
- Emulador: sdk gphone64 x86 64 con Android 16 (API 36).
- Escritorio: Windows 10.
- Navegadores Web: Chrome y Edge.

## ⚠️ Problemas Conocidos

- **Conexión a Repositorios de Maven**: Resuelto ajustando los DNS a 8.8.8.8 y 8.8.4.4.
- **Errores de Sintaxis en Gradle**: Resuelto usando sintaxis correcta para Kotlin Script.
- **Compatibilidad de Versiones**: Ajuste de Kotlin a 1.8.10 y Gradle a 8.2.
- **Timeout al Descargar Gradle**: Estamos resolviendo deteniendo procesos y limpiando caché.

## 🌟 Planes Futuros

- Mejorar diseño de controles.
- Agregar soporte para listas de reproducción.
- Implementar modo oscuro.
- Subir el proyecto a GitHub bajo el usuario `joseorteha`.

## 💻 Sobre el Desarrollador

Soy **José Ortega**, estudiante apasionado por la programación. Este proyecto es parte de mis *Proyectos 2025*, y estoy aprendiendo un montón. Puedes encontrarme en:

- GitHub: [joseorteha](https://github.com/joseorteha)
- LinkedIn: [jose-orteg4](https://www.linkedin.com/in/jos%C3%A9-ortega-497387321/)
- Instagram: [mr.orteg4](https://www.instagram.com/mr.orteg4/)

También formo parte del **Telebachillerato Xochitla**, una escuela que me ha apoyado en mi camino como desarrollador.

## 📜 Cita Inspiradora

> "El software es como el arte: tienes que verlo para entenderlo, y a veces, tienes que romper las reglas para crear algo nuevo." – *Linus Torvalds* (traducido al español)

¡Gracias por leer y espero que disfrutes de mi Reproductor de Música tanto como yo! 🎶
