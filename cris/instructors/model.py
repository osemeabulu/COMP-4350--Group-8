from cris.extensions import db

class Instructor(db.Model):
	__tablename__ = 'instructors_instructor'
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	tname = db.Column(db.String(20), unique=True)


	def __init__(self, tname):
		self.tname = tname
		

	def __repr__(self):
		return '<Instructor %r>' % self.tname

	@property
	def serialize(self):
		return {
			'tname'	: self.tname
		}

from cris import db
