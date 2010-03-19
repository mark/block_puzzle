import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.BPMessage;
import blockpuzzle.view.clock.*;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPAnimation extends BPSchedulable {

    var duration:Number;
    
    /**************
    *             *
    * Constructor *
    *             *
    **************/
    
    function BPAnimation() {
        duration = 0.0; // Instantaneous, unless otherwise specified

		listenForAny("BPFinishAllAnimations", finish); // For finishing all animations
		listenForAny("BPCancelAllAnimations", cancel); // For cancelling all animations
    }
    
    /*******************
    *                  *
    * Starting Methods *
    *                  *
    *******************/
    
    function start() {
        super.start();

        animate(0.0);
        
        readyDuration();
    }
    
    /******************
    *                 *
    * Animation Frame *
    *                 *
    ******************/

    function runFrame(message:BPMessage) {
        var runTimer = message.source;
        
        animate(completion(runTimer));
    }
    
    function completion(runTimer:BPTimer) {
        if ( isContinuous() ) {
            return 0.0;
        } else if ( isInstantaneous() ) {
            return 1.0;
        } else {
            return runTimer.completion();
        }
    }
    
    function animate(completion:Number) {
        // OVERRIDE ME!
    }

    function elapsed():Number {
        return (BPClock.clock.now() - _startTime) / 1000.0;
    }
    
	/*****************
	*                *
	* Ending Methods *
	*                *
	*****************/
	
	function finish() {
        animate(1.0);
        super.finish();
    }

    function cancel() {
        cleanup();

        post("BPAnimationStop");
    }
    
    /*******************
    *                  *
    * Duration Methods *
    *                  *
    *******************/
    
    function setDuration(duration:Number) {
        this.duration = duration;
    }
    
    function isContinuous():Boolean {
        return duration == null;
    }
    
    function isInstantaneous():Boolean {
        return duration == 0.0 || isNaN(duration);
    }
    
    function readyDuration() {
        if ( isContinuous() ) {
            // Continuous Animation:
            
            listenForAny("BPStartOfFrame", runFrame);
        } else if ( isInstantaneous() ) {
            // Instant Animation:
            
            later( finish );
        } else {
            // Run for specified period of time:
            
            var runTimer = timer("endInSeconds", duration);

            listenFor("BPTimerActive", runTimer, runFrame);
            listenFor("BPTimerStop",   runTimer, finish);
        }
    }

    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
    function timer(name:String, seconds:Number, tickPeriod:Number):BPTimer {
        return new BPTimer(name + "_" + id(), seconds, tickPeriod);
    }
     
}
