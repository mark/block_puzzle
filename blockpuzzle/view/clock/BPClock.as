import blockpuzzle.base.BPObject;
import blockpuzzle.view.clock.*;

class blockpuzzle.view.clock.BPClock extends BPObject {

    // The global clock object
    static var clock:BPClock;
    
    // What time is it now?
    var zeroTime:Number;
    var currentTime:Number;
    
    // Keeping track of timers
    var timers:Object;
    
    // Keeping track of signals
    var signals:Array;
    
    /***************
    *              *
    * Constructors *
    *              *
    ***************/
    
    function BPClock() {
        BPClock.clock = this;
        
        setupRoot();
        
        this.zeroTime = new Date().getTime();
        this.currentTime = zeroTime;        
        this.timers = new Object();
        this.signals = new Array();
        
        post("BPStartOfFrame", now());
    }

    function setupRoot() {
        _root._clock = this;
        _root.onEnterFrame = function() { this._clock.onEnterFrame(); }
    }
    
    /***************
    *              *
    * Root Methods *
    *              *
    ***************/
    
    function now() {
        return currentTime - zeroTime;
    }

    function onEnterFrame() {
        this.currentTime = new Date().getTime();        
        
        post("BPStartOfFrame", now());
        
        var index;
        for (index = 0; signals[index].time < now(); index++) {
            var signal = signals[index];
            //BPMailbox.mailbox.post(signal.message, signal.source, signal.info);
        }
        
        signals.splice(0, index);
    }

    /****************
    *               *
    * Timer Methods *
    *               *
    ****************/
    
    // function addTimer(name:String, length:Number):BPTimer {
    //     var newTimer = new BPTimer(name, length);
    //     timers[name] = newTimer;
    //     
    //     return newTimer;
    // }
    
    function addTimer(timer:BPTimer) {
        timers[timer.name] = timer;
    }
    
    function removeTimer(timer:BPTimer) {
        timers[timer.name] = null;
    }
    
    function timerNamed(name:String):BPTimer {
        return timers[name];
    }
    
    /*****************
    *                *
    * Signal Methods *
    *                *
    *****************/
    
    function addSignal(message:String, time:Number, source, info) {
        var triggerWhen = now() + time * 1000.0;
        var i = 0;
        
        while (signals[i].time < triggerWhen) i++;
        
        signals.splice(i, 0, { time: triggerWhen, message: message, source: source, info: info })
    }
    
    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
    function toString():String {
        return "#<BPClock:" + zeroTime + ">";
    }

}