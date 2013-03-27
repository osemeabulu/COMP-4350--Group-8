module("Instructor Tests");
asyncTest("getJohnB", 1,
	function()
	{	
		var pname = "John Braico"
		
		getObjects(	$SCRIPT_ROOT + "/instructors/_query",
					pname,
					function(data)
					{
						equal(data.instructors[0].pname, pname, "Instructor name Matches");
						start();
					});
	}
);

asyncTest("getAll", 1,
	function()
	{	
		var pname = "";
		var num = 11;
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/instructors/_query",
					pname,
					function(data)
					{
						equal(data.instructors.length, num, "We have received all instructors successfully");
						start();
					});
	}
);
