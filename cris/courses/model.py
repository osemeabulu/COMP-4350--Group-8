from cris.extensions import db
from cris.reviews.model import Review

class Course(db.Model):
	
	__tablename__ = 'courses_course'
	id = db.Column(db.Integer, primary_key=True)
	cid = db.Column(db.String(10), unique=True)
	cname = db.Column(db.String(20), unique=True)
	cdesc = db.Column(db.Text)
	cflty = db.Column(db.String(10))
	csem = db.Column(db.String(10))
	reviews = db.relationship('Review', backref = 'course', lazy = 'dynamic')
        instructor = db.Column(db.String(20), db.ForeignKey('instructors_instructor.pname'))

	def __init__(self, cid, cname, cdesc, cflty, csem):
		self.cid = cid
		self.cname = cname
		self.cdesc = cdesc
		self.cflty = cflty
                self.csem = csem

	def __repr__(self):
		return '<Course %r>' % self.cname
        
	@property
	def serialize(self):
		return {
			'cid'	        : self.cid,
			'cname'	        : self.cname,
			'cdesc'         : self.cdesc,
			'cflty'	        : self.cflty,
                        'instructor'    : self.instructor,
                        'csem'          : self.csem
		}
	
	def avg_rating(self):
		qry = Review.query.filter(Review.cid == self.cid).all()
		
		sum = 0
		count = 0
		for _res in qry:
			sum+= _res.rscr
			count+=1
		return sum/count
