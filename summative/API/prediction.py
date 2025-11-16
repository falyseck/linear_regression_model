from fastapi import FastAPI
from pydantic import BaseModel, Field
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
import os


# Load Model

model_path = os.path.join(os.path.dirname(__file__), "lin_reg.pkl")
model = joblib.load(model_path)

# Initialize FastAPI app

app = FastAPI(
    title="Mental Health Prediction API",
    description="Predict Mental Health Score from Social Media Addiction Score",
    version="1.0"
)


# CORS Middleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Pydantic Input Model

class PredictionInput(BaseModel):
    addicted_score: float = Field(
        ..., 
        ge=1, 
        le=10,
        description="Social Media Addiction Score (1 to 10)"
    )


# Routes

@app.get("/")
def home():
    return {"message": "Welcome to the Mental Health Prediction API"}

@app.post("/predict")
def predict(data: PredictionInput):
    # Convert input to numpy array
    input_array = np.array([[data.addicted_score]])

    # Make prediction
    prediction = model.predict(input_array)[0]

    return {
        "addicted_score": data.addicted_score,
        "predicted_mental_health_score": round(float(prediction), 2)
    }
