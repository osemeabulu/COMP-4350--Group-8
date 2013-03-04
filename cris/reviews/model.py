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
	username = db.Column(db.String(40), db.ForeignKey('Users_User.username'))

	def __init__(self, cid, rscr, rdesc, rvote=None, upvote=None, downvote=None, username=None):
		self.cid = cid
		self.rscr = rscr
		self.rdesc = rdesc
		self.rvote = rvote
		self.upvote = upvote
		self.downvote = downvote
		self.username = username

	def __repr__(self):
		return '<Review %r>' % self.rdesc

	@property
	def serialize(self):
		return {
                        'id'    : self.id,
			'cid'	: self.cid,
			'rscr'	: self.rscr,
			'rdesc'	: self.rdesc,
			'rvote'	: self.rvote,
			'upvote' : self.upvote,
			'downvote' : self.downvote,
			'username' : self.username
		}
				
