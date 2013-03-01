//Make sure to include jquery before this in any html file that uses it

//accepts a url, value, and function callback
//and sends a request for a json object to the server
//the function callback is mostly for testing
function getObjects(url, val, func)
{
	$.getJSON(url, {key: val}, func);
}