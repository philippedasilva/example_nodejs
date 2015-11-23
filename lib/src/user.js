module.exports={
	save:function(name,callback){
		//My code
		var user={
			id:"2222",
			name:name
		}
		callback(user);
	},
	get:function(id,callback){
		//get a user

		var user={
			id:id,
			name:"cesar"
		}
		callback(user);
	}
}
