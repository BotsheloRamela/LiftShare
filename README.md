# LiftShare

## Project Description

The LiftShare app is designed to make it easy for users to organize or join rides to specific destinations, particularly aimed at helping students and individuals with budget constraints. The app allows users to offer lifts, search for available lifts, confirm or cancel rides, and includes features for notifications and onboarding.

## Technologies Used

- **Flutter**: The app is built using the Flutter framework for cross-platform mobile development.
- **Firebase**: Used for backend services, including authentication and real-time database functionality.
- **PayStack**: Integrated for payment processing within the app.
- **Google Maps API**: Utilized to enhance location-based features.
- **MVVM Architecture**: The app follows the Model-View-ViewModel architectural pattern for a scalable and maintainable codebase.

## Project Structure
```
lib
|-- app
|   |-- main.dart
|-- data
|   |-- models
|   |   |-- user.dart
|   |   |-- lift.dart
|   |   |-- notification.dart
|   |-- repositories
|   |   |-- user_repository.dart
|   |   |-- lift_repository.dart
|   |   |-- notification_repository.dart
|-- ui
|   |-- screens
|   |   |-- onboarding
|   |   |   |-- register_screen.dart
|   |   |   |-- login_screen.dart
|   |   |   |-- reset_password_screen.dart
|   |-- lift
|   |   |-- offer_lift_screen.dart
|   |   |-- update_lift_screen.dart
|   |   |-- view_offered_lifts_screen.dart
|   |-- search
|   |   |-- view_available_lifts_screen.dart
|   |   |-- search_lift_screen.dart
|   |   |-- view_lift_details_screen.dart
|   |-- confirm_cancel
|   |   |-- confirm_joining_lift_screen.dart
|   |   |-- view_confirmed_lifts_screen.dart
|   |   |-- cancel_booking_screen.dart
|   |   |-- cancel_offered_lift_screen.dart
|-- utils
|   |-- constants.dart
|   |-- routes.dart
|-- viewmodels
|   |-- onboarding_viewmodel.dart
|   |-- lift_viewmodel.dart
|   |-- search_viewmodel.dart
|   |-- confirm_cancel_viewmodel.dart
|-- services
|   |-- authentication_service.dart
|   |-- firebase_service.dart
|   |-- paystack_service.dart
|   |-- google_maps_service.dart
|   |-- in_app_messaging_service.dart
|-- main.dart

```

Explanation:

- `app`: Contains the main file (main.dart) that initializes the app.
- `data`: Manages data-related concerns such as models and repositories.
    - `models`: Data models representing entities like User, Lift, and Notification.
    - `repositories`: Classes responsible for handling data operations for each entity.
- `ui`: Contains UI-related components, organized by screens and functionality.
- `screens`: Divided into subfolders based on the user journey or feature.
- `utils`: Houses constants and route definitions.
- `viewmodels`: Manages the application's logic, following the MVVM pattern.
- `services`: Handles external services like Firebase, PayStack, Google Maps, and in-app messaging.



## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Firebase Project](https://console.firebase.google.com/): Set up a project on Firebase and configure the necessary services.
- [PayStack API Key](https://dashboard.paystack.com/): Obtain an API key for payment processing.
- [Google Maps API Key](https://cloud.google.com/maps-platform/): Get an API key for using Google Maps services.

### Environment Variables

Create a `.env` file in the root directory of the project and add the following:

```env
# Firebase Configuration
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_PROJECT_ID=your_firebase_project_id
FIREBASE_AUTH_DOMAIN=your_firebase_auth_domain
FIREBASE_DATABASE_URL=your_firebase_database_url
FIREBASE_STORAGE_BUCKET=your_firebase_storage_bucket
FIREBASE_MESSAGING_SENDER_ID=your_firebase_messaging_sender_id
FIREBASE_APP_ID=your_firebase_app_id

# PayStack Configuration
PAYSTACK_API_KEY=your_paystack_api_key

# Google Maps Configuration
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

```

Replace the placeholder values with your actual API keys and Firebase configuration.

## Running the App
1. Clone the repository: `git clone https://github.com/BotsheloRamela/LiftShare.git`
2. Navigate to the project directory: `cd LiftShare`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`
