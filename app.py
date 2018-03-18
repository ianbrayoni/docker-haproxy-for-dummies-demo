from flask import Flask
from redis import Redis
import os
import socket
app = Flask(__name__)
redis = Redis(host='redis', port=6379)
host = socket.gethostname()

@app.route('/')
def hello():
    redis.incr('hits')
    hits = (redis.get('hits')).decode('utf-8')
    return '<h2>Hello World!</h2><p>I have been seen %s times.</p><p><i>My hostname is <b>%s</b>.</i></p>' % (hits ,host)

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
