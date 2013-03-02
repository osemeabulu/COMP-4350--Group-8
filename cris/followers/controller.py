from flask import Blueprint, jsonify, render_template, request, flash
from model import Follower

mod = Blueprint('followers', __name__, url_prefix='/followers')

@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	results = Follower.query.all()
	return jsonify(followers = [i.serialize for i in results])

#next try to query for by user (fetch logged in user?
