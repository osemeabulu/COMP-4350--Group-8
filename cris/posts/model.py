from cris.extensions import db
import datetime

class Post(db.Model):
	__tablename__ = 'Posts_Post'
	id = db.Column(db.Integer, primary_key=True)
	time = db.Column(db.DateTime)
	message = db.Column(db.String(255))
	owner = db.Column(db.String(40), db.ForeignKey('Users_User.username'))

	def __init__(self, owner, message):
		self.time = datetime.datetime.now()
		self.owner = owner
		self.message = message

	def __repr__(self):
		return '<Post %r>' % self.message
        
	@property
	def serialize(self):
		return {
			'time'	        : (self.time).strftime('%H:%M:%S %D'),
			'message'       : self.message,
			'owner'         : self.owner,
		}
