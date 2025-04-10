# MyTask - Task Management Application

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84.svg?style=for-the-badge&logo=android-studio&logoColor=white)](https://developer.android.com/studio)

A simple and efficient task management application built with Flutter, following Clean Architecture principles and utilizing the BLoC (Business Logic Component) pattern for state management.

## Getting Started

This guide will walk you through the steps to set up and run the MyTask project on your local machine.

### Prerequisites

Before you begin, ensure you have the following installed:

* **Android Studio:** You can download it from the official website: [https://developer.android.com/studio](https://developer.android.com/studio)
* **Flutter SDK:** Follow the installation instructions on the official Flutter website: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)
    * Make sure to configure your environment variables to include the Flutter SDK in your system's PATH.
    * Run `flutter doctor` in your terminal to verify your Flutter installation and identify any missing dependencies.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/firdausmaulan/mytask.git
    cd mytask
    ```

2.  **Open the project in Android Studio:**
    * Launch Android Studio.
    * Select "Open an existing Android Studio project".
    * Navigate to the cloned `mytask` directory and click "Open".

3.  **Get Flutter dependencies:**
    * Open the terminal within Android Studio (View > Tool Windows > Terminal).
    * Run the following command to download all the necessary Flutter packages:
        ```bash
        flutter pub get
        ```

### Running the Application

You can run the MyTask application on either an emulator or a physical Android or iOS device.

1.  **Connect a physical device** or **start an emulator** through Android Studio's AVD Manager (Tools > Device Manager).

2.  **Run the application:**
    * In the Android Studio terminal, run the following command:
        ```bash
        flutter run
        ```

    * Alternatively, you can use the "Run" button (green triangle) in Android Studio.

## Architecture Overview

This project adheres to the **Clean Architecture** principles, aiming for separation of concerns and testability. The application is structured into distinct layers:

* **Presentation (UI):** This layer is responsible for the user interface and handling user interactions. It consists of widgets, screens, and the BLoC for managing the UI state.

* **Data:** This layer is responsible for data retrieval and persistence. It implements the repository contracts defined in the Domain layer.
    * **Repositories (Implementation):** Concrete implementations of the repository interfaces, responsible for fetching data from various sources (e.g., local database, remote API).
    * **Services:** Handle communication with external data sources.
        * **App HTTP Client (Dio):** A centralized HTTP client built with the `dio` package. This abstraction provides a single point of configuration for network requests.
        * **Task API Service:** A specific service responsible for interacting with the task-related API endpoints.

### Why an App HTTP Client?

The `App HTTP Client` acts as an abstraction layer over the chosen HTTP networking library (in this case, `dio`). This design provides several benefits:

* **Flexibility:** If we decide to switch to a different HTTP networking library in the future (e.g., `http`), we only need to modify the `App HTTP Client` implementation, without affecting other parts of the application that rely on network requests.
* **Centralized Configuration:** Common configurations like base URLs, headers, and interceptors can be managed in one place within the `App HTTP Client`.

### State Management with BLoC

The application utilizes the **BLoC (Business Logic Component)** pattern for managing the application's state. BLoC helps to separate the business logic from the presentation layer, making the code more organized, testable, and maintainable.

* **Events:** Represent actions that can occur in the application (e.g., `LoadTasks`, `AddTask`).
* **States:** Represent the different states of the UI based on the business logic (e.g., `TasksLoading`, `TasksLoaded`, `TaskAdded`).
* **Blocs:** Components that process incoming events and emit new states based on the application's business rules.
---

## 📸 Screenshots

<div align="center">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/1.jpeg" width="250">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/2.jpeg" width="250">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/3.jpeg" width="250">
</div>

<div align="center">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/4.jpeg" width="250">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/5.jpeg" width="250">
  <img src="https://raw.githubusercontent.com/firdausmaulan/mytask/refs/heads/master/screenshot/6.jpeg" width="250">
</div>

---
