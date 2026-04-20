from flask import Flask, jsonify
import os

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
APP_ENV = os.getenv("APP_ENV", "development")


@app.route("/")
def index():
    return jsonify({
        "message": "CI/CD Demo App",
        "version": APP_VERSION,
        "environment": APP_ENV,
    })


@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200


@app.route("/ready")
def ready():
    return jsonify({"status": "ready"}), 200


if __name__ == "__main__":
    port = int(os.getenv("PORT", 8080))
    app.run(host="0.0.0.0", port=port)
