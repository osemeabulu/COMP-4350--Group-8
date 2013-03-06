from cris.extensions import db    

class Instructor(db.Model):
	__tablename__ = 'instructors_instructor'
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	cid = db.Column(db.String(10), db.ForeignKey('courses_course.cid'))
	pname = db.Column(db.String(20))
	


	def __init__(self, cid, pname):
		self.pname = pname
		

	def __repr__(self):
		return '<Instructor %r>' % self.pname

	@property
	def serialize(self):
		return {
                        'id'    : self.id,
			'pname'	: self.pname
		}

from cris import db
