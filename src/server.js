var http=require('http');
var user=require('./user.js');

http.createServer(function(req,res){
	
	/*res.writeHead(200,{content:'application/json'});
	user.get(11,function (user){
		var response={
		info:"here's your user !!",
		user:user
	}
	res.end(JSON.stringify(response));
	})*/
	
	
}).listen(1337,'127.0.0.1');