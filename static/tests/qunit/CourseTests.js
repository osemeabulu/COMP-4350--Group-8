module("Course Tests");
asyncTest("getComp4350", 2,
	function()
	{	
		var cid = "Comp4350";
		var cname = "Software Engineering 2"
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/courses/_query",
					cid,
					function(data)
					{
						equal(data.courses[0].cid, cid, "Course ID Matches");
						equal(data.courses[0].cname, cname, "Course Name Matches");
						start();
					});
	}
);

asyncTest("getComp3030", 2,
	function()
	{
		var cid = "Comp3030";
		var cname = "Automata Theory and Formal Languages";
		
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/courses/_query",
					cid,
					function(data)
					{
						equal(data.courses[0].cid, cid, "Course ID Matches");
						equal(data.courses[0].cname, cname, "Course Name Matches");
						start();
					});
	}
);

asyncTest("getAll", 1,
	function()
	{	
		var cid = "";
		var num = 7;
		//I don't know why the url_for doesn't work here
		getObjects(	$SCRIPT_ROOT + "/courses/_query",
					cid,
					function(data)
					{
						equal(data.courses.length, num, "We have received all courses successfull");
						start();
					});
	}
);