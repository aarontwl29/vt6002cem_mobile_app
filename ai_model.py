from flask import Flask, request, jsonify
import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.applications.resnet50 import ResNet50, preprocess_input
from tensorflow.keras.preprocessing import image
from sklearn.metrics.pairwise import cosine_similarity
import cv2

app = Flask(__name__)

# Initialize the AI model (ResNet50)
model = ResNet50(weights="imagenet", include_top=False, pooling="avg")

# Directory storing reported case images
UPLOAD_FOLDER = "uploads"
AI_UPLOAD_FOLDER = "ai_uploads"

if not os.path.exists(AI_UPLOAD_FOLDER):
    os.makedirs(AI_UPLOAD_FOLDER)

# Dictionary to store precomputed image feature vectors
image_database = {}  # Format: { "image_path": feature_vector }

# Function to extract features from an image
def extract_features(img_path):
    img = image.load_img(img_path, target_size=(224, 224))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)
    img_array = preprocess_input(img_array)
    
    features = model.predict(img_array)
    return features.flatten()

# Precompute features for all stored images

def load_image_database():
    global image_database
    image_database = {}
    for filename in os.listdir(UPLOAD_FOLDER):
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        try:
            features = extract_features(file_path)
            image_database[file_path] = features
            print(f"✅ Stored Features for: {filename}")  # Debugging line
        except Exception as e:
            print(f"❌ Skipping invalid image: {filename} - {e}")
            
load_image_database()  # Run once at startup




# Route to match images
@app.route("/match_image", methods=["POST"])
def match_image():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400
    
    file = request.files["file"]
    if file.filename == "":
        return jsonify({"error": "No file selected"}), 400

    # Save uploaded file temporarily
    temp_path = os.path.join(AI_UPLOAD_FOLDER, file.filename)
    file.save(temp_path)

    # Extract features of uploaded image
    uploaded_features = extract_features(temp_path)

    # Compute similarity with all stored images
    similarities = []
    print("\n🔍 Computing Similarities:\n")
    for img_path, stored_features in image_database.items():
        sim_score = cosine_similarity([uploaded_features], [stored_features])[0][0]
        print(f"📸 Comparing with {img_path} - Similarity: {sim_score:.4f}")
        similarities.append((img_path, sim_score))

    # Sort results by similarity (descending order)
    similarities.sort(key=lambda x: x[1], reverse=True)

    # Print all similarity scores before filtering
    print("\n🔍 Similarity Scores:")
    for img, score in similarities:
        print(f"{img}: {score:.4f}")

    # Filter top 5 matches with similarity above 50%
    top_matches = [
        {"image": img_path, "similarity": float(round(sim * 100, 2))}
        for img_path, sim in similarities if sim > 0.50
    ][:5]

    print("\n✅ Top Matches Found:")
    for match in top_matches:
        print(match)

    return jsonify({"matches": top_matches}), 200


if __name__ == "__main__":
    app.run(port=5002, debug=True)
