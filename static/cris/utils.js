//Make sure to include jquery before this in any html file that uses it

//accepts a url, value, and function callback
//and sends a request for a json object to the server
//the function callback is mostly for testing
function getObjects(url, val, func)
{
	$.getJSON(url, {key: val}, func);
}

//accepts a url, an object to send, and function callback
//it sends the json object and runs the function on success using the ajax call.
//Note: .post jquery call didn't work
function sendObjects(url, val, func)
{
	$.ajax({
		type: "POST",
		contentType: "application/json; charset=utf-8",
		url: url,
		data: JSON.stringify(val),
		success: func,
		dataType:"json"
	});
	//var jsonString = JSON.stringify(val);
	
	//$.post(url, jsonString, func, { contentType: 'application/json'});
}