import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.BPMessage;
import blockpuzzle.view.clock.*;

class blockpuzzle.view.clock.BPTimer extends BPObject {
    
    // The name of this timer
    var name:String;
    
    // For calculating seconds(), secondsLeft(), and completion()
    var startingTime:Number;
    var now:Number;
    
    // For secondsLong()
    var totalSeconds:Number;
    
    // For sending ticks
    var interval:Number;
    var nextInterval:Number;
    var storedUntilNextInterval:Number;
    
    // For stopping
    var endingTime:Number;
    
    // For pausing
    var isPaused:Boolean;
    var timeStored:Number;
    
    function BPTimer(name:String, totalSeconds:Number, tickSeconds:Number) {
        this.name = name;
        
        this.startingTime = BPClock.clock.now();
        this.now = startingTime;

        this.isPaused = false;
        
        this.interval = (tickSeconds == null) ? 1000 : Math.floor(tickSeconds * 1000);
        this.nextInterval = startingTime + interval;
        
        if (totalSeconds != null) {
            this.totalSeconds = totalSeconds;
            this.endingTime = startingTime + totalSeconds * 1000;
        }
        
        BPClock.clock.addTimer(this);

        later(start);
    }
    
    /******************
    *                 *
    * Clock Functions *
    *                 *
    ******************/
    
    function start() {
        listenForAny("BPStartOfFrame", everyFrame);

        post("BPTimerStart");
    }
    
    function everyFrame(message:BPMessage) {
        this.now = Number(message.info);
        
        if (isPaused) return;
        
        if (endingTime != null && now >= endingTime) {
            post("BPTimerStop");
            
            stopListening();
            BPClock.clock.removeTimer(this);
        } else {
            if (now >= nextInterval) {
                nextInterval += interval;

                post("BPTimerTick", seconds());
            }
            
            post("BPTimerActive", seconds());
        }
    }
    
    /****************
    *               *
    * Timer methods *
    *               *
    ****************/
    
    function reset() {
        this.endingTime = now + (endingTime - startingTime);
        this.nextInterval = now + interval;

        this.startingTime = now;
    }
    
    function pause() {
        if (isPaused) return;
        
        isPaused = true;
        
        this.timeStored = endingTime - now;
        this.storedUntilNextInterval = nextInterval - now;    
    }
    
    function unpause() {
        if (! isPaused) return;
        
        isPaused = false;
        
        this.endingTime = now + timeStored;
        //trace("storedUntilNextInterval = " + storedUntilNextInterval);
        this.nextInterval = now + storedUntilNextInterval;
    }
    
    /********************
    *                   *
    * Seconds() Methods *
    *                   *
    ********************/
    
    function seconds():Number {
        return (now - startingTime) / 1000.0;
    }
    
    function secondsLong():Number {
        return totalSeconds;
    }
    
    function secondsLeft():Number {
        return secondsLong() - seconds();
    }
    
    function completion():Number {
        var rawCompletion = seconds() / secondsLong();
        
        return (rawCompletion > 1.0) ? 1.0 : rawCompletion;
    }
    
    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
    function toString():String {
        return "#<BPTimer: " + name + ">";
    }

}