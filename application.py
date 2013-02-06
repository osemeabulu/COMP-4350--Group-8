#!/usr/bin/env python

from flask import *

# The WSGI configuration on Elastic Beanstalk requires 
# the callable be named 'application' by default.
application = Flask(__name__)

@application.route("/")
def index():
    return render_template('index.html');

if __name__ == '__main__':
    application.debug = True
    application.run(host='0.0.0.0')
