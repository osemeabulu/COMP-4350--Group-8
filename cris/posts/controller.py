from flask import Blueprint, jsonify, session, flash, render_template, request, redirect, url_for, abort
from cris.users.model import User
from cris.posts.model import Post

mod = Blueprint('posts', __name__, url_prefix='/posts')

@mod.route('/_query_user')
def query_user():
	results = []
	key = request.args.get('key', '')
	user = User.query.filter_by(username=key).first()
	if user is not None:
		results = user.get_posts()
	return jsonify(posts = [i.serialize for i in results])	

@mod.route('/_query_user_followers')
def query_user_followers():
	results = []
	key = request.args.get('key', '')
	user = User.query.filter_by(username=key).first()
	if user is not None:
		results = user.get_followers_posts()
	return jsonify(posts = [i.serialize for i in results])	

@mod.route('/_query_user_following')
def query_user_following():
	results = []
	key = request.args.get('key', '')
	user = User.query.filter_by(username=key).first()
	if user is not None:
		results = user.get_following_posts()
	return jsonify(posts = [i.serialize for i in results])	

@mod.route('/_query_followers')
def query_followers():
	results = []
	if 'username' in session:
		username = session['username']
		user = User.query.get(username)
		if user is not None:
			results = user.get_followers_posts()
	return jsonify(posts = [i.serialize for i in results])	

@mod.route('/_query_following')
def query_following():
	results = []
	if 'username' in session:
		username = session['username']
		user = User.query.get(username)
		if user is not None:
			results = user.get_following_posts()
	return jsonify(posts = [i.serialize for i in results])	

@mod.route('/_query')
def query():
	key = request.args.get('key', '')
	results = []
	if 'username' in session:
		username = session['username']
		user = User.query.get(username)
		if user is not None:
			results = user.get_posts()
	return jsonify(posts = [i.serialize for i in results])

@mod.route('/_submit_post', methods=['POST'])
def submit_post():
	result = False
	if request is not None and request.method == 'POST':
		message = request.json['msg']

		username = None
		if 'username' in session:
			username = session['username']
			user = User.query.get(username)
			if user is not None:
				if user.create_post(message) is not None:
					result = True
					flash('Post was successfully created.')
				else:
					flash('Failed to create post.')
			else:
				flash('You cannot create posts while logged in as ' + username + '.')
		else:
			flash('Please log in if you wish to create posts.')
	return jsonify(posted = result)
