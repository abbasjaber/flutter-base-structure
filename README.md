# Flutter Base Structure

"Flutter Base Structure" is a powerful, production-ready template and architectural approach for developing highly scalable Flutter applications. It relies on a **Feature-First** architecture pattern with robust separation of concerns, dependency injection, and centralized state management.

## 🚀 Key Features
- **Feature-First Architecture**: Grouping code by feature (e.g., `auth`, `home`) instead of by type (e.g., `screens`, `providers`), making it much easier to scale and navigate.
- **Dependency Injection**: Uses `get_it` for clean, decoupled code.
- **State Management**: Implemented with `provider`.
- **Networking**: Configured with `dio`, complete with custom logging and authentication interceptors.
- **Data Persistence**: Configured with `shared_preferences`.
- **Centralized Error Handling**: Safe API error extractions and localizations.

## 📁 Folder Structure

```text
lib/
├── core/                   # Shared configurations and utilities
│   ├── constants/          # App constants, Base URLs
│   ├── di/                 # Dependency Injection setup (get_it)
│   ├── interfaces/         # Core interfaces for Repositories
│   └── network/            # Dio client, Interceptors, API Responses & Error Handling
├── features/               # Application features
│   ├── auth/
│   │   ├── models/         # User data models
│   │   ├── providers/      # UI State management (ChangeNotifier)
│   │   └── repositories/   # Data fetching and external logic
│   └── home/
│       ├── providers/
│       ├── repositories/
│       └── screens/        # UI layer
└── main.dart               # App entry point
```

## 🛠️ Getting Started

### 1. Clone the repo
```bash
git clone https://github.com/abbasjaber/flutter-base-structure.git 
```

### 2. Move to the cloned repo
```bash
cd flutter-base-structure
```

### 3. Get dependencies
```bash
flutter pub get
```

### 4. Run application
```bash
flutter run
```

Happy coding! 🎉
