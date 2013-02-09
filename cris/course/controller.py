from flask import Blueprint, jsonify, render_template, request

from model import Course

course = Blueprint('course', __name__, url_prefix='/')

@course.route("/courses")
def courses():
	print "Courses route worked"
	return render_template('courses.html')

@course.route('/courses/_query')
def search():
	query = request.args.get('seach_key', '')
	
	result = None

	if cmp(query, '') == 0:
		result = Course.query.all()

	else:
		result = Course.query.filter(Course.cid.startswith(query)).all()
		
		if (result is None):
			result = Course.query.filter(Course.cname.startswith(query)).all()


	return jsonify(result)
