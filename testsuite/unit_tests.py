import os
import unittest
from cris.config import TestConfig
from cris import create_app
from cris.extensions import db
#database objects currently being tested:
from cris.courses.model import Course
from cris.reviews.model import Review 
from cris.users.model import User
from cris.posts.model import Post
from cris.instructors.model import Instructor

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
		
		c1 = Course('testCourse1', 'testname1', 'testdescription1', 'Science', 'Fall')
		c2 = Course('testCourse2', 'testname2', 'testdescription2', 'Science', 'Winter')
		c3 = Course('testCourse3', 'testname3', 'testdescription3', 'Science', 'Fall')
		
		db.session.add(c1)
		db.session.add(c2)
		db.session.add(c3)
		db.session.commit()

		#testing db insertion
		assert c1 in db.session
		assert c2 in db.session
		assert c3 in db.session
		assert Course.query.count() is 3

		#testing primary key constraints
		db.session.add(c1)
		db.session.add(c2)
		db.session.add(c3)
		db.session.commit()
		assert Course.query.count() is 3

		#test retreiving course
		c = Course.query.filter(Course.cid == 'testCourse1').first()
		assert c1 is c
		assert (c1.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse2').first()
		assert c2 is c
		assert (c2.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse3').first()
		assert c3 is c
		assert (c3.serialize == c.serialize)

		#test deleting a course
		db.session.delete(c1)
		db.session.delete(c2)
		db.session.delete(c3)
		db.session.commit()
		assert Course.query.count() is 0

	## Unit Testing Reviews
	def test_reviews(self):
		#testing db is empty
		assert Review.query.count() is 0
		
		c1 = Course('testCourse1', 'testname1', 'testdescription1', 'Science', 'Fall')
		c2 = Course('testCourse2', 'testname2', 'testdescription2', 'Science', 'Winter')
		c3 = Course('testCourse3', 'testname3', 'testdescription3', 'Science', 'Fall')
		r1 = Review('testCourse1', 1, 'this is a test review', 4)
		r2 = Review('testCourse2', 2, 'this is a test review', 4)
		r3 = Review('testCourse3', 3, 'this is a test review', 4)

		db.session.add(c1)
		db.session.add(c2)
		db.session.add(c3)
		db.session.add(r1)
		db.session.add(r2)
		db.session.add(r3)
		db.session.commit()

		#testing db insertion
		assert r1 in db.session
		assert r2 in db.session
		assert r3 in db.session
		assert c1 in db.session
		assert c2 in db.session
		assert c3 in db.session
		assert Review.query.count() is 3
		assert Course.query.count() is 3

		#testing primary key constraints
		db.session.add(c1)
		db.session.add(c2)
		db.session.add(c3)
		db.session.add(r1)
		db.session.add(r2)
		db.session.add(r3)
		db.session.commit()
		assert Review.query.count() is 3
		assert Course.query.count() is 3

		#test retreiving review
		r = Review.query.filter(Review.cid == 'testCourse1').first()
		assert r1 is r
		assert (r1.serialize == r.serialize)
		r = Review.query.filter(Review.cid == 'testCourse2').first()
		assert r2 is r
		assert (r2.serialize == r.serialize)
		r = Review.query.filter(Review.cid == 'testCourse3').first()
		assert r3 is r
		assert (r3.serialize == r.serialize)

		c = Course.query.filter(Course.cid == 'testCourse1').first()
		assert c1 is c
		assert (c1.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse2').first()
		assert c2 is c
		assert (c2.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse3').first()
		assert c3 is c
		assert (c3.serialize == c.serialize)

		#test course ratings
		assert (c1.avg_rating() == 1.0)
		assert (c2.avg_rating() == 2.0)
		assert (c3.avg_rating() == 3.0)

		#test deleting a review
		db.session.delete(c1)
		db.session.delete(c2)
		db.session.delete(c3)
		db.session.delete(r1)
		db.session.delete(r2)
		db.session.delete(r3)
		db.session.commit()
		assert Course.query.count() is 0
		assert Review.query.count() is 0		

	#Unit Testing Following
	def test_followers(self):
		#testing db is empty
		assert User.query.count() is 0

        	u1 = User('testuser1', 'testpassword1')
        	u2 = User('testuser2', 'testpassword2')
        	ua1 = User('testadmin1', 'testpassword1', True)
        	ua2 = User('testadmin2', 'testpassword2', True)

		db.session.add(u1)
        	db.session.add(u2)
		db.session.add(ua1)
		db.session.add(ua2)
        	db.session.commit()
		assert User.query.count() is 4

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
		assert u2 in u1.get_followers()
		assert u1 in u2.get_followed()

		assert ua1.follow(ua2) is not None
		assert ua1.check_following(ua2)
		assert ua1.followed.count() is 1
		assert ua2 in ua1.get_followers()
		assert ua1 in ua2.get_followed()
		
		assert ua1.follow(u1) is not None
		assert ua1.check_following(u1)
		assert ua1.followed.count() == 2
		assert u1 in ua1.get_followers()
		assert ua1 in u1.get_followed()

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

	def test_posts(self):
		#testing db is empty
		assert User.query.count() is 0
		assert Post.query.count() is 0

        	u1 = User('testuser1', 'testpassword1')
        	u2 = User('testuser2', 'testpassword2')
        	ua1 = User('testadmin1', 'testpassword1', True)
        	ua2 = User('testadmin2', 'testpassword2', True)

		db.session.add(u1)
        	db.session.add(u2)
		db.session.add(ua1)
		db.session.add(ua2)
        	db.session.commit()
		assert User.query.count() is 4

		#need to first create followers for future posts testing
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
		assert u2 in u1.get_followers()
		assert u1 in u2.get_followed()

		assert ua1.follow(ua2) is not None
		assert ua1.check_following(ua2)
		assert ua1.followed.count() is 1
		assert ua2 in ua1.get_followers()
		assert ua1 in ua2.get_followed()
		
		assert ua1.follow(u1) is not None
		assert ua1.check_following(u1)
		assert ua1.followed.count() == 2
		assert u1 in ua1.get_followers()
		assert ua1 in u1.get_followed()

		#test creating posts
		assert u1.create_post("This is user1's post!") is not None
		assert len(u1.get_posts()) is 1
		assert (u1.get_posts()[0].message == "This is user1's post!")
		assert u1.get_posts()[0].owner == u1.username

		assert u2.create_post("This is user2's post!") is not None
		assert len(u2.get_posts()) is 1
		assert (u2.get_posts()[0].message == "This is user2's post!")
		assert u2.get_posts()[0].owner == u2.username
		
		assert ua1.create_post("This is admin1's post!") is not None
		assert len(ua1.get_posts()) is 1
		assert (ua1.get_posts()[0].message == "This is admin1's post!")
		assert ua1.get_posts()[0].owner == ua1.username

		#test fetching followers posts
		assert len(u1.get_followers_posts()) is 1
		assert (u1.get_followers_posts()[0].message == "This is admin1's post!")
		assert u1.get_followers_posts()[0].owner == ua1.username
		assert len(u1.get_following_posts()) is 1
		assert (u1.get_following_posts()[0].message == "This is user2's post!")
		assert u1.get_following_posts()[0].owner == u2.username
		assert len(u2.get_followers_posts()) is 1
		assert (u2.get_followers_posts()[0].message == "This is user1's post!")
		assert u2.get_followers_posts()[0].owner == u1.username
		assert len(u2.get_following_posts()) is 0
		assert len(ua1.get_followers_posts()) is 0
		assert len(ua1.get_following_posts()) is 1
		assert (ua1.get_following_posts()[0].message == "This is user1's post!")
		assert ua1.get_following_posts()[0].owner == u1.username

		#unfollow
		assert u1.unfollow(u2) is not None
		assert ua1.unfollow(ua2) is not None
		assert ua1.unfollow(u1) is not None
		assert not u1.check_following(u2)
		assert not ua1.check_following(ua2)
		assert not ua1.check_following(u2)		
		
		#test fetching followers posts
		assert len(u1.get_following_posts()) is 0
		assert len(u1.get_followers_posts()) is 0
		assert len(u2.get_following_posts()) is 0
		assert len(u2.get_followers_posts()) is 0
		assert len(ua1.get_following_posts()) is 0
		assert len(ua1.get_followers_posts()) is 0

	#Unit Testing Instructors
	def test_instructors(self):
		assert Instructor.query.count() is 0
		assert Course.query.count() is 0

		c1 = Course('testCourse1', 'testname1', 'testdescription1', 'Science', 'Fall')
		c2 = Course('testCourse2', 'testname2', 'testdescription2', 'Science', 'Winter')
		c3 = Course('testCourse3', 'testname3', 'testdescription3', 'Science', 'Fall')
		c4 = Course('testCourse4', 'testname4', 'testdescription4', 'Science', 'Winter')
		prof1 = Instructor('Test Zapp')
		prof2 = Instructor('Test Braico')
		prof3 = Instructor('Test Marshall')
		prof4 = Instructor('Test Penner')
		
		db.session.add(prof1)
        	db.session.add(prof2)
		db.session.add(prof3)
		db.session.add(prof4)
		db.session.add(c1)
        	db.session.add(c2)
		db.session.add(c3)
		db.session.add(c4)
        	db.session.commit()

		#test query
		c = Course.query.filter(Course.cid == 'testCourse1').first()
		assert c1 is c
		assert (c1.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse2').first()
		assert c2 is c
		assert (c2.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse3').first()
		assert c3 is c
		assert (c3.serialize == c.serialize)
		c = Course.query.filter(Course.cid == 'testCourse4').first()
		assert c4 is c
		assert (c4.serialize == c.serialize)

		i = Instructor.query.filter(Instructor.pname == 'Test Zapp').first()
		assert prof1 is i
		assert (prof1.serialize == i.serialize)
		i = Instructor.query.filter(Instructor.pname == 'Test Braico').first()
		assert prof2 is i
		assert (prof2.serialize == i.serialize)
		i = Instructor.query.filter(Instructor.pname == 'Test Marshall').first()
		assert prof3 is i
		assert (prof3.serialize == i.serialize)
		i = Instructor.query.filter(Instructor.pname == 'Test Penner').first()
		assert prof4 is i
		assert (prof4.serialize == i.serialize)
		
		#test teaching
		prof1.teach(c1)
		assert (prof1.courses.first()).cid == 'testCourse1'
		prof2.teach(c2)		
		assert (prof2.courses.first()).cid == 'testCourse2'
		prof3.teach(c3)		
		assert (prof3.courses.first()).cid == 'testCourse3'
		prof4.teach(c4)		
		assert (prof4.courses.first()).cid == 'testCourse4'

def run_unit_tests():
	unittest.main()

if __name__ == '__main__':
	unittest.main()
