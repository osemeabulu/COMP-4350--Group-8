from flask import Blueprint, jsonify, render_template, request, flash, abort
from cris import db
from model import Instructor

mod = Blueprint('instructors', __name__, url_prefix='/instructors')

@mod.route("/")
def index():
	return render_template('instructors/instructors.html')

@mod.route('/<string:instructor>')
def show_instructor(instructor):
	result = Instructor.query.filter_by(pname = instructor).first()

	if result:
		return render_template('instructors/show_instructor.html', instructor=result)
	else:
		abort(404) 

@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	if key == '':
		results = Instructor.query.all()
		return jsonify(instructors = [i.serialize for i in results])
	else:
		results = Instructor.query.filter("pname like :value").params(value = '%' + key + '%').all()
		return jsonify(instructors = [i.serialize for i in results])
