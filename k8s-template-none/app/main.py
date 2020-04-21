# pylint: disable=no-member
from flask import Flask
from flask_cors import CORS
from os import getenv

service = getenv('API_SERVICE_HOST')

app = Flask(__name__)
CORS(app)

@app.route('/')
def hello():
    return 'Hello {}'.format(service)
