from flask import Blueprint, jsonify, render_template, request, redirect, url_for, abort
from model import Course

mod = Blueprint('courses', __name__, url_prefix='/courses')

@mod.route("/")
def index():
	print "Courses route worked"
	return render_template('courses/courses.html')

@mod.route('/<string:course>')
def show_course(course):
  print course
  results = Course.query.filter_by(cid=course).first()
  if results:
    return render_template('courses/show_course.html', course=results)
  else:
    abort(404)

@mod.route('/_query')
def query():
	key = request.args.get('key', '')
	
	if key == '':
		results = Course.query.all()
		return jsonify(courses = [i.serialize for i in results])
	else:
		results = Course.query.filter("cid like :value or cname like :value").params(value = '%' + key + '%').all()
		return jsonify(courses = [i.serialize for i in results])
	
