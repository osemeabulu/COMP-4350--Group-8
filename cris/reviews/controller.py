from flask import Blueprint, jsonify, render_template, request, flash, session
from cris import db
from model import Review
from decimal import *
from cris.users.controller import check_follower
from cris.users.model import User

mod = Blueprint('reviews', __name__, url_prefix='/reviews')

@mod.route('/_submit_review', methods=['POST'])
def submit_review():
	if request.method == 'POST':
		data = request.json
		#print data

		cid = request.json['cid']
		rscr = request.json['rscr']
		rdesc = request.json['rdesc']
		rvote = request.json['rvote']
		upvote = request.json['upvote']
		downvote = request.json['downvote']
		
		#find username if logged in		
		username = None
		if 'username' in session:
			username = session['username']
		review = Review(cid, rscr, rdesc, rvote, upvote, downvote, username)

		db.session.add(review)
		db.session.commit()

		return jsonify(rdesc = rdesc, rscr = rscr, rvote=rvote, upvote = upvote, downvote = downvote)

@mod.route('/_query_by_course')
def query_by_course():
	results = []
	following = []
	temp_dict = {}

	key = request.args.get('key', '')
	reviews = Review.query.filter_by(cid=key).all()
	
	if 'username' in session:
		curr_user = User.query.get(session['username'])
		if curr_user != None:
			following = curr_user.get_followers()
		
		if len(reviews) > 0:
			for review in reviews:
				temp_dict = review.serialize
				if review.username is not None:
					review_user = User.query.get(review.username)
					if len(following) > 0 and review_user in following:
						temp_dict['followed'] = True
					else:					
						temp_dict['followed'] = False
				else:
					temp_dict['followed'] = False
				results.append(temp_dict)
 	 		#first sort by the review rating tuple
			results = sorted(results, key=lambda k: k['rvote'], reverse=True)
			#second sort by the review followed tuple
			if len(following) > 0:
				results = sorted(results, key=lambda k: k['followed'], reverse=True)			
	else:
		if len(reviews) > 0:
			for review in reviews:
				temp_dict = review.serialize
				temp_dict['followed'] = False
				results.append(temp_dict)
 	 		#only sort by the review rating tuple
			results = sorted(results, key=lambda k: k['rvote'], reverse=True)
			
	return jsonify(reviews = results)


@mod.route('/_query_by_user')
def query_by_user():
	key = request.args.get('key', '')
	results = Review.query.filter_by(username=key).all()

	return jsonify(reviews = [i.serialize for i in results])
	
@mod.route('/_vote', methods=['POST'])
def calculate_vote():
	
	if request.method == 'POST':
		data = request.json		
		#print data
		
		pk = request.json['key']
		num = request.json['index']
		upvote = request.json['upvote']
		downvote = request.json['downvote']
		
		r = Review.query.get(pk)
		
		if upvote is not None:
			upvote+=1
			r.upvote = upvote
			db.session.commit()

		else:
			downvote+=1
			r.downvote = downvote
			db.session.commit()
	
		getcontext().prec = 2
					
		if r.downvote:
			r.rvote = Decimal(r.upvote)/Decimal(r.downvote)
		else:
			r.rvote = r.upvote
				
		db.session.commit()
		
		return jsonify(score=r.rvote, up=r.upvote, down=r.downvote, i=num)
	
	
