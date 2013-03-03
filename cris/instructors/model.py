from cris.extensions import db

class Association(db.Model):
	__tablename__ = 'association'
	pname = db.Column(db.String(20), db.ForeignKey('instructors_instructor.pname'), primary_key=True)
	cid = db.Column(db.String(20), db.ForeignKey('courses_course.cid'), primary_key=True)
	a_course = db.relationship("Course", backref="courses")
	
	def __init__(self, pname, cid):
		self.pname = pname
		self.cid = cid
		

	def __repr__(self):
		return '<%r>' % self.cid

	@property
	def serialize(self):
		return {
			'cid'	: self.cid
		}

    

class Instructor(db.Model):
	__tablename__ = 'instructors_instructor'
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	pname = db.Column(db.String(20), unique=True)
	courses = db.relationship("Association", backref="instructor")


	def __init__(self, pname):
		self.pname = pname
		

	def __repr__(self):
		return '<Instructor %r, courses %r >' % (self.pname, self.courses)

	@property
	def serialize(self):
		return {
			'pname'		: self.pname,
			'courses'	: self.courses
		}
	
	def add_course(self, course):
		assoc = Association(self.pname, course.cid)
		assoc.a_course=course
		self.courses.append(assoc)

from cris import db
