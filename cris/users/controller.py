from flask import Blueprint, jsonify, render_template, request, redirect, url_for, request, flash, session
from cris import db
from sqlalchemy.exc import IntegrityError
from model import User
mod = Blueprint('users', __name__, url_prefix='/users')

@mod.route('/')
def index():
	return render_template('users/users.html')
  
@mod.route('/register', methods = ['GET', 'POST'])
def register():	
	error = None
	#make sure we arn't logged in
	if 'username' in session:
		flash("You can not register an account when you are logged in")
		return redirect(url_for('index'))

	if request.method == 'POST':
		if request.form['password'] == request.form['password_c']:
			try:
				db.session.add(User(request.form['username'], request.form['password']))
				db.session.commit()
				session['username'] = request.form['username'] #login
				flash("Account successfully created")
				return redirect(url_for('index'))
			except IntegrityError:
				error = "User with that name already exists"
		else:
			error = "Passwords don't match"

	return render_template('users/register.html', error=error)
   


@mod.route('/_check_follower', methods = ['GET'])
def check_follower():
	result = False
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('follow', '')
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				result = follower.check_following(followed)

	return jsonify(followed = result) 

@mod.route('/_follow_user', methods = ['GET'])
def follow_user():
	result = False
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('follow', '')
			print user_followed
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				if follower.follow(followed) is not None:
					result = True
					flash('You are now following ' + followed.username + '.')
			else:
				error = 'Cannot follow ' + username + '.'
				flash(error)
	else:
		error = 'Please log in if you wish to follow this user.'
		flash(error)

	return jsonify(followed = result) 

@mod.route('/_unfollow_user', methods = ['GET'])
def unfollow_user():
	result = False
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('follow', '')
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				if follower.unfollow(followed) is not None:
					result = True
					flash('You are no longer following ' + followed.username + '.')
			else:
				error = 'Cannot unfollow ' + username + '.'
				flash(error)
	else:
		error = 'Please log in if you wish to unfollow this user.'
		flash(error)

	return jsonify(unfollowed = result) 

@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	results = User.query.all()
	return jsonify(users = [i.serialize for i in results])
