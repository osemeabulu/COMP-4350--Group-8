from flask import Blueprint, jsonify, render_template, request, redirect, url_for, abort
from model import Course, Review

mod = Blueprint('courses', __name__, url_prefix='/courses')

@mod.route("/")
def index():
	#print "Courses route worked"
	return render_template('courses/courses.html')

@mod.route('/<string:course>')
def show_course(course):
  #print course
  result = Course.query.filter_by(cid=course).first()
  
  if result:
    return render_template('courses/show_course.html', course=result)
  else:
    abort(404)

#already have a top rated route without courses prefix
#@mod.route('/top_rated')
#def top_index():
#	return render_template('courses/top_rated.html')

@mod.route('/_top_query')
def top_query():
	list = []	
	index = 0
	courses_list = Course.query.all()
	for course in courses_list:
		reviews_list = Review.query.filter_by(cid=course.cid).all()
		average = 0
		if len(reviews_list) > 0:
			for review in reviews_list:
				average = average + review.rscr
			average = average / len(reviews_list)
		list.append([course, average])
	list = sorted(list, key=lambda tup: tup[1], reverse=True)
	courses = []
	for item in list:
		temp_dict = item[0].serialize
		temp_dict['avg'] = item[1]
		courses.append(temp_dict)
	return jsonify(courses = courses) 

@mod.route('/_query')
def query():
	key = request.args.get('key', '')
	
	if key == '':
		results = Course.query.all()
		return jsonify(courses = [i.serialize for i in results])
	else:
		results = Course.query.filter("cid like :value or cname like :value").params(value = '%' + key + '%').all()
		return jsonify(courses = [i.serialize for i in results])
