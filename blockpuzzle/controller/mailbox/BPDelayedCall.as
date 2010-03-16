/*
    This class encapsulates a method that will be called "later"--at
    some unspecified point later in the frame.
    
    The method provided can be a function, or the name for the method
    to be called on the object.
    
    Do not instantiate these directly.  For subclasses of BPObject,
    you can create them by calling later(...).  For non-subclasses of
    BPObject, call BPMailbox.mailbox.callLater(...).
*/

class blockpuzzle.controller.mailbox.BPDelayedCall {
    
    var self:Object;
    var action;
    var info:Object;
    
    function BPDelayedCall(self:Object, action, info:Object) {
        this.self = self;
        this.action = action;
        this.info = info;
    }
    
    function call() {
        if (action instanceof Function) {
            action.call(self, info);
        } else {
            self[action].call(self, info);
        }
    }

}