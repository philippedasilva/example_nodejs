/*module.exports={
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
			name:"phil"
		}
		callback(user);
	}
}*/

/* CoffeeScript */
module.exports =
  save: (name, callback) ->
    #My code
    user =
      id: '2222'
      name: name
    callback user
    return
  get: (id, callback) ->
    #get a user
    user =
      id: id
      name: 'phil'
    callback user
    return
