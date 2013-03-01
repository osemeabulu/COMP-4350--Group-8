from flask import Blueprint, jsonify, render_template, request, flash
from cris import db
from model import User

mod = Blueprint('users', __name__, url_prefix='/users')

@mod.route('/')
def index():
	return render_template('users/users.html')

@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	results = User.query.all()
	return jsonify(users = [i.serialize for i in results])
