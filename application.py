#!/usr/bin/env python

from flask import *
from cris.course import course, Course
import cris.utils

from flask.ext.sqlalchemy import SQLAlchemy

# The WSGI configuration on Elastic Beanstalk requires 
# the callable be named 'application' by default.
application = Flask(__name__)
#application.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
#application.config['SECRET_KEY'] = 'development key';
#db = SQLAlchemy(application)


@application.route("/")
def index():
	return render_template('index.html')

@application.route("/courses", methods=['GET', 'POST'])
def courses():
    if request.method == 'POST':
		flash('We would process your search but we are not beefed up yet')
    return render_template('courses.html')

@application.route("/top_rated")
def top_rated():
	return render_template('top_rated.html')

@application.route("/program_planner")
def program_planner():
    return render_template('program_planner.html')

@application.route("/instructors")
def instructors():
    return render_template('instructors.html')

@application.route("/about")
def about():
    return render_template('about.html')

@application.route("/contact")
def contact():
    return render_template('contact.html')

@application.route("/_query")
def query():
	c = Course('Comp4350', 'Software Engineering 2')
	return jsonify(cid=c.cid, cname=c.cname)
	
if __name__ == '__main__':
	cris.utils.init(application)
	application.register_blueprint(course)
	application.debug = True
	application.run(host='0.0.0.0')

