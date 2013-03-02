from cris.extensions import db

class Review(db.Model):
	__tablename__ = 'reviews_review'
	id = db.Column(db.Integer, primary_key=True, autoincrement=True)
	cid = db.Column(db.String(10), db.ForeignKey('courses_course.cid'))
	rscr = db.Column(db.Float)
	rdesc = db.Column(db.Text)
	rvote = db.Column(db.Float)
	upvote = db.Column(db.Integer)
	downvote = db.Column(db.Integer)

	def __init__(self, cid, rscr, rdesc, rvote=None, upvote=None, downvote=None):
		self.cid = cid
		self.rscr = rscr
		self.rdesc = rdesc
		self.rvote = rvote
		self.upvote = upvote
		self.downvote = downvote

	def __repr__(self):
		return '<Review %r>' % self.rdesc

	@property
	def serialize(self):
		return {
			'cid'	: self.cid,
			'rscr'	: self.rscr,
			'rdesc'	: self.rdesc,
			'rvote'	: self.rvote,
			'upvote' : self.upvote,
			'downvote' : self.downvote
		}
		
	def set_upvote(self, vote):
		self.upvote = vote
	
	def set_downvote(self, vote):
		self.downvote = vote
		
	def getUpvote(self):
		return self.upvote
		
	def getDownvote(self):
		return self.downvote
		
	def getRvote(self):
		result = upvote/downvote
		return result

from cris import db
