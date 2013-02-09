from sqlalchemy import Column, types
from .services import db

class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    cid = db.Column(db.String(10), unique=True)
    cname = db.Column(db.String(20), unique=True)

    def __init__(self, cid, cname):
        self.cid = cid
        self.cname = cname

    def __repr__(self):
        return '<User %r>' % self.cname
       
