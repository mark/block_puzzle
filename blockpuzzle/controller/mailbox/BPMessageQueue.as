import blockpuzzle.base.BPObject;

class blockpuzzle.controller.mailbox.BPMessageQueue extends BPObject {
    
    var queue:Array;
    
    function BPMessageQueue() {
        this.queue = new Array();
    }
    
    /****************
    *               *
    * Queue Methods *
    *               *
    ****************/
    
    function anyPendingMessages():Boolean {
        return queue.length > 0;
    }
    
    function nextMessage():Object {
        return queue[0];
    }
    
    function clearMessage(object:Object) {
        if (nextMessage() == object) {
            queue.shift();
        }
    }
    
    function addMessage(object:Object) {
        queue.push(object);
    }
    
}