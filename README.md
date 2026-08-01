# SafeSteps 🚸

**SafeSteps** is a modern, cross-platform road safety awareness and educational application designed for students and young commuters. Built with **Flutter** and powered by **Firebase Firestore**, it delivers interactive lessons, real-time survey insights, gamified quizzes, and dynamic achievement tracking.

---

## ✨ Features

- 📱 **Cross-Platform & Responsive:** Seamlessly adapts UI layout across Android, iOS, Windows, and Web.
  - *Mobile:* Clean bottom navigation bar for quick thumb navigation.
  - *Desktop/Tablet:* Expands into a side `NavigationRail` with centered max-width content container.
- 📊 **Real-Time Survey Insights:** Uses Firebase Firestore streams to push real-time traffic safety statistics directly to users.
- 🚴 **Interactive Safety Modules:** Categorized learning paths covering:
  - Pedestrian Crosswalk Rules
  - Bicycle Safety & Night Reflectors
  - Two-Wheeler & Pillion Helmet Rules
  - Car & Bus Boarding Protocols
- 🏆 **Gamified Quizzes & Achievement Badges:** Test traffic rule knowledge and earn level-based safety badges synced to cloud storage.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev/) (Material 3 UI)
- **Language:** [Dart](https://dart.dev/)
- **Cloud Backend:** [Firebase Firestore](https://firebase.google.com/docs/firestore)
- **Architecture:** Clean Modular Design (`models`, `services`, `screens`, `widgets`, `utils`)

---

## 📁 Project Structure

```text
lib/
├── data/              # Mock fallback data and initial app states
├── models/            # Data models (UserProfile, QuizQuestion, SafetySign, Lesson)
├── screens/           # Responsive app screens (Home, Learn, Quiz, Signs, Badges)
├── services/          # Cloud services (DatabaseService for Firebase Firestore)
├── utils/             # Global themes, constants, and color schemes
├── widgets/           # Reusable UI components (SurveyCard, CategoryCard, etc.)
└── main.dart          # Application entry point & Firebase initialization
