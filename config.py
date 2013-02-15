#import os
#_basedir = os.path.abspath(os.path.dirname(__file__))

#SQLALCHEMY_DATABASE_URI = 'sqlite:///' + os.path.join(_basedir, 'app.db')
SQLALCHEMY_DATABASE_URI = 'sqlite:////tmp/cris.db'
DATABASE_CONNECT_OPTIONS = {}
