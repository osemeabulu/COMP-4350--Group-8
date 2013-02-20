from flask import Flask, render_template
from flask.ext.sqlalchemy import SQLAlchemy


application = Flask(__name__)
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
	
from cris.courses.controller import mod as coursesModule
from cris.courses.model import Course
application.register_blueprint(coursesModule)

db.drop_all()
db.create_all()

oo = Course('Comp2150', 'Object Orientation')
aut = Course('Comp3030', 'Automata Theory and Formal Languages')
aa = Course('Comp3170', 'Analysis of Algorithms and Data Structures')
ai = Course('Comp3190', 'Artificial Intelligence')
se1 = Course('Comp3350', 'Software Engineering 1')
os1 = Course('Comp3430', 'Operating Systems 1')
se2 = Course('Comp4350', 'Software Engineering 2')

db.session.add(oo)
db.session.add(aut)
db.session.add(aa)
db.session.add(ai)
db.session.add(se1)
db.session.add(os1)
db.session.add(se2)

db.session.commit()

