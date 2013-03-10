from cris.extensions import db

followers = db.Table('Followers_Follower',
    db.Column('follower_id', db.String(40), db.ForeignKey('Users_User.username')),
    db.Column('followed_id', db.String(40), db.ForeignKey('Users_User.username'))
)

class User(db.Model):
	__tablename__ = 'Users_User'
	username = db.Column(db.String(40), primary_key=True)
	password = db.Column(db.String(40))
	admin = db.Column(db.Boolean)
	followed = db.relationship('User', 
			secondary = followers,
			primaryjoin = (followers.c.follower_id == username),
			secondaryjoin = (followers.c.followed_id == username),
			backref = db.backref('followers', lazy = 'dynamic'),
			lazy = 'dynamic')

	def __init__(self, username, password, admin= False):
		self.username = username
		self.password = password
		self.admin = admin

    	def follow(self, user):
		if self is not None:
			if not self.check_following(user):
            			self.followed.append(user)
				db.session.add(self)
				db.session.commit()
				return self
		return None

    	def unfollow(self, user):
		if self is not None:
        		if self.check_following(user):
            			self.followed.remove(user)
            			db.session.add(self)
				db.session.commit()
				return self
		return None

    	def check_following(self, user):
        	return self.followed.filter(followers.c.followed_id == user.username).count() > 0

	def get_followers(self):
		return self.followed.filter(followers.c.follower_id == self.username).all()

	def get_followed(self):
		return self.followers.all()

	def __repr__(self):
		return '<User %r>' % self.username

	@property
	def serialize(self):
		return {
			'username': self.username,
			'password': self.password,
			'admin': self.admin
		}

