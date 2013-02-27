from flask import Blueprint, jsonify, render_template, request
from cris import db
from model import Review

mod = Blueprint('reviews', __name__, url_prefix='/reviews')

@mod.route('/_submit_review')
def submit_review():
	data = request.json;
	review = Review(
			data['cid'],
			data['rscr'],
			data['rdesc'],
			data['rvote'])

	db.session.add(review)
	db.session.commit()

	flash('Review received and processed')

@mod.route('/_query_by_course')
def query_by_course():
	key = request.args.get('key', '')

	results = Review.query.filter_by(cid=key).all()
	return jsonify(reviews = [i.serialize for i in results])
