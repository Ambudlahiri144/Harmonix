# Project Overview :
Harmonix is a Flutter application that streams and plays both music and videos from your device. The app provides two modes – Music Mode and Video Mode – each with its own Home and Favorites page. The app also includes a shared Account page that aggregates user information and displays all favorited media. It aims to simplify the experience of browsing and playing both music and video content on a single platform. By separating the media into two distinct modes, the app offers a clean and easy-to-navigate interface that helps you jump directly to your preferred content type.

# Techstack :

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white) ![Firebase](https://img.shields.io/badge/firebase-a08021?style=for-the-badge&logo=firebase&logoColor=ffcd34)


# Architecture:
![Harmonix](https://github.com/user-attachments/assets/2a9a99b5-cf8f-4f8e-92a2-28d91b8265f5)

# Key Features:
1. **Music Home & Video Home**
   - Browse and play locally stored music and videos.
   - Quickly jump between Music or Video Mode via bottom navigation or a mode selector.
     
     ![image](https://github.com/user-attachments/assets/04cbcea4-191b-4a2f-9872-f34fd47714af)

2. **Mini Player & Full Player**
   - **Mini Player**: Appears at the bottom of the screen for quick access to play/pause/seek controls while the user browses other content.

     ![image](https://github.com/user-attachments/assets/1e7a3865-6fe9-4f51-a067-cc8c7833324d)

   - **Full Player**: Tapping on the mini player expands it into a full-screen player with more detailed controls, such as a progress bar, shuffle, repeat, etc.
     
     ![image](https://github.com/user-attachments/assets/a468c4d8-ddc9-4340-a6ae-80f88c1dc63d)
     


3. **Favorites**
   - **Mode-Specific Favorites**: Each mode (Music, Video) maintains its own Favorites list.
   - **Account Page**: Shows a combined view of all liked songs and videos.
     
     ![image](https://github.com/user-attachments/assets/61bf0222-a0d1-49ac-98ea-a4d2caa1a31d)
     
     ![image](https://github.com/user-attachments/assets/41e3954e-5e87-4b7e-920e-b54272655f02)



4. **Firebase Integration**
   - **Firebase Authentication**: Manages user sign-ins, sign-ups, and sessions.
   - **Cloud Firestore/Realtime Database**: Stores user-specific data (e.g., liked music/videos) in real time.
   - **Firebase Security**: Ensures that only authenticated users can read/write certain data.

     ![image](https://github.com/user-attachments/assets/4fd53527-989c-4e56-87eb-7a3e9d723a54)
     
     ![image](https://github.com/user-attachments/assets/193624be-cf6f-44e7-bee8-4ef6f10641f4)
     
     ![image](https://github.com/user-attachments/assets/4a3bb952-d81a-413b-b989-2b0e39622a77)




5. **Responsive Mobile UI**
   - Tailored to run smoothly on both Android and iOS devices.

# Workflow:
1. **App Launch & User Authentication**
   - When Harmonix is launched, it checks for an active Firebase user session.
   - If none is found, users are prompted to log in or sign up.
   - Upon successful authentication, users proceed to the main navigation.

2. **Selecting a Mode (Music or Video)**
   - From the home screen or navigation bar, users choose **Music Mode** or **Video Mode**.

3. **Browsing & Playback**
   - **Music Mode**: Displays a list of all available songs. Users can tap any track to start playback, which appears in the **Music Mini Player** at the bottom.  
   - **Video Mode**: Similarly displays available videos, and playback is shown in the **Video Mini Player**.

4. **Mini Player to Full Player**
   - While a song or video is playing in a mini player, tapping on it expands the player to a full-screen view for additional controls (e.g., timeline scrubbing, shuffle, repeat).

5. **Liking/Favoriting Media**
   - Within each mode’s home page or full player view, users can “like” (favorite) an item.
   - The item is then saved to **Cloud Firestore** (or Realtime Database) under the user’s profile.

6. **Favorites & Account Page**
   - Each mode has its **Favorites Page** displaying only that mode’s liked items.
   - The **Account Page** shows a combined list of **all** favorited songs and videos, along with user information (e.g., profile pic, user name).

7. **Logging Out**
   - Users can log out from the Account Page or Settings, which clears their authenticated session. Upon re-launching, the app will prompt for login again.


