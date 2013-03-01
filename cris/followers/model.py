from cris.extensions import db

class Follower(db.Model):
	__tablename__ = 'Followers_Follower'
	id = db.Column(db.Integer, primary_key=True)
	follower_id = db.Column(db.String(40), db.ForeignKey('Users_User.username'))
	followee_id = db.Column(db.String(40), db.ForeignKey('Users_User.username'))
	#follower = db.relationship('User', primaryjoin='Followers_Follower.follower_id==Users_User.username')
	#followee = db.relationship('User', primaryjoin='Followers_Follower.followee_id==Users_User.username')

	def __init__(self, follower, followee):	
		self.follower_id = follower
		self.followee_id = followee

	def __repr__(self):
		return '<Follower %s>' % self.follower_id

	@property
	def serialize(self):
		return {
			'follower': self.follower_id,
			'followee': self.followee_id,
		}

