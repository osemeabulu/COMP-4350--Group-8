from flask import Blueprint, jsonify, render_template, request, flash
from cris import db
from model import Instructor

mod = Blueprint('instructors', __name__, url_prefix='/instructors')

@mod.route("/")
def index():
	print "Instructors route worked"
	return render_template('instructors/instructors.html')

@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	if key == '':
		results = Instructor.query.all()
		return jsonify(instructors = [i.serialize for i in results])
	else:
		results = Instructor.query.filter("pname like :value").params(value = '%' + key + '%').all()
		return jsonify(instructors = [i.serialize for i in results])
