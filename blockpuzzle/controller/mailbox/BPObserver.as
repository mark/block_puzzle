import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPObserver {
    
    var sourceObject:Object;
    var anySource:Boolean;
    var sourceId:Number;
    
    var observer:Object;
    
    var action:Function;
    
    function BPObserver(message:String, source:Object, observer:Object, action:Function) {
        if (source instanceof BPObject) {
            this.sourceId = source.id();
            this.anySource = false;
            source.recordListenedTo(message);
        } else if (source) {
            this.sourceObject = source;
            this.anySource = false;
        } else {
            this.anySource = true;
        }
            
        this.observer = observer;

        if (observer instanceof BPObject) {
            observer.recordListeningFor(message);
        }
        
        this.action = action;
    }
    
    /*********************
    *                    *
    * Receiving Messages *
    *                    *
    *********************/
    
    function receivedMessage(message:BPMessage) {
        if (anySource || isSourceEqualTo(message.source)) {
            notifyObserver(message);
        }
    }
    
    function notifyObserver(message:BPMessage) {
        action.call(observer, message);
    }
    
    /***************
    *              *
    * For Clearing *
    *              *
    ***************/
    
    function isSourceEqualTo(source:Object):Boolean {
        return source == sourceObject || (source instanceof BPObject && source.id() == sourceId);
    }
    
    function isObserverEqualTo(otherObserver:Object):Boolean {
        return observer == otherObserver;
    }

}