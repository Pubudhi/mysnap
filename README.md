# Elderly-Friendly Social Media App

A simple, user-friendly social media application tailored specifically for elderly users. The app is built using **Flutter** for the frontend and **Firebase** for the backend, focusing on simplicity, accessibility, and ease of use.

## Project Overview

This project aims to provide an intuitive platform for elderly users to connect with family and friends. The app includes a simplified interface with large buttons, clear text, and easy navigation to reduce the learning curve for elderly users who may be less familiar with modern social media platforms.

## Features

- **User-Friendly Interface**: Minimalistic design with large, readable text and straightforward navigation.
- **Profile System**: Users can create profiles with bios, post counts, follower counts, and following counts.
- **Follow/Unfollow**: Simple follow and unfollow system for managing connections.
- **Like and Comment**: Users can like and comment on posts with a streamlined UI.
- **Post and Media Sharing**: Users can post and share media, such as photos, with their followers.
- **Offline Access**: View content and interact with the app even without an internet connection, thanks to Firebase's offline capabilities.

## Technologies Used

- **Frontend**: Flutter
  - State Management: Bloc/Cubit
  - UI Components: Custom widgets for buttons, profile stats, user tiles, and more.
  - Network: CachedNetworkImage for efficient image loading
- **Backend**: Firebase
  - Firestore for real-time database
  - Firebase Authentication for user management
  - Firebase Storage for media storage
