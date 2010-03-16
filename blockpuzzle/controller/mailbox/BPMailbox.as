import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.*;

class blockpuzzle.controller.mailbox.BPMailbox extends BPObject {
    
    static var mailbox:BPMailbox;
    
    var messageQueue:BPMessageQueue;
    var observers:Object;
    
    var holdResolution:Boolean;
    
    function BPMailbox() {
        this.messageQueue = new BPMessageQueue();
        this.observers = new Object();
    
        this.holdResolution = false;
        
        BPMailbox.mailbox = this;
    }
    
    /****************************
    *                           *
    * Resolving Posted Messages *
    *                           *
    ****************************/
    
    function resolveMessages() {
        while (messageQueue.anyPendingMessages()) {
            var nextMessage = messageQueue.nextMessage();

            if (nextMessage instanceof BPMessage) {
                resolveMessage( nextMessage );
            } else if (nextMessage instanceof BPDelayedCall) {
                nextMessage.call();
            }
            
            messageQueue.clearMessage( nextMessage );
        }
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

        postMessage( newMessage );
    }
    
    function callLater(object:Object, action, info:Object) {
        var newDelayedCall = new BPDelayedCall(object, action, info);
        
        postMessage( newDelayedCall );
    }
    
    function postMessage(message:Object) {
        var shouldStartResolution = ! messageQueue.anyPendingMessages() && ! holdResolution;
        
        messageQueue.addMessage(message);
        
        // Uncomment the next line to see all mailbox messages as they get posted:
        // //trace("POST\t" + message)

        if (shouldStartResolution) { // if not currently resolving messages...
            resolveMessages();
        }
    }
    
    /*****************************************
    *                                        *
    * Holding and Resuming the Message Queue *
    *                                        *
    *****************************************/
    
    function pause() {
        holdResolution = true;
    }
    
    function resume() {
        holdResolution = false;
        
        if (messageQueue.anyPendingMessages()) {
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
    
}