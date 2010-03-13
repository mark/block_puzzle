import blockpuzzle.controller.mailbox.BPMailbox;
import blockpuzzle.controller.pen.BPMouseEvent;
import blockpuzzle.view.clock.BPClock;
import JSON;

class blockpuzzle.base.BPObject {

    // Global ID #
    static var __nextId:Number = 0;
    var __id:Number;

    // Mailbox system
    var __listening:Object;
    var __listenedTo:Object;

    function BPObject() {
        __id = __nextId++;

        trace("INIT " + id() + "\t " + className(null, true).join('.'));
    }

    /*************
    *            *
    * Id Methods *
    *            *
    *************/

    function id():Number {
        return __id;
    }

    /******************
    *                 *
    * Mailbox Methods *
    *                 *
    ******************/
    
    function listenFor(message, source, func) {
        BPMailbox.mailbox.listenFor(message, source, this, func);
    }
    
    function listenForAny(message, func) {
        listenFor(message, null, func);
    }

    function post(message:String, info) {
        BPMailbox.mailbox.post(message, this, info);
    }

    function postLater(message:String, seconds:Number, info) {
        BPClock.clock.addSignal(message, seconds, this, info);
    }
    
    function later(action, note:String) {
        BPMailbox.mailbox.callLater(this, action, note);
    }
    
    // These methods are to keep track of the object's presence in the mailbox,
    // So it can be cleared out.
    
    function stopListening() {
        BPMailbox.mailbox.removeListener(this);
        BPMailbox.mailbox.removeSource(this);
    }
    
    function recordListeningFor(message) {
        if (__listening == null) __listening = new Object();
        __listening[message] = true;
    }
    
    function messagesListeningFor():Array {
        var messages = new Array();
        
        for (var msg in __listening) {
            messages.push(msg);
        }
        
        return messages;
    }
        
    function recordListenedTo(message) {
        if (__listenedTo == null) __listenedTo = new Object();
        __listenedTo[message] = true;
    }
    
    function messagesListenedTo():Array {
        var messages = new Array();
        
        for (var msg in __listenedTo) {
            messages.push(msg);
        }
        
        return messages;
    }
    
    /****************
    *               *
    * Mouse Methods *
    *               *
    ****************/
    
    function mouse():BPMouseEvent {
        return BPMouseEvent.currentMouseEvent;
    }
    
    /********************
    *                   *
    * Cascading Methods *
    *                   *
    ********************/
    
    function callCascade(meths, args) {
        for (var i = 0; i < meths.length; i++) {
            var m = this[meths[i]];
            if (m) return m.apply(this, args);
        }
        
        return null;
    }
    
    /*********************
    *                    *
    * Reflection Methods *
    *                    *
    *********************/
    
    function className(package, full:Boolean) {
        if (package == null) package = _global;
        
        for (var klass in package) {
            // //trace("looking in klass " + klass);
            var t = typeof package[klass];
            
            if (t == "object") {
                var found = className(package[klass], full);
                
                if (found != null) {
                    if (full) {
                        if (found instanceof Array)
                            found.unshift(klass);
                        else
                            found = [ found ];
                     }
                     
                     return found;
                }
            } else if (t == "function") {

                if (package[klass].prototype == this.__proto__) return full ? [ klass ] : klass;
            } else {
                //trace("found " + klass + " of type " + t);
            }
        }
            
        return null;
    }

    function klass():Function {
        return BPObject.classWithName(className(null, true));
    }

    static function classWithName(full_name:Array):Function {
        if (full_name == null) return null;
        
        var obj = _global;
        
        while (full_name.length > 0) {
            obj = obj[full_name.shift()];
        }
        
        return obj;
    }
    
    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
    function toString():String {
        return "#<" + className() + ": " + id() + ">";
    }

}