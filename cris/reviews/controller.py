from flask import Blueprint, jsonify, render_tamplate, request
from model import Review

mod = Blueprint('reviews', __name__, url_prefix='/reviews')

@mod.rout('/_query_by_course')
def query_by_course():
	key = request.args.get('key', '')

	results = Review.query.filter_by(cid=key).all()
	return jsonify(reviews = [i.serialize for i in results])
