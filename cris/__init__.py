from flask import Flask, render_template
from flask.ext.sqlalchemy import SQLAlchemy


application = Flask(__name__, static_folder='../static')
application.config.from_object('config')

db = SQLAlchemy(application)

@application.route("/")
def index():
	return render_template('index.html')

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
	
from cris.reviews.model import Review

from cris.courses.controller import mod as coursesModule
from cris.courses.model import Course
application.register_blueprint(coursesModule)

db.drop_all()
db.create_all()

oo = Course('Comp2150', 'Object Orientation', 'Calendar Description: Design and development of object-oriented software. Topics will ' +
'include inheritance, polymorphism, data abstraction and encapsulation.  Examples will be drawn from several programming languages (Lab required).' + 
'Prerequisite: COMP 2140 and 2160 This course is a prerequisite for: COMP 3010, COMP 3350 and COMP 4290' )

aut = Course('Comp3030', 'Automata Theory and Formal Languages', 'Calendar Description: An introduction to automata theory, grammars, formal languages' +
'and their applications. Topics: finite automata, regular expressions and their properties;' +
'context-free grammars, pushdown automata and properties of context-free languages;' +
'turing machines. Applications: lexical analysis, text editing, machine design, syntax' +
'analysis, parser generation.' + 
'Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4310')

aa = Course('Comp3170', 'Analysis of Algorithms and Data Structures', 'Calendar Description: Fundamental Algorithms for sorting, searching, storage' +
'management, graphs, databases and computational geometry.  Correctness and Analysis' + 
'of those Algorithms using specific data structures.  An introduction to lower bounds and' + 
'intractability. Prerequisites: COMP 2080 and COMP 2140. This course is a prerequisite for: COMP 4340 and COMP 4420')

ai = Course('Comp3190', 'Artificial Intelligence', 'Calendar Description: Principles of artificial intelligence; problem solving, knowledge' +
'representation and manipulation; the application of these principles to the solution of hard' + 
'problems. Prerequisite: COMP 2140. This course is a prerequisite for: COMP 4190, COMP 4200 and COMP 4360.' )

se1 = Course('Comp3350', 'Software Engineering 1', 'Calendar Description: Introduction to software engineering.  Software life cycle' +
'models, system and software requirements analysis, specifications, software design,' + 
'testing, and maintenance, software quality. Prerequisite: COMP 2150. This course is a prerequisite for: COMP 4050, COMP 4350 and COMP 4560' )

os1 = Course('Comp3430', 'Operating Systems 1', 'Calendar Description: Operating systems, their design, implementation, and usage (Lab ' +
'required).  Prerequisite: COMP 2140 and COMP 2280 Recommended: COMP 2160 ' +
'This course is a prerequisite for: COMP 4430, COMP 4510, COMP 4550 and COMP 4580' )

se2 = Course('Comp4350', 'Software Engineering 2', 'Calendar Description:  Advanced treatment of software development methods. Topics' + 
'will be selected from requirements gathering, design methodologies, prototyping,' + 
'software verification and validation.  Prerequisite: COMP 3350.' )

db.session.add(oo)
db.session.add(aut)
db.session.add(aa)
db.session.add(ai)
db.session.add(se1)
db.session.add(os1)
db.session.add(se2)

db.session.commit()

