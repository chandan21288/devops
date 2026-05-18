from flask import Flask
import redis

app = Flask(__name__)

cache = redis.Redis(host='redis', port=6379)

@app.route('/')

def home():

    try:
        cache.incr('hits')
        hits = cache.get('hits').decode('utf-8')

    except Exception:
        hits = "Redis not connected"

    return f"Hello from Docker Compose! Visits: {hits}"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)