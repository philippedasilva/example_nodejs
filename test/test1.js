//TEST

var should = require('should');
var user = require('../lib/src/user');

/*describe('server',function(){
  it('stop & start',function(){
    users.get(11,function(user){
      user.id.should.equal(11);
      
    })
  })

})*/


var assert = require('assert');
describe('Array', function() {
  describe('#indexOf()', function () {
    it('should return -1 when the value is not present', function () {
      assert.equal(-1, [1,2,3].indexOf(5));
      assert.equal(-1, [1,2,3].indexOf(0));
    });
  });
});

describe('User', function() {
  describe('#save()', function() {
    //Test save sans erreur
	it('Save without error', function(done) {
      
	  user.save(12,function (user,err){
		var response={
		info:"One user",
		user:user
		}
		if (err) throw err;
        done();
		
		});
    });
	
	//On "oublie" de mettre l'id 
	it('Save with error', function(done) {
      
	  user.save(function (user,err){
		var response={
		info:"One user",
		user:user
		}
		if (err) throw err;
        done();
		
		});
    });
	
  });
  
  
  describe('#get()', function() {
    
	 user.get(11,function (user){
		var response={
		info:"One user",
		user:user
		}
		
		//Correct on a égalité entre l'id et le paramètre de test
		it('Get correct', function() {
		assert.equal(11,response.user.id);
        });
		
		//Incorrect on a ici inégalité entre l'id et le paramètre
		it('Get incorrect', function(done) {
		assert.equal(12,response.user.id);
		if (err) throw err;
        done();
        });
		
	  });
	  
	  
	  
    });
});
