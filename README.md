# Vibe Hear 🦻📳

> **Feel the Sound, Stay Connected.**

**Vibe Hear** is a philanthropic, offline, assistive Android application designed for the Deaf and hard-of-hearing community. It transforms spoken words—such as emergency keywords or a user's name—into customizable vibration alerts, ensuring users stay aware of their surroundings without relying on hearing.😊

---

## 📖 Table of Contents
- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [How It Works](#-how-it-works)
- [Privacy & Offline Capability](#-privacy--offline-capability)
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

* **🎙️ Smart Keyword Detection:** Continuously listens for specific phrases (e.g., "Emergency", "Come Here", "Help Me") using on-device processing.
* **📳 Customizable Vibration Patterns:** Users can design unique vibration rhythms for each keyword (e.g., *Short-Short-Long* for "Emergency") to instantly recognize what is being said without looking at the phone.
* **🔒 100% Offline:** Does not require an internet connection to function.
* **👤 Personalization:** Stores user details (Name, Nickname) locally to personalize the experience.
* **🛡️ Privacy First:** No audio is recorded or uploaded to the cloud. All processing happens locally on the device.

---

## ⚙️ How It Works

1.  **Microphone Access:** The app listens to the environment using the device microphone.
2.  **Keyword Matching:** It uses the **Porcupine** wake word engine to detect pre-trained keywords in real-time.
3.  **Haptic Feedback:** Once a keyword is detected, the app triggers the vibration motor with the specific pattern assigned to that word.

---

## 🔒 Privacy & Offline Capability

We care deeply about privacy.
* **No Data Collection:** Vibe Hear does not collect, store, or share personal information.
* **No Internet Needed:** The app functions entirely in offline mode.
* **Local Storage:** Settings and preferences are saved securely on the device using `SharedPreferences`.

---

## 🛠️ Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.8.0)
* **Language:** Dart
* **Wake Word Engine:** [Porcupine Flutter](https://pub.dev/packages/porcupine_flutter)
* **Haptics:** [Vibration](https://pub.dev/packages/vibration)
* **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
* **Navigation:** [Google Nav Bar](https://pub.dev/packages/google_nav_bar)

---

## 🚀 Installation & Setup

Follow these steps to run the project locally.

### Prerequisites
* **Flutter SDK** installed on your machine.
* **Android/iOS Device** (Physical device recommended for testing vibration and microphone).

### Steps
1.  **Clone the Repository**
    ```bash
    git clone [https://github.com/YourUsername/Hear_Vibe.git](https://github.com/YourUsername/Hear_Vibe.git)
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
On the first launch, you will be greeted by the Intro screen. Click **Get Started** and enter your:
* **First Name** & **Last Name** (Required)
* **Middle Name** & **Nick Name** (Optional)
This creates your local profile.

### 2. Dashboard (Home)
The app consists of three main tabs:
1.  **Home:** View the active status of the app.
2.  **Vibration (Trigger Words):** The core configuration screen.
3.  **Transcript:** (Feature in development) View history of detected sounds.

### 3. Configuring Vibrations
1.  Navigate to the **Vibration Page** (middle tab).
2.  You will see a list of trigger words (e.g., "Emergency").
3.  **Toggle** the switch to Enable/Disable detection for that word.
4.  **Tap** on the word card to open the **Configuration Page**.
    * Enter a duration in milliseconds (e.g., `500`) and tap `+`.
    * Add multiple durations to create a pattern (e.g., 500ms ON, pause, 200ms ON).
    * Tap **Test** to feel the pattern.
    * Tap **Save** to apply it.

### 4. Settings
Access the side menu (Drawer) to find **Settings**. Here you can:
* Reset Vibration Patterns.
* Clear All App Data (Danger Zone).

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

```
