from flask.ext.sqlalchemy import SQLAlchemy
from services import db
from course import Course

def init(app):
	app.config['SQALCHEMY_DATABASE_URI'] = 'sqlite:////tmp/test.db'
	initdb(app)

def initdb(app):
	db.app = app
	db.init_app(app)
	
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
