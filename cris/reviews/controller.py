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
		upvote = request.json['upvote']
		downvote = request.json['downvote']
		
		review = Review(cid, rscr, rdesc, rvote, upvote, downvote)

		db.session.add(review)
		db.session.commit()

		return jsonify(rdesc = rdesc, rscr = rscr, upvote = upvote, downvote = downvote)

@mod.route('/_query_by_course')
def query_by_course():
	key = request.args.get('key', '')

	results = Review.query.filter_by(cid=key).all()
	return jsonify(reviews = [i.serialize for i in results])
	
@mod.route('/_vote')
def calculate_vote():
	upvote = request.args.get('uvote', '')
	downvote = request.args.get('dvote', '')
	course = request.args.get('course', '')
	num = request.args.get('key', '')
	
	r = Review.query.filter_by(cid=course).all()
	review = r.pop(int(num))
	
	newvote = 0;
	
	if upvote != 'null':
		review.set_upvote(upvote)
		db.session.commit()
		newvote = review.getUpvote()

	else:
		review.set_downvote(downvote)
		db.session.commit()
		newvote = review.getDownvote()
		
	return jsonify(result=newvote)
	
	