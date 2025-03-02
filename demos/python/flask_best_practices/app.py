from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Example LLaMA endpoint URL
LLAMA_ENDPOINT = "https://localhost:11134"

@app.route('/llama', methods=['POST'])
def llama_proxy():
    data = request.get_json()
    try:
        response = requests.post(LLAMA_ENDPOINT, json=data)
        return jsonify(response.json()), response.status_code
    except requests.exceptions.RequestException as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)

