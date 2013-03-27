from flask import Flask, request, render_template, session, url_for, redirect, render_template, flash
from .config import DevConfig
from .extensions import db
from cris.courses.controller import mod as coursesModule
from cris.reviews.controller import mod as reviewsModule
from cris.users.controller import mod as userModule
from cris.instructors.controller import mod as instructorsModule
from cris.posts.controller import mod as postsModule
from cris.users.model import User
from cris.posts.model import Post

__all__ = ['create_app']

DEFAULT_BLUEPRINTS = (
	coursesModule,
	reviewsModule,
	userModule,
	instructorsModule,
	postsModule,
)

def create_app(blueprints = None, config = None):
	if blueprints is None:
		blueprints = DEFAULT_BLUEPRINTS
	if config is None:
		config = DevConfig

	application = Flask(__name__, static_folder='static')

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
		'''error = None
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
			else:'''
				#error = 'Unable to validate user'
		return render_template('login.html')

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

	@application.route("/show_semester")
	def show_semester():
		return render_template('show_semester.html')

	@application.route("/posts")
	def posts():
		return render_template('posts.html')

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
	'Prerequisite: COMP 2140 and 2160 This course is a prerequisite for: COMP 3010, COMP 3350 and COMP 4290', 'Science', 'Fall')

	aut = Course('Comp3030', 'Automata Theory and Formal Languages', 'Calendar Description: An introduction to automata theory, grammars, formal languages' +
	'and their applications. Topics: finite automata, regular expressions and their properties;' +
	'context-free grammars, pushdown automata and properties of context-free languages;' +
	'turing machines. Applications: lexical analysis, text editing, machine design, syntax' +
	'analysis, parser generation.' +
	'Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4310', 'Science', 'Winter')

	aa = Course('Comp3170', 'Analysis of Algorithms and Data Structures', 'Calendar Description: Fundamental Algorithms for sorting, searching, storage' +
	'management, graphs, databases and computational geometry. Correctness and Analysis' +
	'of those Algorithms using specific data structures. An introduction to lower bounds and' +
	'intractability. Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4340 and COMP 4420', 'Science', 'Fall')
	
	ai = Course('Comp3190', 'Artificial Intelligence', 'Calendar Description: Principles of artificial intelligence; problem solving, knowledge' +
	'representation and manipulation; the application of these principles to the solution of hard' +
	'problems. Prerequisite: COMP 2140. This course is a prerequisite for: COMP 4190, COMP 4200 and COMP 4360.', 'Science', 'Winter')
	
	se1 = Course('Comp3350', 'Software Engineering 1', 'Calendar Description: Introduction to software engineering. Software life cycle' +
	'models, system and software requirements analysis, specifications, software design,' +
	'testing, and maintenance, software quality. Prerequisite: COMP 2150. This course is a prerequisite for: COMP 4050, COMP 4350 and COMP 4560', 'Science', 'Fall')
	
	os1 = Course('Comp3430', 'Operating Systems 1', 'Calendar Description: Operating systems, their design, implementation, and usage (Lab ' +
	'required). Prerequisite: COMP 2140 and COMP 2280 Recommended: COMP 2160 ' +
	'This course is a prerequisite for: COMP 4430, COMP 4510, COMP 4550 and COMP 4580', 'Science', 'Fall')

	se2 = Course('Comp4350', 'Software Engineering 2', 'Calendar Description: Advanced treatment of software development methods. Topics' +
	'will be selected from requirements gathering, design methodologies, prototyping,' +
	'software verification and validation. Prerequisite: COMP 3350.', 'Science', 'Winter')
	
	h1 = Course('Hist1200', 'An Introduction to the History of Western Civilization', 'Calendar Description: An introductory survey of the cultural' +
	' history of the Western world from the ancient Greeks to the present. Students may not hold credit for HIST 1200 and any of: HIST 1201 or HIST 1350', 'Arts', 'Fall')
	
	h2 = Course('Hist2080', 'The Byzantine Empire and the Slavic World', 'A study of the rise and fall of the "later Roman Empire" and of its relations with Russia, Bulgaria, Serbia and the west (i.e., in the crusades), 800-1261 A.D. ',
	'Arts', 'Fall')
	
	e1 = Course('Engl2090', 'Literature of the Seventeenth Century', 'A survey of poetry, prose and drama by major and minor writers in historical context. Students may not hold credit for both ENGL 2090 and ENGL 2091 ' +
	'. Prerequisite: [a grade of "C" or better in ENGL 1200 or ENGL 1201 or ENGL 1300 or ENGL 1301] or [a grade of "C" or better in each of ENGL 1310 and ENGL 1340]. ',
	'Arts', 'Winter')
	
	e2 = Course('Eng7010', 'The Engineering Design Process', 'Consideration of the Engineering Design process and the logic upon which it is based. Explores both the history and possible future directions of the process from technical, social and environmental points of view.',
	'Graduate', 'Winter')
	
	review1 = Review('Comp4350', 4, 'This was a hard course that required a lot of background research and work.', 0.75, 3, 4)
	review2 = Review('Comp2150', 4, 'I learned alot from this course and I can now make a simple program.', 0.50, 2, 4)
	review3 = Review('Comp4350', 3, 'Take this course if you do not want to sleep for like a week at the end of March', 0.50, 2, 4)
	review4 = Review('Comp3430', 5, 'Threads are fun!', 0.75, 3, 4)
	review5 = Review('Comp3030', 5, 'Finite state machines are pretty easy', 1.0, 1, 0);

        prof1 = Instructor('John Braico')
        prof2 = Instructor('Mike Zapp')
        prof3 = Instructor('Alan Marshall')
        prof4 = Instructor('Christina Penner')
        prof5 = Instructor('John Anderson')
        prof6 = Instructor('Pourang Irani')
        prof7 = Instructor('James Young')
        prof8 = Instructor('John McDonald')
        prof9 = Instructor('Franz Ferdinand')
        prof10 = Instructor('Jean-Luc Picard')
        prof11 = Instructor('Dilbert')
    
	admin = User('admin', 'default', True)
	test_user = User('test', 'password')	
	james = User('james', 'j123')
	chris = User('chris', 'c123') 
	sam = User('sam', 's123')

	post1 = Post("sam", "Just finished having some cookies and punch at the Comp Sci Staff Lounge!")
	post2 = Post("chris", "@Sam - I prefer beer and pizza!!")	
	post3 = Post("james", "Finally finished my SE2 project! I can finally relax!!")

	db.session.add(oo)
	db.session.add(aut)
	db.session.add(aa)
	db.session.add(ai)
	db.session.add(se1)
	db.session.add(os1)
	db.session.add(se2)
	db.session.add(h1)
	db.session.add(h2)
	db.session.add(e1)
	db.session.add(e2)

	db.session.add(review1)
	db.session.add(review2)
	db.session.add(review3)
	db.session.add(review4)
	db.session.add(review5)
	
	db.session.add(prof1)
	db.session.add(prof2)
	db.session.add(prof3)
	db.session.add(prof4)
	db.session.add(prof5)
	db.session.add(prof6)
	db.session.add(prof7)

	db.session.add(admin)
	db.session.add(test_user)
	db.session.add(james)
	db.session.add(chris)
	db.session.add(sam)
	
	db.session.add(post1)
	db.session.add(post2)
	db.session.add(post3)

	db.session.commit()

 	prof1.teach(oo)
	prof1.teach(aut)
	prof2.teach(se2)
	prof2.teach(ai)
	prof3.teach(se1)
	prof3.teach(os1)
	prof4.teach(aa)
	prof8.teach(h1)
	prof9.teach(h2)
	prof10.teach(e1)
	prof11.teach(e2)
	
	sam.follow(james)
	chris.follow(sam)
