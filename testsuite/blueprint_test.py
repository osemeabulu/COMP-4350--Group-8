import os
import unittest
from cris.config import TestConfig
from cris import create_app
from cris.extensions import db
#database objects currently being tested:
from cris.courses.model import Course
from cris.reviews.model import Review 
from cris.users.model import User
from cris.instructors.model import Instructor
import json
from flask import jsonify

class BlueprintTestCase(unittest.TestCase):

    def setUp(self):
        application = create_app(None, TestConfig)
        self.app = application.test_client()
        db.create_all()
        
    def tearDown(self):
		db.session.remove()
		db.drop_all
		os.remove('/tmp/tests.db')
    
    #test course semester
    def test_course_bp(self):
		c1 = Course('Comp2150', 'this is a test course name 1', 'this is a test description 1', 'Science', 'Fall')
		c2 = Course('Comp3350', 'this is a test course name 2', 'this is a test description 2', 'Science', 'Winter')
 
		db.session.add(c1)
		db.session.add(c2)
		db.session.commit()
		
		r1 = Review('Comp2150', 5, 'this is a test review 1', 0.75, 3, 4, 'user1')
		r2 = Review('Comp2150', 5, 'this is a test review 2', 0.75, 3, 4, 'user2')
		r3 = Review('Comp3350', 3, 'this is a test review 3', 0.75, 3, 4, 'user3')
		r4 = Review('Comp3350', 5, 'this is a test review 4', 0.75, 3, 4, 'user4')

		db.session.add(r1)
		db.session.add(r2)
		db.session.add(r3)
		db.session.add(r4)
		db.session.commit()
    	
    		#list of averages to assert with
		avglist = [5, 4]
    	
    		#test to ensure url opens the specified course description page
		rv = self.app.get('/courses/Comp2150')
		self.assertEquals(rv.status_code, 200)
		rv = self.app.get('/courses/Comp3350')
		self.assertEquals(rv.status_code, 200)		
		#test fetching app that doesn't exist
		rv = self.app.get('/courses/Comp2222')
		self.assertEquals(rv.status_code, 404)
				
		#test to ensure the querying partial word returns a result
		rv = self.app.get('/courses/_query?key=comp')
		d = json.loads(rv.data)	
		course = d['courses'][0]['cid']
		self.assertEquals(course, 'Comp2150')
		course = d['courses'][1]['cid']
		self.assertEquals(course, 'Comp3350')
		#testing querying exact matches		
		rv = self.app.get('/courses/_query?key=comp3350')
		d = json.loads(rv.data)	
		course = d['courses'][0]['cid']		
		self.assertEquals(course, 'Comp3350')
		rv = self.app.get('/courses/_query?key=comp2150')
		d = json.loads(rv.data)	
		course = d['courses'][0]['cid']		
		self.assertEquals(course, 'Comp2150')
		#test empty query (should return both courses)
		rv = self.app.get('/courses/_query?key=')
		d = json.loads(rv.data)	
		courses = d['courses']	
		self.assertEquals(len(courses), 2)
		self.assertEquals(d['courses'][0]['cid'], 'Comp2150')
		self.assertEquals(d['courses'][1]['cid'], 'Comp3350')
		#test null query
		rv = self.app.get('/courses/_query?key=null')
		d = json.loads(rv.data)	
		self.assertEquals(d['courses'], [])
		#test top_query (returns the top rated courses)
		rv = self.app.get('/courses/_top_query')
		d = json.loads(rv.data)
		courses = d['courses']	
		count = 0;
		#tests to ensure that the response from server equals the expected averages
		for course in courses:
			self.assertEquals(course['avg'], avglist[count])
			count+=1
		
		#test url for semester (only have fall and winter)
		rv = self.app.get('/courses/_semester/Fall')
		self.assertEquals(rv.status_code, 200)
		rv = self.app.get('/courses/_semester/Winter')
		self.assertEquals(rv.status_code, 200)		
		rv = self.app.get('/courses/_semester/Summer')
		self.assertEquals(rv.status_code, 200)
		rv = self.app.get('/courses/_semester/') 	#should fail
		self.assertEquals(rv.status_code, 404)
		#test semester data
		rv = self.app.get('/courses/_semester/Fall')
		d = json.loads(rv.data)
		self.assertEquals(len(d['courses']), 1)
		self.assertEquals(d['courses'][0]['cid'], 'Comp2150')
		rv = self.app.get('/courses/_semester/Winter')
		d = json.loads(rv.data)
		self.assertEquals(len(d['courses']), 1)
		self.assertEquals(d['courses'][0]['cid'], 'Comp3350')
		rv = self.app.get('/courses/_semester/Summer') 	#empty
		d = json.loads(rv.data)
		self.assertEquals(d['courses'], [])

    def test_review_bp(self):
		r1 = Review('Comp4350', 1, 'this is another test review 1', 3, 3, 1, 'user1')
		db.session.add(r1)
		db.session.commit()
				
		rv = self.app.post('reviews/_submit_review', content_type='application/json', data = json.dumps({
		'cid':'Comp4350',
		'rscr': 4,
		'rdesc': 'this is another test review 2',
		'rvote': 2,
		'upvote': 4,
		'downvote': 2}))
		
		votelist = [3, 2]
		
		#tests that server responses with a review page
		self.assertEquals(rv.status_code, 200)
				
		rv = self.app.get('reviews/_query_by_course?key=Comp4350')
		d = json.loads(rv.data)
		reviews = d['reviews']	
		count = 0;

        	#tests to ensure that the response from server equals the expected sorted votes
		for review in reviews:
			self.assertEquals(review['rvote'], votelist[count])
			count+=1
			
		#test submitting for course that does not exist
		rv = self.app.post('reviews/_submit_review', content_type='application/json', data = json.dumps({
		'cid': 'test',
		'rscr': 0,
		'rdesc': '',
		'rvote': 0,
		'upvote': 0,
		'downvote': 0}))
		#test response
		self.assertEquals(rv.status_code, 200) #test succeeds, but should fail... need to add error checking
		rv = self.app.get('/reviews/_query_by_course?key=test')
		d = json.loads(rv.data)
		self.assertEquals(d['reviews'][0]['cid'], 'test')

		#test submitting wonky upvotes and downvotes 
		rv = self.app.post('reviews/_submit_review', content_type='application/json', data = json.dumps({
		'cid': 'test2',
		'rscr': 0,
		'rdesc': '',
		'rvote': 1000000,
		'upvote': 1000000,
		'downvote': 0}))
		#test response
		self.assertEquals(rv.status_code, 200) #testing we don't crash
		rv = self.app.get('/reviews/_query_by_course?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(d['reviews'][0]['rvote'], 1000000)
		self.assertEquals(d['reviews'][0]['upvote'], 1000000)

		#test submitting Null upvotes and downvotes 
		rv = self.app.post('reviews/_submit_review', content_type='application/json', data = json.dumps({
		'cid': 'test3',
		'rscr': 0,
		'rdesc': '',
		'rvote': None,
		'upvote': None,
		'downvote': None}))
		#test response
		self.assertEquals(rv.status_code, 200) #testing we don't crash
		rv = self.app.get('/reviews/_query_by_course?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(d['reviews'][0]['rvote'], None)
		self.assertEquals(d['reviews'][0]['upvote'], None)
		self.assertEquals(d['reviews'][0]['downvote'], None)

		#test voting
		rv = self.app.post('reviews/_vote', content_type='application/json', data = json.dumps({
		'key': 2,
		'index': 2,
		'upvote': 4,
		'downvote': 0}))
		
		r = Review.query.get(2)
		
		#tests to ensure that the response from server equals the expected upvotes and vote ratio for a review
		self.assertEquals(r.upvote, 5)
		self.assertEquals(r.rvote, 2.5)
		
		#test deleting a review
		rv1 = Review.query.filter(Review.id == 3).first() #gets a test review
		rv = self.app.post('reviews/_delete_review', content_type='application/json', data = json.dumps({
		'id': rv1.id}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['key'], rv1.id)
		rv1 = Review.query.filter(Review.id == 3).first() #gets a test review
		self.assertEquals(rv1, None) #confirm the delete was successful
				
		#Try to delete a review that doesn't exist
		rv = self.app.post('reviews/_delete_review', content_type='application/json', data = json.dumps({
		'id': 100}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = rv.data
		self.assertEquals(d, "Delete failed")

		#Try to delete a null review
		rv = self.app.post('reviews/_delete_review', content_type='application/json', data = json.dumps({
		'id': None}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = rv.data
		self.assertEquals(d, "Delete failed")

		#test updating a review
		rv1 = Review.query.filter(Review.id == 4).first() #gets a test review
		rv = self.app.post('reviews/_update_review', content_type='application/json', data = json.dumps({
		'id': rv1.id,
		'cid': 'test2',
		'rscr': 0,
		'rdesc': 'Here is some text I changed',
		'rvote': 0,
		'upvote': 0,
		'downvote': 0}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		rv1 = Review.query.filter(Review.id == 4).first() #gets a test review
		self.assertEquals(d['rID'], rv1.id)
		self.assertEquals(rv1.rdesc, 'Here is some text I changed') #confirm the update was successful
				
		#Try to update a review that doesn't exist
		rv = self.app.post('reviews/_update_review', content_type='application/json', data = json.dumps({
		'id': 100,
		'cid': 'test2',
		'rscr': 0,
		'rdesc': 'Here is some text I changed',
		'rvote': 0,
		'upvote': 0,
		'downvote': 0}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = rv.data
		self.assertEquals(d, "Update Failed")

		#Try to delete a null review
		rv = self.app.post('reviews/_update_review', content_type='application/json', data = json.dumps({
		'id': None,
		'cid': 'test2',
		'rscr': 0,
		'rdesc': 'Here is some text I changed',
		'rvote': 0,
		'upvote': 0,
		'downvote': 0}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = rv.data
		self.assertEquals(d, "Update Failed")

		#Testing query_by_user
		rv = self.app.get('/reviews/_query_by_user?key=None')
		d = json.loads(rv.data)
		self.assertEquals(d['reviews'], [])		
				
    def test_user_bp(self):
		testUser1 = User('test', 'password')
		testAdmin1 = User('admin', 'password', True)
		db.session.add(testUser1)
		db.session.add(testAdmin1)		
		db.session.commit()

		#test querying all users
		rv = self.app.get('users/_query')
		d = json.loads(rv.data)
		users = d['users']	
		self.assertEquals(len(users), 2)		
		self.assertEquals(d['users'][0]['username'], testUser1.username)		
		self.assertEquals(d['users'][1]['username'], testAdmin1.username)		

		#test querying a specific user
		rv = self.app.get('users/_query_user?key=test')
		d = json.loads(rv.data)
		users = d['users']	
		self.assertEquals(len(users), 1)		
		self.assertEquals(users[0]['username'], testUser1.username)		
		rv = self.app.get('users/_query_user?key=admin')
		d = json.loads(rv.data)
		users = d['users']	
		self.assertEquals(len(users), 1)		
		self.assertEquals(users[0]['username'], testAdmin1.username)		
		rv = self.app.get('users/_query_user?key=Null')
		d = json.loads(rv.data)
		users = d['users']	
		self.assertEquals(len(users), 0)		
		self.assertEquals(users, [])		

		#test displaying user page
		rv = self.app.get('users/test')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		rv = self.app.get('users/admin')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		rv = self.app.get('users/null')
		self.assertEquals(rv.status_code, 404) #should get 404 if user doesn't exist
				
		#confirm that no one is logged in
		rv = self.app.get('users/_check_session')
		d = json.loads(rv.data)
		self.assertEquals(d['session'], 'not logged in')
	
		#test check_session and login
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': testUser1.username,
		'pass': testUser1.password}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testUser1.username)
		#confirm that log in worked		
		rv = self.app.get('users/_check_session')
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testUser1.username)

		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': testAdmin1.username,
		'pass': testAdmin1.password}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testAdmin1.username)
		#confirm that log in worked		
		rv = self.app.get('users/_check_session')
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testAdmin1.username)
		
    def test_followers_bp(self):
		testUser1 = User('test', 'password')
		testUser2 = User('test2', 'password')
		testUser3 = User('test3', 'password')
		testAdmin1 = User('admin', 'password', True)
		db.session.add(testUser1)
		db.session.add(testUser2)
		db.session.add(testUser3)
		db.session.add(testAdmin1)		
		db.session.commit()

		#check that there are no followers
		rv = self.app.get('users/_query_followers?user=test')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_followers?user=admin')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_followers?user=Null')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])

		#check that there are no one following
		rv = self.app.get('users/_query_following?user=test')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_following?user=admin')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_following?user=Null')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], [])

		#try logging in so we can add following (these methods are context dependent in that they 
		#rely on a user to be logged in (since it will pull the username from the session
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': testUser1.username,
		'pass': testUser1.password}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testUser1.username)
		#test following
		rv = self.app.get('users/_follow_user?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'], True)
		rv = self.app.get('users/_check_follower?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(d['followed'][0]['followed'], True)
		
		#log into another user to test followed
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': 'test2',
		'pass': 'password'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], 'test2')
		#test following
		rv = self.app.get('users/_follow_user?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], True)
		rv = self.app.get('users/_check_follower?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'][0]['followed'], True)
		#test following a user that doesn't exist
		rv = self.app.get('users/_follow_user?key=testing')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], False)
		
		#test follower/following queries (relationship is test->test2->test3)
		rv = self.app.get('users/_query_following?user=test')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'][0]['username'], 'test2')
		rv = self.app.get('users/_query_followers?user=test')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_following?user=test2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'][0]['username'], 'test3')
		rv = self.app.get('users/_query_followers?user=test2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'][0]['username'], 'test')
		rv = self.app.get('users/_query_following?user=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_followers?user=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'][0]['username'], 'test2')
		#test querying null
		rv = self.app.get('users/_query_following?user=null')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], [])
		rv = self.app.get('users/_query_followers?user=null')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], [])

    def test_posts_bp(self):
		testUser1 = User('test', 'password')
		testUser2 = User('test2', 'password')
		testUser3 = User('test3', 'password')
		testAdmin1 = User('admin', 'password', True)
		db.session.add(testUser1)
		db.session.add(testUser2)
		db.session.add(testUser3)
		db.session.add(testAdmin1)		
		db.session.commit()
		
		#test that the users have no posts
		rv = self.app.get('posts/_query_user?key=test')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_followers?key=test')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_following?key=test')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_followers?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_following?key=tes2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_followers?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_following?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user?key=admin')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_followers?key=admin')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_following?key=admin')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		#test null
		rv = self.app.get('posts/_query_user?key=null')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_followers?key=null')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])
		rv = self.app.get('posts/_query_user_following?key=null')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['posts'], [])

		#first we try creating a post without logging in
		rv = self.app.post('posts/_submit_post', content_type='application/json', data = json.dumps({
		'msg': 'hey! this post should not work!'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['posted'], False)

		#log in so we can create posts
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': 'test',
		'pass': 'password'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], testUser1.username)
		#test posting
		rv = self.app.post('posts/_submit_post', content_type='application/json', data = json.dumps({
		'msg': 'test! this post should work!'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['posted'], True)
		#add a follow for testing followers posts later
		rv = self.app.get('users/_follow_user?key=test2')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], True)
		#try posting as another user
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': 'test2',
		'pass': 'password'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], 'test2')
		#test posting
		rv = self.app.post('posts/_submit_post', content_type='application/json', data = json.dumps({
		'msg': 'test2! this post should work!'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['posted'], True)
		#add a follower for testing followers posts later
		rv = self.app.get('users/_follow_user?key=test3')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(d['followed'], True)
		#try posting as another user
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': 'test3',
		'pass': 'password'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], 'test3')
		#test posting
		rv = self.app.post('posts/_submit_post', content_type='application/json', data = json.dumps({
		'msg': 'test3! this post should work!'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['posted'], True)

		#test querying followers of the logged in user
		rv = self.app.post('users/_check_session', content_type='application/json', data = json.dumps({
		'name': 'test2',
		'pass': 'password'}))
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(d['session'], 'test2')
		
		rv = self.app.get('posts/_query')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(len(d['posts']), 1)
		self.assertEquals(d['posts'][0]['message'], 'test2! this post should work!')
		rv = self.app.get('posts/_query_following')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(len(d['posts']), 1)
		self.assertEquals(d['posts'][0]['message'], 'test3! this post should work!')
		rv = self.app.get('posts/_query_followers')
		d = json.loads(rv.data)
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		self.assertEquals(len(d['posts']), 1)
		self.assertEquals(d['posts'][0]['message'], 'test! this post should work!')

    #Testing Instructors Blueprint
    def test_instructors_bp(self):
		prof1 = Instructor('Test Zapp')
		prof2 = Instructor('Test Braico')
		prof3 = Instructor('Test Marshall')
		prof4 = Instructor('Test Penner')

		db.session.add(prof1)
		db.session.add(prof2)
		db.session.add(prof3)
		db.session.add(prof4)
		db.session.commit()

		#test index route
		rv = self.app.get('instructors/')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		
		#test fetching instructor pages	
		rv = self.app.get('instructors/Test Zapp')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		rv = self.app.get('instructors/Test Braico')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		rv = self.app.get('instructors/Test Marshall')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		rv = self.app.get('instructors/Test Penner')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		#testing fetching an instructor page that doesn't exist
		rv = self.app.get('instructors/Test')
		self.assertEquals(rv.status_code, 404) #testing we don't get errors
		
		#testing partial query
		rv = self.app.get('instructors/_query?key=Test')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 4) #testing we don't get errors
		#testing specific query
		rv = self.app.get('instructors/_query?key=Test Zapp')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 1) #testing we don't get errors
		self.assertEquals(d['instructors'][0]['pname'], 'Test Zapp') #testing we don't get errors
		rv = self.app.get('instructors/_query?key=Test Braico')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 1) #testing we don't get errors
		self.assertEquals(d['instructors'][0]['pname'], 'Test Braico') #testing we don't get errors
		rv = self.app.get('instructors/_query?key=Test Marshall')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 1) #testing we don't get errors
		self.assertEquals(d['instructors'][0]['pname'], 'Test Marshall') #testing we don't get errors
		rv = self.app.get('instructors/_query?key=Test Penner')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 1) #testing we don't get errors
		self.assertEquals(d['instructors'][0]['pname'], 'Test Penner') #testing we don't get errors
		#testing null query
		rv = self.app.get('instructors/_query?key=Null')
		self.assertEquals(rv.status_code, 200) #testing we don't get errors
		d = json.loads(rv.data)
		self.assertEquals(len(d['instructors']), 0) #testing we don't get errors
		self.assertEquals(d['instructors'], []) #testing we don't get errors

def run_blueprint_tests():
	unittest.main()

if __name__ == '__main__':
    unittest.main()
