from flask import Blueprint, jsonify, render_template, request, redirect, url_for, request, flash, session, abort
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
	result = []
	temp_dict = {}
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('key', '')
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				temp_dict['followed'] = follower.check_following(followed)
				result.append(temp_dict)
	return jsonify(followed = result) 

@mod.route('/_follow_user', methods = ['GET', 'POST'])
def follow_user():
	result = False
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('key', '')
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				if follower.follow(followed) is not None:
					result = True
					flash('You are now following ' + followed.username + '.')
			else:
				error = 'Cannot follow ' + user_followed + '.'
				flash(error)
	else:
		error = 'Please log in if you wish to follow this user.'
		flash(error)
	return jsonify(followed = result) 

@mod.route('/_unfollow_user', methods = ['GET', 'POST'])
def unfollow_user():
	result = False
	if 'username' in session:
		username = session['username']
		if request is not None:
			user_followed = request.args.get('key', '')
			followed = User.query.get(user_followed)
			follower = User.query.get(username)
			if follower and followed is not None:
				if follower.unfollow(followed) is not None:
					result = True
					flash('You are no longer following ' + followed.username + '.')
			else:
				error = 'Cannot unfollow ' + user_followed + '.'
				flash(error)
	else:
		error = 'Please log in if you wish to unfollow this user.'
		flash(error)

	return jsonify(unfollowed = result)

@mod.route('/_query_followers')
def query_followers():
	result = []
	username = request.args.get('user', '')
	if username is not None:
		user = User.query.get(username)
		if user is not None:
			followers = user.get_followed()
			for follower in followers:
				result.append(follower.serialize)
	return jsonify(followed = result)		

@mod.route('/_query_following')
def query_following():
	result = []
	username = request.args.get('user', '')
	if username is not None:
		user = User.query.get(username)
		if user is not None:
			followers = user.get_followers()
			for follower in followers:
				result.append(follower.serialize)
	return jsonify(followed = result)			

@mod.route('/<string:user>')
def show_user(user):
	result = User.query.filter_by(username=user).first()
  
	if result:
		return render_template('users/show_user.html', user=result)
  	else:
    		abort(404)

@mod.route('/_query_user')
def query_user():
	key = request.args.get('key', '')
	results = User.query.filter_by(username=key).all()
	return jsonify(users = [i.serialize for i in results])

@mod.route('/_query')
def query():
	results = User.query.all()
	return jsonify(users = [i.serialize for i in results])
	
@mod.route('/_check_session', methods = ['GET', 'POST'])
def check_session():
	logged_in = 'not logged in'
	
	if 'username' in session:
		flash ("Already Logged In.")
		#return redirect(url_for('index'))
		logged_in = session['username']
	if request.method == 'POST':
		data = request.json
		#username = request.form['username']
		#password = request.form['password']
		username = request.json['name']
		password = request.json['pass']
		result = User.query.filter_by(username=username).first()
		if result and result.password == password:
			session['username'] = username
			flash('You were logged in')
			#return redirect(url_for('index'))
			logged_in = username
		else:
			#error = 'Unable to validate user'
			flash('Unable to validate user')
			logged_in = 'not logged in'
		
	return jsonify(session = logged_in)



