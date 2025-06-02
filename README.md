
# FoodGo - Complete Food Delivery Solution
A comprehensive Flutter-based food delivery app with Firebase backend, featuring seamless food ordering, real-time order tracking, and integrated payment solutions. Users can browse categorized food items, place orders, track delivery status, and manage their wallet balance. The app includes Stripe payment gateway integration for secure transactions and a dedicated admin panel for restaurant owners to manage menu items, approve orders, and monitor active users. Built with modern UI/UX principles and real-time database synchronization for optimal user experience.

Key Features:

Multi-category food browsing and ordering,
Real-time order tracking and status updates,
Secure Stripe payment integration,
Digital wallet system for quick payments,
Comprehensive admin dashboard for order management,
User-friendly interface with smooth navigation,
Firebase-powered real-time data synchronization,

Target Users: Food enthusiasts, restaurant owners, and delivery service providers looking for a complete digital food ordering ecosystem.



## Acknowledgements

 - [Flutter Team](https://flutter.dev/)
 - [Firebase Team](https://firebase.google.com/)
 - [Stripe](https://stripe.com/in)


## Authors

- [Harsh Yadav](https://github.com/harshyadavDeveloper)


## Badges

Add badges from somewhere like: [shields.io](https://shields.io/)

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Cloud Firestore](https://img.shields.io/badge/Cloud%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Stripe](https://img.shields.io/badge/Stripe-626CD9?style=for-the-badge&logo=Stripe&logoColor=white)
![REST API](https://img.shields.io/badge/REST-API-02569B?style=for-the-badge)
![MIT License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)


## Installation

Make sure you have the latest version of Flutter SDK installed on your system and Firebase CLI configured for backend services and database management.

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code
- Firebase CLI and active Firebase project
- Git installed on your system

### Steps to Run the Project

**1. Clone the Repository**
```bash
git clone https://github.com/harshyadavDeveloper/flutter-food-go.git
cd food-delivery-app
```

**2. Install Dependencies**
```bash
flutter pub get
```

**3. Firebase Setup**
```bash
# Make sure you have Firebase CLI installed and logged in
firebase login

# Initialize Firebase in your project (if not already done)
firebase init
```

**4. Configure Firebase**
- Add your `google-services.json` (Android) to `android/app/`
- Update Firebase configuration in your project
- Enable Authentication, Firestore Database, and Storage in Firebase Console

**5. Run the Application**
```bash
# For development
flutter run

# For Android device/emulator
flutter run -d android
```

**6. Build for Production**
```bash
# Android APK
flutter build apk --release
```

### Additional Setup
- **Stripe Integration:** Add your Stripe publishable key in the configuration
- **Firebase Auth:** Enable Authentication methods in Firebase Console  
- **Firestore:** Set up database rules and collections structure
- **Admin Panel:** Configure admin credentials for order management

🚀 **You're all set!** The food delivery app should now be running on your Android device/emulator.

## Screenshots
 ![On Board Screenshot](https://i.ibb.co/bM1CvZff/get-started.jpg)

![Login Screenshot](https://i.ibb.co/6LjgPCN/login.jpg)

![Register Screenshot](https://i.ibb.co/0VqsX1S8/sign-up.jpg)

![Home Screenshot](https://i.ibb.co/Pvs7Rc6H/home.jpg)

![Search Screenshot](https://i.ibb.co/PsjLG2fn/search.jpg)

![Food Detail Screenshot](https://i.ibb.co/jv64gcF4/detail.jpg)

![My Orders Page Screenshot](https://i.ibb.co/7JsgSWWs/orders.jpg)

![Wallet Screenshot](https://i.ibb.co/DP6KY081/wallet.jpg)

![Profile Screenshot](https://i.ibb.co/t1Hqdn2/profile.jpg)

![Address Screenshot](https://i.ibb.co/ZpQktW3y/address2.jpg)

![Payment Screenshot](https://i.ibb.co/5WH4F14G/payment.jpg)

![Payment Success Screenshot](https://i.ibb.co/0y6tqJTq/payment-success.jpg)

![Admin Home Page](https://i.ibb.co/SXRj5Y3G/admin-home.jpg)

![Admin All Orders Page](https://i.ibb.co/9mP58LsQ/admin-orders.jpg)

![Admin All Users Page](https://i.ibb.co/fYKC6rR6/admin-all-users.jpg)




