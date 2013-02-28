import os
import unittest
from cris.config import TestConfig
from cris import create_app
from cris.extensions import db
#database objects currently being tested:
from cris.courses.model import Course
from cris.reviews.model import Review 

class crisTestCase(unittest.TestCase):	

	def setUp(self):
		application = create_app(None, TestConfig)
		application.test_client()
		db.create_all()	

	def tearDown(self):
		db.session.remove()
		db.drop_all
		os.remove('/tmp/tests.db')

	## Unit Testing Courses
	def test_courses(self):
		#testing db is empty
		assert Course.query.count() is 0
		
		c = Course('testCourseID', 'this is a test course name', 'this is a test description')
		db.session.add(c)
		db.session.commit()

		#testing db insertion
		assert c in db.session
		assert Course.query.count() is 1

		#testing primary key constraints
		db.session.add(c)
		db.session.commit()
		assert Course.query.count() is 1

		#test retreiving course
		c1 = Course.query.first()
		assert c1 is c

		#test deleting a course
		db.session.delete(c)
		db.session.commit()
		assert Course.query.count() is 0

	## Unit Testing Reviews
	def test_reviews(self):
		#testing db is empty
		assert Review.query.count() is 0
		
		r = Review('testCourseID', 1, 'this is a test review', 4)
		db.session.add(r)
		db.session.commit()

		#testing db insertion
		assert r in db.session
		assert Review.query.count() is 1

		#testing primary key constraints
		db.session.add(r)
		db.session.commit()
		assert Review.query.count() is 1

		#test retreiving review
		r1 = Review.query.first()
		assert r1 is r

		#test deleting a review
		db.session.delete(r)
		db.session.commit()
		assert Review.query.count() is 0

if __name__ == '__main__':
	unittest.main()
