# model_utils.py
import joblib
import os

# Define the path to the model file relative to this file
MODEL_PATH = os.path.join(os.path.dirname(__file__), 'diabetes_prediction_model.pkl')

def load_model():
    if os.path.exists(MODEL_PATH):
        return joblib.load(MODEL_PATH)
    else:
        raise FileNotFoundError(f"Model file not found at {MODEL_PATH}")

model = load_model()