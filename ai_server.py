from flask import Flask, request, jsonify, send_from_directory
import os
import uuid

app = Flask(__name__)

# Directory to store AI model input images
AI_UPLOAD_FOLDER = 'ai_uploads'
if not os.path.exists(AI_UPLOAD_FOLDER):
    os.makedirs(AI_UPLOAD_FOLDER)

app.config['AI_UPLOAD_FOLDER'] = AI_UPLOAD_FOLDER

# Route for uploading images to AI model
@app.route('/ai_upload', methods=['POST'])
def ai_upload():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400

    # Generate a unique filename
    unique_filename = f"{uuid.uuid4().hex}_{file.filename}"
    file_path = os.path.join(app.config['AI_UPLOAD_FOLDER'], unique_filename)
    file.save(file_path)

    # Generate a local-access URL
    file_url = f"http://127.0.0.1:5001/ai_uploads/{unique_filename}"
    return jsonify({"url": file_url}), 200

# Route for retrieving uploaded images
@app.route('/ai_uploads/<filename>', methods=['GET'])
def get_uploaded_ai_image(filename):
    return send_from_directory(app.config['AI_UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(port=5001, debug=True)
