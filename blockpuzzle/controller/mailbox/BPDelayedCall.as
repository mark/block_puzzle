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
    var note:String;
    
    function BPDelayedCall(self:Object, action, note:String) {
        this.self = self;
        this.action = action;
        this.note = note;
    }
    
    function call() {
        if (action instanceof Function) {
            action.call(self);
        } else {
            self[action].call(self);
        }
    }

}