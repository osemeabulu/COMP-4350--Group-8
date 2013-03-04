from flask import Flask, request, render_template, session, url_for, redirect, render_template, flash
from .config import DevConfig
from .extensions import db
from cris.courses.controller import mod as coursesModule
from cris.reviews.controller import mod as reviewsModule
from cris.users.controller import mod as userModule
from cris.instructors.controller import mod as instructorsModule
from cris.users.model import User

__all__ = ['create_app']

DEFAULT_BLUEPRINTS = (
	coursesModule,
	reviewsModule,
	userModule,
	instructorsModule,
)

def create_app(blueprints = None, config = None):
	if blueprints is None:
		blueprints = DEFAULT_BLUEPRINTS
	if config is None:
		config = DevConfig

	application = Flask(__name__, static_folder='../static')

	configure_app(application, config)	
	configure_extensions(application, config)	
	configure_blueprints(application, blueprints)
	configure_routes(application)

	return application

def configure_app(application, config):
	if config is not None:
		application.config.from_object(config)

def configure_extensions(application, config):
	db.app = application
	db.init_app(application)
	if config is DevConfig:
		reload_db() #recreates the database, so that we have our baseline data - change to import db from repo later

def configure_blueprints(application, blueprints):
	for blueprint in blueprints:
		application.register_blueprint(blueprint)

def configure_routes(application):
	@application.route("/")
	def index():
		return render_template('index.html')

	@application.route("/login", methods=['GET', 'POST'])
	def login():
		error = None
		if 'username' in session:
			flash ("Already Logged In.")
			return redirect(url_for('index'))
		if request.method == 'POST':
			username = request.form['username']
			password = request.form['password']
			result = User.query.filter_by(username=username).first()
			if result and result.password == password:
				session['username'] = username
				flash('You were logged in')
				return redirect(url_for('index'))
			else:
				error = 'Unable to validate user'
		return render_template('login.html', error=error)

	@application.route('/logout')
	def logout():
		session.pop('username', None)
		flash('You were logged out')
		return redirect(url_for('index'))
	
	@application.route("/courses", methods=['GET', 'POST'])
	def courses():
	    if request.method == 'POST':
		flash('We would process your search but we are not beefed up yet')
	    return render_template('courses.html')

	@application.route("/top_rated")
	def top_rated():
		return render_template('top_rated.html')

	@application.route("/program_planner")
	def program_planner():
	    return render_template('program_planner.html')

	@application.route("/instructors")
	def instructors():
	    return render_template('instructors.html')

	@application.route("/about")
	def about():
	    return render_template('about.html')

	@application.route("/contact")
	def contact():
	    return render_template('contact.html')

	@application.errorhandler(404)
	def page_not_found(e):
  		return render_template('404.html'), 404

	@application.route("/qtests")
	def qtests():
		return render_template('tests.html')


def reload_db():
	from cris.courses.model import Course
	from cris.reviews.model import Review
	from cris.instructors.model import Instructor
	from cris.users.model import User

	db.drop_all()
	db.create_all()

	oo = Course('Comp2150', 'Object Orientation', 'Calendar Description: Design and development of object-oriented software. Topics will ' +
	'include inheritance, polymorphism, data abstraction and encapsulation. Examples will be drawn from several programming languages (Lab required).' +
	'Prerequisite: COMP 2140 and 2160 This course is a prerequisite for: COMP 3010, COMP 3350 and COMP 4290', 'Science')

	aut = Course('Comp3030', 'Automata Theory and Formal Languages', 'Calendar Description: An introduction to automata theory, grammars, formal languages' +
	'and their applications. Topics: finite automata, regular expressions and their properties;' +
	'context-free grammars, pushdown automata and properties of context-free languages;' +
	'turing machines. Applications: lexical analysis, text editing, machine design, syntax' +
	'analysis, parser generation.' +
	'Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4310', 'Science')

	aa = Course('Comp3170', 'Analysis of Algorithms and Data Structures', 'Calendar Description: Fundamental Algorithms for sorting, searching, storage' +
	'management, graphs, databases and computational geometry. Correctness and Analysis' +
	'of those Algorithms using specific data structures. An introduction to lower bounds and' +
	'intractability. Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4340 and COMP 4420', 'Science')
	
	ai = Course('Comp3190', 'Artificial Intelligence', 'Calendar Description: Principles of artificial intelligence; problem solving, knowledge' +
	'representation and manipulation; the application of these principles to the solution of hard' +
	'problems. Prerequisite: COMP 2140. This course is a prerequisite for: COMP 4190, COMP 4200 and COMP 4360.', 'Science')
	
	se1 = Course('Comp3350', 'Software Engineering 1', 'Calendar Description: Introduction to software engineering. Software life cycle' +
	'models, system and software requirements analysis, specifications, software design,' +
	'testing, and maintenance, software quality. Prerequisite: COMP 2150. This course is a prerequisite for: COMP 4050, COMP 4350 and COMP 4560', 'Science')
	
	os1 = Course('Comp3430', 'Operating Systems 1', 'Calendar Description: Operating systems, their design, implementation, and usage (Lab ' +
	'required). Prerequisite: COMP 2140 and COMP 2280 Recommended: COMP 2160 ' +
	'This course is a prerequisite for: COMP 4430, COMP 4510, COMP 4550 and COMP 4580', 'Science')

	se2 = Course('Comp4350', 'Software Engineering 2', 'Calendar Description: Advanced treatment of software development methods. Topics' +
	'will be selected from requirements gathering, design methodologies, prototyping,' +
	'software verification and validation. Prerequisite: COMP 3350.', 'Science')
	
	review1 = Review('Comp4350', 0.85, 'This was a hard course that required a lot of background research and work.', 4)

	admin = User('admin', 'default', True)
	test_user = User('test', 'password')
	
	prof = Instructor('Michael Zapp')
	prof.add_course(se2)
	prof.add_course(os1)
	
	prof2 = Instructor('John Braico')
	prof2.add_course(se1)
	
	prof3 = Instructor('John Anderson')
	prof3.add_course(ai)
	
	
	db.session.add(oo)
	db.session.add(aut)
	db.session.add(aa)
	db.session.add(ai)
	db.session.add(se1)
	db.session.add(os1)
	db.session.add(se2)

	db.session.add(review1)
	
	db.session.add(prof)

	db.session.add(admin)
	db.session.add(test_user)


	db.session.commit()
