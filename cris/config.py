#import os
#_basedir = os.path.abspath(os.path.dirname(__file__))

#SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(_basedir, 'app.db')

class DevConfig():
	SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/cris.db'
	
	DATABASE_CONNECT_OPTIONS = {}

class TestConfig():
	TESTING = True
	CSRF_ENABLED = False

	SQLALCHEMY_ECHO = False
	SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/tests.db'

