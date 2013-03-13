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
		var num = 0;
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/reviews/_query_by_course",
					cid,
					function(data)
					{
						equal(data.reviews.length, num, "Have successfully haven't received any course for Comp3030");
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

asyncTest("CalculateVotes", 3,
	function()
	{
		var cid = "Comp4350";
		var downvote = 4;
		var upvote = 1;
		var i = 0;
		
		$.getJSON($SCRIPT_ROOT + "/reviews/_vote",
		{
			uvote: upvote,
			dvote: downvote,
			course: cid,
			key: i
			
		}, function(data) {
			equal(data.score, 0.25, "Successfully calculated the vote ratio");	
			equal(data.up, upvote, "Successfully got our upvotes");
			equal(data.down, downvote, "Successfully got our downvotes");
			start();
			
		});	
	
	}
);