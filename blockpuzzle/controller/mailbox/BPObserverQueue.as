import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPObserverQueue {
    
    var observers:Array;
    
    function BPObserverQueue() {
        this.observers = new Array();
    }
    
    function addObserver(message:String, source:Object, observer:Object, action:Function) {
        var observerObj = new BPObserver(message, source, observer, action);
        
        observers.push(observerObj);
    }

    /*********************
    *                    *
    * Receiving Messages *
    *                    *
    *********************/
    
    function receivedMessage(message:BPMessage) {
        for (var i = 0; i < observers.length; i++) {
            observers[i].receivedMessage(message);
        }
    }
    
    /*********************
    *                    *
    * Removing Observers *
    *                    *
    *********************/
    
    function removeObserversBySource(source:Object) {
        var i = 0;
        
        while (i < observers.length) {
            if (observers[i].isSourceEqualTo(source))
                observers.splice(i, 1);
            else
                i++;
        }
    }
    
    function removeObserversByObserver(observer:Object) {
        var i = 0;
        
        while (i < observers.length) {
            if (observers[i].isObserverEqualTo(observer))
                observers.splice(i, 1);
            else
                i++;
        }
    }

}