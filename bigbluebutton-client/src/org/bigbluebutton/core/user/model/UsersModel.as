package org.bigbluebutton.core.user.model
{
  import mx.collections.ArrayCollection;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.user.model.vo.Status;
  import org.bigbluebutton.core.user.model.vo.User;

  public class UsersModel
  {   
    public var myUserID:String;    
    private var _users:ArrayCollection = new ArrayCollection();	
    
    public function addUsers(users:ArrayCollection):void {
      for (var i:int = 0; i < users.length; i++) {
        addUser(users.getItemAt(i) as User);
      }
    }
    
    public function addUser(u:User):void {
      LogUtil.debug("Adding new user [" + u.userid + "]");
      if (! hasUser(u.userid)) {
        LogUtil.debug("Am I this new user [" + u.userid + ", " + myUserID + "]");
        if (u.userid == myUserID) {
          u.me = true;
        }						
        
        _users.addItem(u);
        sort();
      }	      
    }
    
    public function removeUser(id:String):void {
        var p:Object = getUserIndex(id);
        if (p != null) {
          LogUtil.debug("removing user[" + p.participant.name + "," + p.user.userid + "]");				
          _users.removeItemAt(p.index);
          sort();
        }							   
    }
    
    public function changeUserStatus(id:String, status:Status):void {
      
    }
    
    private function getUserIndex(userID:String):Object {
      var aUser:User;
      
      for (var i:int = 0; i < _users.length; i++) {
        aUser = _users.getItemAt(i) as User;
        
        if (aUser.userid == userID) {
          return {index:i, user:aUser};
        }
      }				
      
      // User not found.
      return null;
    }
    
    public function hasUser(userID:String):Boolean {
      var p:Object = getUserIndex(userID);
      if (p != null) {
        return true;
      }
      
      return false;		
    }
    
    public function getUser(userID:String):User {
      var u:Object = getUserIndex(userID);
      if (u != null) {
        return u.user;
      }
      return null;
    }
    
    /**
     * Sorts the users by name 
     * 
     */		
    private function sort():void {
      _users.source.sortOn("name", Array.CASEINSENSITIVE);	
      _users.refresh();				
    }	
  }
}