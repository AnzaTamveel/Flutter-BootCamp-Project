# **Note-Taking App**

A simple note-taking app built with **Flutter** and **Firebase** that allows users to securely create, edit, delete, and organize their notes. The app provides user authentication, note categorization, search, and filtering capabilities.

---

## **Features**

- **User Authentication**: Users can sign up, log in, and manage their accounts securely using Firebase Authentication.
- **Create Notes**: Users can add new notes with a title, content, and category (Work, Personal, Study).
- **Edit Notes**: Users can update existing notes.
- **Delete Notes**: Users can delete their notes when they no longer need them.
- **Categorization**: Notes can be categorized as 'Work', 'Personal', or 'Study' for easy organization.
- **Search**: Users can search for notes by title.
- **Filter**: Users can filter notes based on categories (Work, Personal, Study).
  
---

## **App Structure**

The app follows an **MVVM (Model-View-ViewModel)** architecture for clean and maintainable code.


### **Explanation of Major Files**
- **models/note.dart**: Defines the `Note` class with fields like `title`, `content`, `category`, and `createdAt`.
- **views/**: Contains screens for displaying, creating, editing, and managing notes.
- **view_models/**: Contains business logic for authentication (`auth_view_model.dart`) and note management (`note_view_model.dart`).
- **services/**: Manages interactions with Firebase services (authentication and Firestore).
- **widgets/note_item.dart**: A reusable widget for displaying individual notes in a list.

---

## **Technologies Used**

- **Flutter**: Framework for building the app.
- **Firebase Authentication**: Provides user authentication.
- **Firebase Firestore**: Cloud-based NoSQL database for storing notes.
- **Provider**: Used for state management.

---

## **Installation & Setup**

### Prerequisites
1. **Flutter**: Make sure Flutter is installed on your machine. You can check the official Flutter installation guide [here](https://flutter.dev/docs/get-started/install).
2. **Firebase Account**: You'll need to set up Firebase for both authentication and Firestore.
   - Create a Firebase project [here](https://console.firebase.google.com/).
   - Add your Flutter app to the Firebase project and follow the steps to download the `google-services.json` for Android and `GoogleService-Info.plist` for iOS.

### Steps to Set Up
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <project-directory>
### **Steps to Set Up**

1. **Install dependencies**:
   ```bash
   flutter pub get


