import os
import unittest
from cris.config import TestConfig
from cris import create_app
from cris.extensions import db
#database objects currently being tested:
from cris.courses.model import Course
from cris.reviews.model import Review 
from cris.users.model import User

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
		
		c = Course('testCourseID', 'this is a test course name', 'this is a test description', 'Science')
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

	#Unit Testing Following
	def test_followers(self):
        	u1 = User('testuser1', 'testpassword1')
        	u2 = User('testuser2', 'testpassword2')
        	ua1 = User('testadmin1', 'testpassword1', True)
        	ua2 = User('testadmin2', 'testpassword2', True)

		db.session.add(u1)
        	db.session.add(u2)
		db.session.add(ua1)
		db.session.add(ua2)
        	db.session.commit()
		#ensure there is currently no one following each other
        	assert u1.unfollow(u2) is None
        	assert u2.unfollow(u1) is None
		assert ua1.unfollow(ua2) is None
		assert ua2.unfollow(ua1) is None
		assert ua1.unfollow(u1) is None
		assert ua2.unfollow(u2) is None
		#make users follow each other and check success (follow returns self on success)
		assert u1.follow(u2) is not None
		assert u1.check_following(u2)
		assert u1.followed.count() is 1
		assert ua1.follow(ua2) is not None
		assert ua1.check_following(ua2)
		assert ua1.followed.count() is 1
		assert ua1.follow(u1) is not None
		assert ua1.check_following(u1)
		assert ua1.followed.count() == 2
		#check doing same follows does not succeed (follow returns None on failure)
		assert u1.follow(u2) is None
		assert ua1.follow(ua2) is None
		assert ua1.follow(u1) is None
		#test unfollow
		assert u1.unfollow(u2) is not None
		assert ua1.unfollow(ua2) is not None
		assert ua1.unfollow(u1) is not None
		assert not u1.check_following(u2)
		assert not ua1.check_following(ua2)
		assert not ua1.check_following(u2)

if __name__ == '__main__':
	unittest.main()
