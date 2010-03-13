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
    var signals:BPSignalQueue;
    
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
        this.signals = new BPSignalQueue();
        
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
        
        signals.resolveSignals( now() );
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
    
    function addSignal(message:String, seconds:Number, source, info) {
        var triggerWhen = now() + seconds * 1000.0;

        signals.addSignal(message, triggerWhen, source, info);
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