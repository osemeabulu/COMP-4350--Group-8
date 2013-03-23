module("Follower Tests");
asyncTest("getFollower", 2,
	function()
	{	
		var num = 1;
		var user = "sam";
		var key = "chris";
		$.getJSON($SCRIPT_ROOT + "users/_query_followers",
		{
					user: user
		}, function(data) {
			equal(data.followed.length,num,"Correct number of matches");
			equal(data.followed[0].username,key,"Follower name matches");
			start();		
		});
	}
);

asyncTest("getFollowerEmpty", 2,
	function()
	{	
		var num = 0;
		var user = "samNotExist";
		$.getJSON($SCRIPT_ROOT + "users/_query_followers",
		{
					user: user
		}, function(data) {
			equal(data.followed.length,num,"Correct number of matches");
			equal(data.followed[0],null,"Result matches");
			start();		
		});
	}
);
