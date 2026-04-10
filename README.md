# Vibe Hear 🦻📳

> **Feel the Sound, Stay Connected.**

**Vibe Hear** is a philanthropic, offline-capable, assistive Android application designed for the Deaf and hard-of-hearing community. It transforms spoken words—such as emergency keywords or a user's name—into customizable vibration alerts, ensuring users stay aware of their surroundings without relying on hearing.😊

---

## 📖 Table of Contents
- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [How It Works](#-how-it-works)
- [Privacy & Background Execution](#-privacy--background-execution)
- [Tech Stack](#-tech-stack)
- [Installation & Setup](#-installation--setup)
- [Usage Guide](#-usage-guide)
- [The Team](#-the-team)

---

## 💡 About the Project

Vibe Hear was developed as a college project to bridge the communication gap for deaf individuals. It utilizes the phone's built-in microphone to listen for specific "trigger words" (like "Help Me" or "Emergency") and notifies the user via distinct, user-defined vibration patterns. 

The application focuses heavily on **accessibility**, **simplicity**, and **privacy**.

---

## ✨ Key Features

* **🎙️ Smart Keyword Detection:** Continuously listens for specific phrases (e.g., "Emergency", "Come Here", "Help Me") using native on-device Speech-to-Text processing.
* **📳 Customizable Vibration Patterns:** Users can design unique vibration rhythms for each keyword (e.g., *Short-Short-Long* for "Emergency") to instantly recognize what is being said without looking at the phone.
* **⚡ True Background Execution:** Operates seamlessly even when the phone is locked or minimized using Android Foreground Services.
* **🔕 Quick Action Mute:** Mute or unmute the microphone directly from the persistent Android notification tray on the go.
* **👤 Personalization:** Stores user details (Name, Nickname) locally to personalize the experience.
* **🛡️ Privacy First:** No audio is recorded or uploaded to the cloud. All audio parsing and trigger matching happens locally.

---

## ⚙️ How It Works

1.  **Microphone Access:** The app securely requests access to the device microphone.
2.  **Continuous Background Listening:** It runs a persistent background isolate that translates speech to text continuously.
3.  **Keyword Matching:** It matches the spoken text against the user's enabled Trigger Words.
4.  **Haptic Feedback:** Once a keyword is matched, the background engine instantly triggers the vibration motor with the specific pattern assigned to that word.

---

## 🔒 Privacy & Background Execution

We care deeply about privacy.
* **No Data Collection:** Vibe Hear does not collect, store, or share personal information.
* **Microphone Transparency:** While active, android natively displays a microphone icon. You can always mute the app internally via the Background Notification.
* **Local Storage:** Settings, transcripts, and preferences are saved securely on the device using `SharedPreferences`.

---

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.8.0)
* **Language:** Dart
* **Architecture:** BLoC (Business Logic Component) via `flutter_bloc`
* **Speech Engine:** [Speech To Text](https://pub.dev/packages/speech_to_text)
* **Background Process:** [Flutter Background Service](https://pub.dev/packages/flutter_background_service)
* **Haptics:** [Vibration](https://pub.dev/packages/vibration)
* **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)

---

## 🚀 Installation & Setup

Follow these steps to run the project locally.

### Prerequisites
* **Flutter SDK** installed on your machine.
* **Android Device** (Physical device highly recommended for testing background foreground services and vibration motors).

### Steps
1.  **Clone the Repository**
    ```bash
    git clone https://github.com/YourUsername/Hear_Vibe.git
    cd Hear_Vibe
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Run the App**
    ```bash
    flutter run
    ```

> **Note:** Ensure your device has granted Microphone and Notification permissions to the app upon first launch.

---

## 📱 Usage Guide

### 1. Initial Setup
On the first launch, you will be greeted by the Intro screen. Click **Get Started** and enter your local profile details.

### 2. Dashboard (Home)
The app consists of three main tabs:
1.  **Home:** View live active status and application states.
2.  **Vibration (Trigger Words):** Add dynamic trigger phrases and configure their vibration rhythms.
3.  **Transcript:** View a real-time transcript history generated seamlessly by the background listening service.

### 3. Configuring Vibrations
1.  Navigate to the **Vibration Page** (middle tab).
2.  You will see a list of trigger words (e.g., "Emergency").
3.  **Toggle** the switch to Enable/Disable detection for that word.
4.  **Tap** on the word card to open the **Configuration Page**.
    * Enter a duration in milliseconds (e.g., `500`) and tap `+`.
    * Add multiple durations to create a pattern (e.g., 500ms ON, pause, 200ms ON).
    * Tap **Test** to feel the pattern.
    * Tap **Save** to apply it securely.

---

## 👥 The Team

This project was brought to life by a dedicated team of developers and designers.

| Name | Role | Links |
| :--- | :--- | :--- |
| **Vivek Sharma** | Backend Application Developer | [LinkedIn](https://www.linkedin.com/in/vivek-sharma-18b883227/) \| [GitHub](https://github.com/Codevek/) |
| **Hanu Shashwat** | Frontend Application Developer | [LinkedIn](https://www.linkedin.com/in/hanushashwat/) \| [GitHub](https://github.com/HanuShashwat) |
| **Tannu Sharma** | UI/UX Designer | [LinkedIn](https://www.linkedin.com/in/tannu-sharma-343b77331/) \| [GitHub](https://github.com/TannuSharma861) |

---

*This application is a prototype developed for educational purposes.*
