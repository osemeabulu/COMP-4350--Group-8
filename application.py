#!/usr/bin/env python

from flask import *
from flask.ext.sqlalchemy import SQLAlchemy

# The WSGI configuration on Elastic Beanstalk requires 
# the callable be named 'application' by default.
application = Flask(__name__)
application.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
db = SQLAlchemy(application)

class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    cid = db.Column(db.String(10), unique=True)
    cname = db.Column(db.String(20), unique=True)

    def __init__(self, cid, cname):
        self.cid = cid
        self.cname = cname

    def __repr__(self):
        return '<Course %r>' % self.cname
        
@application.route("/")
def index():
    return render_template('index.html');

if __name__ == '__main__':
    application.debug = True
    application.run(host='0.0.0.0')
