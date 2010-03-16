import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPDelayedCallQueue extends BPObject {
    
    var delayedCalls:Array;
        
    function BPDelayedCallQueue() {
        this.delayedCalls = new Array();
    }
    
    // Adds a new delayed call to the queue
    function callLater(object:Object, action, info:Object) {
        var newDelayedCall = new BPDelayedCall(object, action, info);
        
        delayedCalls.push(newDelayedCall);
    }

    // Gets the list of pending delayed calls, and clears the list
    function getDelayedCalls():Array {
        var callsToMake = delayedCalls;
        delayedCalls = new Array();
        
        return callsToMake;
    }
    
    // Are there any pending delayed calls to be made?
    function anyDelayedCalls():Boolean {
        return delayedCalls.length > 0;
    }

    // Calls all of the delayed calls waiting to be called.
    // If more delayed calls are posted while the current list is
    // resolving, then calls them, too.
    // Finishes when there are no more delayed calls pending.
    function makeDelayedCalls() {
        while (anyDelayedCalls()) {

            var callsToMake = getDelayedCalls();
            
            for (var i = 0; i < callsToMake.length; i++) {
                callsToMake[i].call();
            }

        }
    }

}