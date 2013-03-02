module("Reviews Tests");
asyncTest("getComp4350", 1,
	function()
	{	
		var cid = "Comp4350";
		var expected = 0.85;
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/reviews/_query_by_course",
					cid,
					function(data)
					{
						equal(data.reviews[0].rscr, 0.85, "We have successfully received the one review for Comp4350");
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

asyncTest("sendReview", 2,
	function()
	{
		var review = new Object();
			
		review.cid = 'Comp3350';
		review.rscr = 4;
		review.rdesc = 'Test review message...';
		review.rvote = 0;
		
		sendObjects( $SCRIPT_ROOT + "/reviews/_submit_review",
					 review,
					 function(data)
					 {
						 equal(data.rdesc, review.rdesc, "Succesfully got our description back.");
						 equal(data.rscr, review.rscr, "Successfully gout our score back.");
						 start();
					 });
	}
);
