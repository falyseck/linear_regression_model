# README — Mental Health Prediction System (ML + API + Flutter App)
## Overview

This project predicts a student’s Mental Health Score based on their Social Media Addiction Score using machine learning.
It consists of three main components:

Machine Learning Model (Task 1)

FastAPI Prediction API (Task 2)

Flutter Mobile Application (Task 3)

The system is fully integrated:
Flutter → FastAPI → Saved ML Model → Prediction

## Task 1 — Machine Learning Model (Linear Regression)
###  Problem Statement

Social media addiction affects students' mental well-being. How might we monitor the impact social media has on our mental health using machine learning. 
Using the Students’ Social Media Addiction Dataset, we model the relationship:

Mental_Health_Score ← Addicted_Score
📊 Dataset

Dataset name: students_sm_addiction
Source: Kaggle – Students' Social Media Addiction by Adil Shamim

## 🎯 Objective

Build regression models to determine how well addiction score predicts mental health score.

📌 Steps Completed
✔ Exploratory Data Analysis

Computed correlations

Visualized addiction vs mental health scores

Identified a strong negative correlation → -0.94

✔ Feature Engineering

Selected only relevant numeric columns

Standardized input feature (Addicted_Score)

✔ Models Implemented

Using scikit-learn:

Linear Regression (baseline)

SGDRegressor (gradient descent–based linear regression)

Decision Tree Regressor

Random Forest Regressor

✔ Model Evaluation Metrics

Mean Squared Error (MSE)

Train vs Test Loss Curves

Model Comparison

⭐ Best Model Selected

Linear Regression had the lowest MSE.

✔ Model Saving

The best model was serialized using pickle:

lin_reg.pkl

✔ Prediction Script

A separate Python script was created to make predictions using the saved model.

## 🌐 Task 2 — FastAPI Backend
🎯 Goal

Expose a REST API endpoint that accepts an addiction score and returns a predicted mental health score.

📌 Technologies

FastAPI

Pydantic (validation)

Uvicorn

CORS Middleware

pickle (model loading)

🚀 API Endpoint

POST /predict

Request Body
{
  "addicted_score": 7.5
}

Response
{
  "predicted_mental_health_score": 5.82
}

⚙ Pydantic Validation

Ensures input is numeric

Value must be between 1 and 10

🌍 Deployment

The API was deployed to Render and includes a public Swagger UI:

https://mental-health-prediction-app-oj0d.onrender.com/docs

## 📱 Task 3 — Flutter Mobile App
🎯 Goal

Create a user-friendly mobile app that interacts with the API.

📌 Features

Clean UI with multiple screens

TextField to input addiction score

“Predict” button

Displays predicted mental health score

Error handling:

Invalid input (must be 1–10)

Missing value

API offline / connectivity error

🔗 API Integration

Flutter sends:

body: jsonEncode({
  "addicted_score": addictionScore,
});

✔ Works with CORS enabled backend
✔ Displays prediction or error message
📦 Project Structure
linear_regression_model/

│

├── summative/

│   ├── linear_regression/

│

│   │   ├── multivariate.ipynb

│   ├── API/

│   │   ├── prediction.py

│   │   ├── requirements.txt

│   ├── FlutterApp/

📄 requirements.txt (API)
fastapi
uvicorn
pydantic
numpy
scikit-learn
python-multipart

🏁 How to Run the Full System Locally
1. Start API
uvicorn main:app --reload

2. Test API

Visit:

http://127.0.0.1:8000/docs

3. Run Flutter App
flutter run

🎉 Conclusion

This system demonstrates:

Machine learning model development

Model optimization and evaluation

API deployment and integration

Mobile app consumption of ML predictions

It successfully predicts mental health scores using data-driven insights powered by regression modeling.
