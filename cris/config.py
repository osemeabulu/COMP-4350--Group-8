#import os
#_basedir = os.path.abspath(os.path.dirname(__file__))

#SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(_basedir, 'app.db')

class DevConfig():
	SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/cris.db'
	SECRET_KEY = "key for logins"	
	DATABASE_CONNECT_OPTIONS = {}

class TestConfig():
	TESTING = True
	CSRF_ENABLED = False
	SECRET_KEY = "testing key"
	SQLALCHEMY_ECHO = False
	SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/tests.db'

