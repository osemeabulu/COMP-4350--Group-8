from cris.extensions import db    
from cris.courses.model import Course

class Instructor(db.Model):
	__tablename__ = 'instructors_instructor'
	pname = db.Column(db.String(20), primary_key=True)
	courses = db.relationship('Course', backref = 'course', lazy = 'dynamic')

        def teach(self, course):
                if self is not None:
                        self.courses.append(course)
                        db.session.add(self)
                        db.session.commit()
                        return self
                return None
	
	def __init__(self, pname):
		self.pname = pname
		
	def __repr__(self):
		return '<Instructor %r>' % self.pname

	@property
	def serialize(self):
		return {
			'pname'	: self.pname
		}

from cris import db
