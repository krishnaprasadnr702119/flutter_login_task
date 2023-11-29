api_helper.dart
----------------

Token Management:
----------------

getStoredAccessToken() and getStoredRefreshToken() retrieve stored tokens from SharedPreferences.
storeAccessToken() and storeRefreshToken() store tokens in SharedPreferences.
removeTokens() removes tokens from SharedPreferences.

Authentication and Authorization:
--------------------------------

refreshToken() handles token refreshing using the refresh token. It sends a POST request to the server to get a new access token.
signIn() sends user credentials (email, password) to the server for authentication.
signUp() sends user details (email, username, password) to the server for registration.
Fetching Protected Data:

getProtectedData() uses the stored access token to fetch protected data from the server.

signup.dart
-----------

User Registration:
------------------

Validates user input for username, email, and passwords.
Checks password strength and whether passwords match.
Utilizes SharedPreferences to check username availability.
Invokes ApiHelper.signUp() to register a new user and handles success/failure via dialogs.

login.dart
-----------

User Login:

Validates user input for email and password.
Invokes ApiHelper.signIn() to authenticate the user and handles success/failure via dialogs.
dashboard.dart

Dashboard Display:
-----------------

Contains a widget (Dashboard) to display protected data fetched using ApiHelper.getProtectedData().
Updates the UI using setState() when fetching protected data.

CoverPage.dart
---------------

Landing Page:
-------------

Provides a landing page (CoverPage) with options to navigate to the login or signup screens.
Uses Navigator to move to the respective screens (Login or Signup).

Technical Components Explored:
HTTP Requests:

Utilizes http package methods (post, get) to communicate with the server endpoints for authentication, registration, and data fetching.
State Management:

Uses setState() to update the UI after fetching data or performing actions like registration/login.
Input Validation:

Implements validation checks to ensure proper data entry, like password strength, matching passwords, and username availability.
Local Data Storage (SharedPreferences):

Stores and retrieves user tokens and some user data locally using SharedPreferences.
Navigation:

Implements navigation between different screens within the app using Navigator.
Together, these components establish a structured authentication flow, allowing users to register, log in, and access protected data. The code utilizes HTTP requests, handles user inputs, manages local data storage, and navigates between screens for a complete user experience within the app.
