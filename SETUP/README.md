# Kisan Queue - Modified Prototype

This bundle contains the complete replacement Dart files for the requested prototype changes.

## Included changes
1. Employee ID replaces Owner ID in the login UI.
2. Farmer and Employee sessions persist with SharedPreferences until Logout.
3. Employee Dashboard shows registered farmers and booked customers.
4. Notification and location permissions are requested at login.
5. Every booking creates an official in-app message and a local notification.
6. Every booking has 5 employee-controlled steps:
   - Process Started
   - Quality Checked
   - Price Confirmed
   - Weight Confirmed
   - Process Completed
   Completed steps show check marks to the farmer.
7. When a process starts, the farmer five positions later receives a queue message (example: token 3 checked in -> token 8 is alerted).
8. When a farmer's process completes, that farmer gets a completion message and the next queued farmer gets a "Your Turn Has Arrived" message.
9. Employee Dashboard includes an SMS button that opens the phone's SMS composer with an official message pre-filled.

## Important SMS limitation
A Flutter app alone cannot guarantee silent, automatic SMS delivery to another person's phone number. The included SMS action opens the device SMS composer with the message pre-filled. True automatic SMS requires an SMS gateway/backend (for example, a server-side provider) and credentials.

The in-app Messages & Alerts page and local notifications work without a backend and are intended for the hackathon prototype.

## Exact files to replace
Copy the files under `lib/` into the same paths in your Flutter project:

- lib/main.dart
- lib/services/farmer_data.dart
- lib/services/farmer_session.dart
- lib/services/notification_service.dart (new)
- lib/services/permission_service.dart (new)
- lib/services/message_service.dart (new)
- lib/screens/login_page.dart
- lib/screens/owner_dashboard.dart
- lib/screens/queue_page.dart
- lib/screens/alerts_page.dart

Do not delete the other existing screens/assets.

## Dependencies
Open your existing `pubspec.yaml` and add the dependencies shown in `pubspec_dependencies.txt`.

## Android permissions
Open:
`android/app/src/main/AndroidManifest.xml`

Add the lines from `android/AndroidManifest_additions.xml` inside the `<manifest>` element.

## Run
From the project root:

flutter clean
flutter pub get
flutter analyze
flutter test
flutter run

## Test flow
1. Login as Farmer with any 10-digit mobile number.
2. Accept notification and location permissions.
3. Book a slot.
4. Verify the booking notification and Messages & Alerts entry.
5. Logout.
6. Login as Employee using the existing prototype employee credentials.
7. Confirm the booked customer appears in Booked Customers.
8. Tap Mark Process Started, then continue through all five steps.
9. Verify farmer-side step check marks and message updates.
10. Create enough bookings to test the five-position queue alert.
11. Close and reopen the app without Logout. The last session should reopen automatically.
12. Use Logout to clear the saved session and return to login.
