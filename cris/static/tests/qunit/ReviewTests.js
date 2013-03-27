module("Reviews Tests");
asyncTest("getComp4350", 1,
	function()
	{	
		var cid = "Comp4350";
		var expected = 4;
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/reviews/_query_by_course",
					cid,
					function(data)
					{
						equal(data.reviews[0].rscr, expected, "We have successfully received the one review for Comp4350");
						start();
					});
	}
);

asyncTest("getComp3030", 1,
	function()
	{	
		var cid = "Comp3030";
		var num = 1;
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/reviews/_query_by_course",
					cid,
					function(data)
					{
						equal(data.reviews.length, num, "Successfully haven't received Comp3030");
						start();
					});
	}
);

asyncTest("sendReview", 5,
	function()
	{
		var review = new Object();
			
		review.cid = 'Comp3350';
		review.rscr = 4;
		review.rdesc = 'Test review message...';
		review.rvote = 0;
		review.upvote = 0;
		review.downvote = 0;
		
		sendObjects( $SCRIPT_ROOT + "/reviews/_submit_review",
					 review,
					 function(data)
					 {
						 equal(data.rdesc, review.rdesc, "Succesfully got our description back.");
						 equal(data.rscr, review.rscr, "Successfully got our score back.");
						 equal(data.rvote, review.rvote, "Successfully got our ratio score back.");
						 equal(data.upvote, review.upvote, "Successfully got our likes scores back.");
						 equal(data.downvote, review.downvote, "Successfully got our dislike scores back.");
						 start();
					 });
	}
);

asyncTest("updateReview", 6,
	function()
	{
		//editing review with id 0
		var editedReview = new Object();
			
		editedReview.id = 0;
		editedReview.rscr = 5;
		editedReview.rdesc = 'Edited.';
		editedreview.rvote = 0;
		editedreview.upvote = 0;
		editedreview.downvote = 0;
		
		sendObjects( $SCRIPT_ROOT + "/reviews/_update_review",
					 review,
					 function(data)
					 {
						 equal(data.id, editedReview.rdesc, "Succesfully got our id back.");
						 equal(data.rdesc, editedReview.rdesc, "Succesfully changed our description.");
						 equal(data.rscr, editedReview.rscr, "Successfully changed our score.");
						 equal(data.rvote, review.rvote, "Successfully cleared ratio score.");
						 equal(data.upvote, review.upvote, "Successfully cleared likes scores.");
						 equal(data.downvote, review.downvote, "Successfully cleared dislike scores.");
						 start();
					 });
	}
);

asyncTest("deleteReview", 1,
	function()
	{
		//deleting review with id 0
		var deletedReview = new Object();
			
		editedReview.id = 0;
		
		sendObjects( $SCRIPT_ROOT + "/reviews/_delete_review",
					 review,
					 function(data)
					 {
						 equal(data.success, 'true', "Succesfully deleted review.");
						 start();
					 });
	}
);


asyncTest("CalculateVotes", 3,
	function()
	{
		var review = new Object();
		review.key = 1;
		review.downvote = 4;
		review.upvote = null;
		review.index = 0;
		
		sendObjects($SCRIPT_ROOT + "/reviews/_vote",
		review,
		function(data) 
		{
			equal(data.score, data.up/data.down, "Successfully calculated the vote ratio");	
			equal(data.up, 3, "Successfully got our upvotes");
			equal(data.down, 5, "Successfully got our downvotes");
			start();
			
		});	
	
	}
);
