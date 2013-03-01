from flask import Blueprint, jsonify, render_template, request, flash
from cris import db
from model import Instructor

mod = Blueprint('instructors', __name__, url_prefix='/instructors')

@mod.route('/_query_instructors')
def query():
	key = request.args.get('key', '')

	if key == '':
		results = Instructor.query.all()
		return jsonify(instructors = [i.serialize for i in results])
	else:
		results = Instructor.query.filter("tname like :value").params(value = '%' + key + '%').all()
		return jsonify(instructors = [i.serialize for i in results])
