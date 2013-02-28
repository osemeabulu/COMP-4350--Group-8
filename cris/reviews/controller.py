from flask import Blueprint, jsonify, render_template, request, flash
from cris import db
from model import Review

mod = Blueprint('reviews', __name__, url_prefix='/reviews')

@mod.route('/_submit_review', methods=['POST'])
def submit_review():
	if request.method == 'POST':
		data = request.json
		print data

		cid = request.json['cid']
		rscr = request.json['rscr']
		rdesc = request.json['rdesc']
		rvote = request.json['rvote']
		
		review = Review(cid, rscr, rdesc, rvote)

		db.session.add(review)
		db.session.commit()

		return ''

@mod.route('/_query_by_course')
def query_by_course():
	key = request.args.get('key', '')

	results = Review.query.filter_by(cid=key).all()
	return jsonify(reviews = [i.serialize for i in results])
