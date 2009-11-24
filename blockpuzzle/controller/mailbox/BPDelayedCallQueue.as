import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPDelayedCallQueue extends BPObject {
    
    var delayedCalls:Array;
        
    function BPDelayedCallQueue() {
        this.delayedCalls = new Array();
    }
    
    function callLater(object:Object, action, note:String) {
        var newDelayedCall = new BPDelayedCall(object, action, note);
        
        delayedCalls.push(newDelayedCall);
    }
    
    function makeDelayedCalls() {
        if (closeGate('makeDelayedCalls')) return;
        
        while (delayedCalls.length > 0) {
            delayedCalls.shift().call();
        }
        
        openGate('makeDelayedCalls');
    }
}