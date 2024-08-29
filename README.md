# Flutter To-Do App

Welcome to my first Flutter to-do app! This app is designed to help you manage your tasks effectively with a simple and intuitive interface.

## Features

- **Google Sign-In:** Start by signing in using your Google account for a personalized experience.
- **Add Tasks:** Easily add new tasks that you need to accomplish.
- **Complete Tasks:** Mark tasks as complete by clicking on the checkbox next to each task. Completed tasks will be visually indicated by a strike-through effect.
- **Delete Tasks:** Remove tasks that are no longer needed.
- **Firebase Integration:** All tasks and actions (add, complete, delete) are securely stored and synchronized with Firebase Firestore.

## Screenshots
![1000013606](https://github.com/user-attachments/assets/04859c27-409e-49dc-90e6-689c10c56d80)
![1000013605](https://github.com/user-attachments/assets/41017173-d115-4f8e-a458-779bce87b1af)
![1000013604](https://github.com/user-attachments/assets/1a668c98-d510-4e57-8781-147e6b567062)



## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Account: [Create a Firebase Project](https://firebase.google.com/)
- Google Account for authentication

### Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/harsshhan/ToDoApp.git
    cd ToDoApp
    ```

2. **Install dependencies:**

    ```bash
    flutter pub get
    ```

3. **Set up Firebase:**

    - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
    - Add an Android app to the Firebase project and follow the setup steps to download the `google-services.json` file. Place this file in the `android/app` directory.
    - Add an iOS app to the Firebase project and follow the setup steps to download the `GoogleService-Info.plist` file. Place this file in the `ios/Runner` directory.
    - Enable **Firebase Authentication** and select **Google Sign-In** as a sign-in method.
    - Set up **Firebase Firestore** for storing to-do tasks.

4. **Run the app:**

    ```bash
    flutter run
    ```

## How to Use

1. **Sign In:** Launch the app and sign in using your Google account.
2. **Add a Task:** Enter a task description and add it to the list.
3. **Mark as Completed:** Click the checkbox next to a task to mark it as complete. The task will be struck through to indicate its completion.
4. **Delete a Task:** Click the delete icon next to a task to remove it from the list.

## Technologies Used

- **Flutter:** A UI toolkit for crafting natively compiled applications for mobile, web, and desktop from a single codebase.
- **Firebase Authentication:** Provides a secure authentication system using Google Sign-In.
- **Firebase Firestore:** A NoSQL document database for storing and syncing data in real-time.

## Learning Experience

This to-do app is my first project in my app development journey with Flutter. I built this while learning through a YouTube tutorial and it has been a great introduction to Flutter and Firebase. It covers the basics of app development, state management, user authentication, and cloud data storage.

## Contributing

Feel free to fork this repository, make improvements, and create a pull request. Any suggestions for improvements are welcome!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Special thanks to the Flutter community for the great documentation and support.
- Thanks to the YouTube tutorial creators for their comprehensive guides on Flutter and Firebase.
