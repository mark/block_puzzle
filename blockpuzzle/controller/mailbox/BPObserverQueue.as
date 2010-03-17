import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPObserverQueue {
    
    var observers:Array;
    var bySource:Object;
    
    function BPObserverQueue() {
        this.observers = new Array();
        this.bySource = new Object();
    }
    
    function addObserver(message:String, source:BPObject, observer:BPObject, action:Function) {
        var observerObj = new BPObserver(message, source, observer, action);
        
        if (source == null) {
            observers.push(observerObj);
        } else {
            if (bySource[ source.id() ] == null) {
                bySource[ source.id() ] = new Array();
            }
            
            bySource[ source.id() ].push( observerObj );
        }
    }

    /*********************
    *                    *
    * Receiving Messages *
    *                    *
    *********************/
    
    function receivedMessage(message:BPMessage) {
        var watchers = bySource[ message.source.id() ];
                
        if ( watchers ) {
            for (var i = 0; i < watchers.length; i++) {
                watchers[i].receivedMessage(message);                
            }
        }
        
        for (var i = 0; i < observers.length; i++) {
            observers[i].receivedMessage(message);
        }
    }
    
    /*********************
    *                    *
    * Removing Observers *
    *                    *
    *********************/
    
    function removeObserversBySource(source:BPObject) {
        delete observers[ source.id() ];
    }
    
    function removeObserversByObserverFromArray(observer:Object, array:Array) {
        var i = 0;
        
        while (i < array.length) {
            if (array[i].isObserverEqualTo(observer))
                array.splice(i, 1);
            else
                i++;
        }
    }
    
    function removeObserversByObserver(observer:Object) {
        removeObserversByObserverFromArray(observer, observers);
        
        for (var k in bySource) {
            removeObserversByObserverFromArray(observer, bySource[ k ]);
        }
    }

}