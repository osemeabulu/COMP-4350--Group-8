module("Post Tests");
asyncTest("getPosts", 2,
	function()
	{	
		var num = 1;
		var user = "sam";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0].owner,user,"Post owner matches");
						start();		
				});
	}
);
asyncTest("getPostsEmpty", 2,
	function()
	{	
		var num = 0;
		var user = "samNotExists";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0],null,"Result matches");
						start();		
				});
	}
);

asyncTest("getFollowersPosts", 2,
	function()
	{	
		var num = 1;
		var user = "sam";
		var owner = "chris";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user_followers",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0].owner,owner,"Post owner matches");
						start();		
				});
	}
);
asyncTest("getFollowersPostsEmpty", 2,
	function()
	{	
		var num = 0;
		var user = "chris";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user_followers",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0],null,"Result matches");
						start();		
				});
	}
);

asyncTest("getFollowingPosts", 2,
	function()
	{	
		var num = 1;
		var user = "sam";
		var owner = "james";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user_following",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0].owner,owner,"Post owner matches");
						start();		
				});
	}
);
asyncTest("getFollowingPostsEmpty", 2,
	function()
	{	
		var num = 0;
		var user = "james";
		getObjects(	$SCRIPT_ROOT + "posts/_query_user_following",
					user,
					function(data)
					{
						equal(data.posts.length,num,"Correct number of matches");
						equal(data.posts[0],null,"Result matches");
						start();		
				});
	}
);
