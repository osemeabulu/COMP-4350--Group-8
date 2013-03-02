from cris.extensions import db

class User(db.Model):
	__tablename__ = 'Users_User'
	username = db.Column(db.String(40), primary_key=True)
	password = db.Column(db.String(40))
	admin = db.Column(db.Boolean)

	def __init__(self, username, password, admin= False):
		self.username = username
		self.password = password
		self.admin = admin

	def __repr__(self):
		return '<User %r>' % self.username

	@property
	def serialize(self):
		return {
			'username': self.username,
			'password': self.password,
			'admin': self.admin
		}

