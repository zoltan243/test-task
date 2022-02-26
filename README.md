# test_task

A simple Flutter project.

## About the project

This project is a simple get-to-know Flutter test project.

The app simply lets the user to register/sign in with email and password, as well as with google and facebook accounts.

## More details

### App Screens:
- Splash screen: which continuously checks for network connection. Jumps to the Login screen when network is available.
- Login screen: possibility to sign in/up using email and password, as well as with google and facebook accounts.
- Register screen: simple email/password registration form accessible from Login screen
- Home screen: contains a list of all registered users and a sign out button which takes the user back to the Login screen.


### Other details:
The app
- uses Firebase cloud service
- stores data in Firestore Database
- supports Firebase Cloud Messaging (notifications)