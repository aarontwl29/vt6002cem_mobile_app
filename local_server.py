from flask import Flask, request, jsonify, send_from_directory
import os
import uuid

app = Flask(__name__)

# Directory to store uploaded images
UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Route for uploading images
@app.route('/upload', methods=['POST'])
def upload_image():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400

    # Generate a unique filename
    unique_filename = f"{uuid.uuid4().hex}_{file.filename}"
    
    file_path = os.path.join(app.config['UPLOAD_FOLDER'], unique_filename)
    file.save(file_path)

    # Generate a URL for accessing the file
#    file_url = f"http://localhost:5000/uploads/{unique_filename}"
    file_url = f"http://127.0.0.1:5000/uploads/{unique_filename}"
    return jsonify({"url": file_url}), 200

# Route for serving uploaded images
@app.route('/uploads/<filename>', methods=['GET'])
def get_uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(debug=True)
