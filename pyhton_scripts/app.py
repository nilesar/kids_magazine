from flask import Flask, request, jsonify, send_file
from gtts import gTTS
import os
import traceback

app = Flask(__name__)

output_dir = os.path.join(os.path.dirname(__file__), "python_scripts")
os.makedirs(output_dir, exist_ok=True)

@app.route('/generate_speech', methods=['POST'])
def generate_speech():
    try:
        data = request.get_json()
        text = data.get('text')
        language = data.get('language', 'en')

        if not text:
            return jsonify({"error": "Text is required"}), 400
        file_path = os.path.join(output_dir, "output.mp3")
        tts = gTTS(text=text, lang=language, slow=False)
        tts.save(file_path)

        
        if not os.path.exists(file_path):
            return jsonify({"error": "Failed to generate MP3"}), 500
        
        return send_file(file_path, mimetype="audio/mpeg")

    except Exception as e:
        error_message = str(e)
        traceback.print_exc() 
        return jsonify({"error": error_message}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
