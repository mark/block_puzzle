import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPMailbox extends BPObject {
    
    static var mailbox:BPMailbox;
    
    var postedMessages:Array;
    var observers:Object;
    
    var delayedCalls:BPDelayedCallQueue;
    
    function BPMailbox() {
        this.postedMessages = new Array();
        this.observers = new Object();
        this.delayedCalls = new BPDelayedCallQueue();
        
        BPMailbox.mailbox = this;
    }
    
    /****************************
    *                           *
    * Resolving Posted Messages *
    *                           *
    ****************************/
    
    function resolveMessages() {
        while (postedMessages.length > 0) {
            var message = postedMessages.shift();
            
            resolveMessage(message);
        }
        
        delayedCalls.makeDelayedCalls();
    }
    
    function resolveMessage(message:BPMessage) {
        var observersForMessage = observers[message.message];
        
        observersForMessage.receivedMessage(message);
    }
    
    /********************
    *                   *
    * Posting a Message *
    *                   *
    ********************/
    
    function post(message:String, source:Object, info:Object) {
        var newMessage = new BPMessage(message, source, info);
        
        postedMessages.push(newMessage);
        
        // Uncomment the next line to see all mailbox messages as they get posted:
        // //trace("POST\t" + message)

        if (postedMessages.length == 1) { // if it was empty before this posting
            resolveMessages();
        }
    }
    
    /********************
    *                   *
    * Adding a Listener *
    *                   *
    ********************/
    
    function listenFor(message:String, source:Object, observer:Object, action:Function) {
        // Uncomment next line to track all listeners...
        // //trace("?> " + message + "\t" + observer);
        
        var observerQueue = observers[message];
        
        if (observerQueue == null) {
            observerQueue = new BPObserverQueue();
            observers[message] = observerQueue;
        }
        
        observerQueue.addObserver(message, source, observer, action);
    }

    /**********************
    *                     *
    * Removing a Listener *
    *                     *
    **********************/

    function removeListener(observer:BPObject) {
        var listeningTo = observer.messagesListeningFor();
        
        for (var i = 0; i < listeningTo.length; i++) {
            var message = listeningTo[i];
            
            removeListenerForMessage(observer, message);
        }
    }

    function removeListenerForMessage(observer:Object, message:String) {
        var observerQueue = observers[message];
        
        observerQueue.removeObserversByObserver(observer);
    }

    /********************
    *                   *
    * Removing a Source *
    *                   *
    ********************/

    function removeSource(source) {
        var listenedTo = source.messagesListenedTo();
        
        for (var i = 0; i < listenedTo.length; i++) {
            var message = listenedTo[i];
            
            removeSourceForMessage(source, message);
        }
    }

    function removeSourceForMessage(source:Object, message:String) {
        var observerQueue = observers[message];
        
        observerQueue.removeObserversBySource(source);
    }
    
    /************************
    *                       *
    * Making a Delayed Call *
    *                       *
    ************************/
    
    function callLater(object:Object, action, note:String) {
        delayedCalls.callLater(object, action, note);
    }

}