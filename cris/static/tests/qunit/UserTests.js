module("User Tests");
asyncTest("getUser", 3,
	function()
	{	
		var num = 1;
		var key = "test";
		var admin = false;
		getObjects(	$SCRIPT_ROOT + "users/_query_user",
					key,
					function(data)
					{
						equal(data.users.length,num,"Correct number of matches");
						equal(data.users[0].username,key,"Username matches");
						equal(data.users[0].admin,admin,"Account type matches");
						start();		
				});
	}
);
asyncTest("getUserAdmin", 3,
	function()
	{	
		var num = 1;
		var key = "admin";
		var admin = true;
		getObjects(	$SCRIPT_ROOT + "users/_query_user",
					key,
					function(data)
					{
						equal(data.users.length,num,"Correct number of matches");
						equal(data.users[0].username,key,"Username matches");
						equal(data.users[0].admin,admin,"Account type matches");
						start();
					});
	}
);
asyncTest("getUserEmpty", 2,
	function()
	{
		var num = 0;
		var key = "testNotExists";
		getObjects(	$SCRIPT_ROOT + "users/_query_user",
					key,
					function(data)
					{
						equal(data.users.length,num,"Correct number of matches");
						equal(data.users[0],null,"Result matches");
						start();
					});
	}
);
asyncTest("getUserAll", 1,
	function()
	{
		var num = 5;
		getObjects(	$SCRIPT_ROOT + "users/_query",
					null,
					function(data)
					{
						equal(data.users.length,num,"Received all users");
						start();
					});
	}
);
