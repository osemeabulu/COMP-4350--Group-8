from flask import Blueprint, jsonify, render_template, request

from model import Course
from cris import db

mod = Blueprint('courses', __name__, url_prefix='/courses')

@mod.route("/")
def index():
	print "Courses route worked"
	return render_template('courses/courses.html')

@mod.route('/_query')
def query():
	#c1 = Course('Comp4350', 'Software Engineering 2')
	#c2 = Course('Comp2150', 'Object Orientation')
	results = Course.query.all()
	#return jsonify(courses = [c1.serialize, c2.serialize])
	return jsonify(courses = [i.serialize for i in results])
