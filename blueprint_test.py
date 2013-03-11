import os
import unittest
from cris.config import TestConfig
from cris import create_app
from cris.extensions import db
#database objects currently being tested:
from cris.courses.model import Course
from cris.reviews.model import Review 
from cris.users.model import User
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
    
        
    def test_course_bp(self):
		c1 = Course('Comp2150', 'this is a test course name 1', 'this is a test description 1', 'Science')
		c2 = Course('Comp3350', 'this is a test course name 2', 'this is a test description 2', 'Science')
 
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
		
		#test to ensure the querying partial word returns a result	
		rv = self.app.get('/courses/_query?key=comp3350')
		d = json.loads(rv.data)	
		course = d['courses'][0]['cid']
		
		self.assertEquals(course, 'Comp3350')
		
		rv = self.app.get('/courses/_top_query')
		d = json.loads(rv.data)
		courses = d['courses']	
		count = 0;
		
		#tests to ensure that the response from server equals the expected averages
		for course in courses:
			self.assertEquals(course['avg'], avglist[count])
			count+=1
		
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
				
		rv = self.app.get('/reviews/_query_by_course?key=Comp4350')
		d = json.loads(rv.data)
		reviews = d['reviews']	
		count = 0;
		       
        #tests to ensure that the response from server equals the expected sorted votes
		for review in reviews:
			self.assertEquals(review['rvote'], votelist[count])
			count+=1
			
		rv = self.app.post('reviews/_vote', content_type='application/json', data = json.dumps({
		'key': 2,
		'index': 2,
		'upvote': 4,
		'downvote': 0}))
		
		r = Review.query.get(2)
		
		#tests to ensure that the response from server equals the expected upvotes and vote ratio for a review
		self.assertEquals(r.upvote, 5)
		self.assertEquals(r.rvote, 2.5)
		
				
if __name__ == '__main__':
    unittest.main()