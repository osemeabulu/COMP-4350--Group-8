from cris.extensions import db

class Review(db.Model):
	__tablename__ = 'reviews_review'
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	cid = db.Column(db.String(10), db.ForeignKey('courses_course.cid'))
	rscr = db.Column(db.Float)
	rdesc = db.Column(db.Text)
	rvote = db.Column(db.Float)

	def __init__(self, cid, rscr, rdesc, rvote=None):
		self.cid = cid
		self.rscr = rscr
		self.rdesc = rdesc
		self.rvote = rvote

	def __repr__(self):
		return '<Review %r>' % self.rdesc

	@property
	def serialize(self):
		return {
			'cid'	: self.cid,
			'rscr'	: self.rscr,
			'rdesc'	: self.rdesc,
			'rvote'	: self.rvote
		}

from cris import db
