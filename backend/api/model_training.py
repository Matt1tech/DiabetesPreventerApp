import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.impute import SimpleImputer
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import joblib
import os





# Data Collection
# Load the datasets
data1 = pd.read_csv('training_data_file.csv')
data2 = pd.read_csv('diabetes.csv')




# Data Preprocessing
# No common key, we'll merge on indices
data1.reset_index(inplace=True)
data2.reset_index(inplace=True)
# Merge the datasets on index and include 'Glucose' from the second dataset
merged_data = pd.merge(data1, data2[['index', 'DiabetesPedigreeFunction', 'Glucose']], 
                       left_on='index', 
                       right_on='index', how='left')

# Drop the index column
merged_data.drop(columns=['index', 'level_0'], inplace=True, errors='ignore')

# Drop the specified columns
columns_to_drop = ['Stroke', 'Smoker', 'HeartDiseaseorAttack', 
                   'HvyAlcoholConsump', 'Education', 
                   'Income', 'NoDocbcCost', 'CholCheck', 'AnyHealthcare', 
                   'DiffWalk']
merged_data.drop(columns=columns_to_drop, inplace=True)

# Handle missing values
imputer = SimpleImputer(strategy='mean')
merged_data = pd.DataFrame(imputer.fit_transform(merged_data), columns=merged_data.columns)



# Feature Engineering
# Add a binary family history feature
merged_data['FamilyHistory'] = merged_data['DiabetesPedigreeFunction'].apply(lambda x: 1 if x > 0 else 0)

# Select features and target
features = merged_data.drop(columns=['Diabetes_012'])
target = merged_data['Diabetes_012']

# Display the features used in the model
print("Model Features:\n", features.columns.tolist())



#Algorithm Selection 
# Choosing a Machine Learning Algorithm
# RandomForestClassifier is chosen 
# Model Training
# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(features, target, test_size=0.2, random_state=42)

# Train the model using Random Forest
rf = RandomForestClassifier(random_state=42)
rf.fit(X_train, y_train)



# Model Validation
# Evaluate the model
y_pred = rf.predict(X_test)

# Output evaluation metrics
print("Accuracy:", accuracy_score(y_test, y_pred))
print("Classification Report:\n", classification_report(y_test, y_pred))

# Additional evaluation metrics
accuracy = accuracy_score(y_test, y_pred)
classification_rep = classification_report(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)