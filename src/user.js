module.exports={
	save:function(name,callback){
		
		var user={
			id:"2222",
			name:name
		}
		callback(user);
	},
	get:function(id,callback){
		
		var user={
			name:"phil",
			id:id
		}
		callback(user);
	}
}