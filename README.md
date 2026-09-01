# Diabetes Preventer

Diabetes Preventer is a Flutter mobile application with a Django REST backend
for health tracking, meals, activity, reports, experimental diabetes-risk
prediction, and food-image analysis.

> This project is informational and educational. It is not a medical device,
> diagnosis, or substitute for professional medical care.

## Public repository status

This clean repository excludes personal uploads, databases, credentials, FYP
submissions, datasets, and the trained model. Read
`docs/DEVELOPMENT_HISTORY.md`, `docs/PRIVATE_STORAGE.md`, `SECURITY.md`, and
`docs/PUBLIC_RELEASE_CHECKLIST.md` before deployment or publication.

## Historical product overview

**Project Description**
Diabetes Preventer Application is a mobile application developed using Flutter and Dart for the frontend, and Django with Python for the backend. The application helps users monitor their health, track daily meals, and generate reports for their daily activities and health records. It includes a machine learning model powered by a Random Forest algorithm to predict the risk of diabetes based on user data.

The backend supports local SQLite development and PostgreSQL deployment through
environment configuration.

**Features**
Health Monitoring: Track daily health metrics and activities.
Meal Tracking: Record and monitor daily meals and nutritional intake.
Report Generation: Generate detailed reports on daily activities and health records.
Diabetes Risk Prediction: Predict the risk of diabetes using a machine learning model based on Random Forest.
Admin Console: Manage users, view analytics, and more through the admin panel.
API Integration: Integrate the application’s endpoints with other projects easily.
Directory Structure
Here's a brief overview of the directory structure:

**Frontend (Flutter)**
lib/Pages:
Contains various Dart files representing different pages of the application, such as login_page.dart, home_page.dart, meal_records_page.dart, etc.
lib/services:
Contains service files that interact with the backend, such as AuthService, MealRecordsService, RecommendationService, etc.
lib/utils:
Utility functions and constants used across the app.
lib/models:
Data models representing the structure of various entities like meals, user customizations, health records, etc.
Backend (Django)
backend/api:
Contains all the API views and serializers related to the application's functionalities.
`.private/backend_media` stores local user uploads, and `.private/database`
stores local databases. Neither location is published.

## Installation

### Prerequisites
Flutter and Dart: Ensure Flutter and Dart are installed for the frontend development.
Python and Django: Install Python and Django for backend development.
Machine Learning Libraries: Install necessary Python libraries such as pandas, scikit-learn, joblib, and others listed in requirements.txt.

### Backend configuration

Create `.private/.env` from `backend/.env.example`, set a strong
`DJANGO_SECRET_KEY`, install `backend/requirements.txt`, then run migrations.
The private model defaults to
`.private/models/diabetes_prediction_model.pkl`; model endpoints remain
unavailable until a trusted model is supplied.




**Usage Instructions**
Frontend:
Run Flutter with a public runtime API address, for example:

`flutter run --dart-define=DIABETES_API_BASE_URL=http://10.0.2.2:8000`

Never place credentials in Flutter or `--dart-define`; mobile binaries can be
inspected.
Backend:
Ensure the Django server is running. The frontend will interact with the backend via the provided API endpoints.
API Documentation
The application provides various API endpoints for user management, health monitoring, meal tracking, and report generation.

User Management and Authentication:
Register User: POST /create_user/ - Registers a new user.
Login: POST /login/ - Authenticates a user and returns JWT tokens.
Logout: POST /logout/ - Logs out the user by invalidating tokens.
Update User Profile: PUT /update_user/ - Updates the user's profile information.
Risk Analysis:

Monthly Risk: GET /monthly_risk/{user_id}/ - Calculates the average diabetes risk for each month over the past six months for the specified user.
Test Model: POST /test_model/ - Tests the machine learning model with provided input features.
Meal Records:

Create Meal: POST /create_meal/ - Creates a new meal record for the user.
Get Total Daily Nutrition: GET /get_total_daily_nutrition/{user_id}/ - Retrieves the total nutritional intake for the current day.
Dietary Planner and Meal Recommendations:

Update Customizations: POST /update_customizations/ - Updates or creates user customizations for dietary and meal preferences.
Get User Customization: GET /get_user_customization/{user_id}/ - Retrieves the customization settings for a specified user.
User Recommendations: GET /user_recommendation/{user_id}/ - Provides personalized meal recommendations based on user preferences and health data.
Lifestyle and Health Analysis:

Create or Update Health Record: POST /create_or_update_health_record/ - Creates or updates a health record for the user.
Get Last Health Record: GET /get_last_health_record/{user_id}/ - Retrieves the latest health record for the user.
Report Module:

Get Physical Activity Report: GET /get_physical_activity_report/{user_id}/ - Retrieves a report of the user’s physical activities.
Get Risk Summary Report: GET /get_risk_summary_report/{user_id}/ - Retrieves a summary report of the user's health risks.
Get Health Summary Report: GET /get_health_summary_report/{user_id}/ - Retrieves a detailed health summary report for the user.
Contributing Guidelines
Guidelines:

Follow the standard Git branching model (feature, develop, main branches).
Ensure all code is tested before submitting a pull request.
Write clear and concise commit messages.
Reporting Issues:
Submit issues via the GitHub issue tracker.
Provide detailed information about the issue, including steps to reproduce and any relevant logs.




## License

Software code is licensed under [MIT](LICENSE). Private FYP materials are
excluded, and documentation rights are described in
[LICENSE_SCOPE.md](LICENSE_SCOPE.md).

Credits or Acknowledgments
Developer: Albukaai Mohamad
Frontend Framework: Built using Flutter and Dart.
Backend Framework: Developed using Django and Python.
Machine Learning Model: Implemented using scikit-learn’s Random Forest algorithm.
Contact and security reports are handled through the maintainer's GitHub profile.
