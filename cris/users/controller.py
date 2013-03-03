from flask import Blueprint, jsonify, render_template, redirect, url_for, request, flash, session
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
   
		


@mod.route('/_query')
def query():
	key = request.args.get('key', '')

	results = User.query.all()
	return jsonify(users = [i.serialize for i in results])
