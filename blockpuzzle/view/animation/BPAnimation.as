import blockpuzzle.base.BPObject;
import blockpuzzle.controller.mailbox.BPMessage;
import blockpuzzle.view.clock.*;
import blockpuzzle.view.choreography.BPSchedulable;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPAnimation extends BPSchedulable {

    // Data object variables
    var movieClip:MovieClip;
    var target:Object;
    
    var startTime:Number;
    var duration:Number;
    
    var shouldAutostart:Boolean;
    
    var continuous:Boolean;
    
    /**************
    *             *
    * Constructor *
    *             *
    **************/
    
    function BPAnimation(target) {
		 if (target instanceof MovieClip)
		 	this.movieClip = target;
		// else
        // 	this.movieClip = target.getMovieClip();

		this.target = target;

        target.animationCreated(this);
		
		this.continuous = false;
		
		listenForAny("BPFinishAnimations", finish); // For finishing all animations
		listenForAny("BPCancelAnimations", cancel); // For cancelling all animations
		
		//shouldAutostart = true; // Should this animation start automatically?
		shouldAutostart = false;
		
		later(autostart);
    }
    

	/*********************
	*                    *
	* Movie Clip methods *
	*                    *
	*********************/
	
	function isAnimationFor(obj) {
		if (obj instanceof MovieClip)
			return movieClip == obj;
		else
			return movieClip == obj.getMovieClip();
	}

	/*****************
	*                *
	* Ending Methods *
	*                *
	*****************/
	
    function setDuration(seconds:Number) {
        var runTimer = timer("endInSeconds", seconds);

        completion = function() { return runTimer.completion(); };
        
        listenFor("BPTimerActive", runTimer, runFrame);
        listenFor("BPTimerStop",   runTimer, finish);
    }
    
    function runContinuously() {
        continuous = true;
        completion = function() { return 0.0; }
        
        listenForAny("BPStartOfFrame", runFrame);
    }

    /******************
    *                 *
    * Animation Frame *
    *                 *
    ******************/

    function start() {
        super.start();
        shouldAutostart = false;
        
        startTime = BPClock.clock.now();
        setup();
        animate(0.0);
        post("BPAnimationStart");
        
        target.animationStarted(this);
        setDuration( duration );
    }
    
    function finish() {
        animate(1.0);
        cancel();
        super.finish();
    }

    /********************
    *                   *
    * Autostart Methods *
    *                   *
    ********************/
    
    function autostart() {
        if (shouldAutostart) start();
    }
    
    function wait() {
        shouldAutostart = false;
    }
    
    /*********
    *        *
    * Frames *
    *        *
    *********/
    
    function runFrame(message:BPMessage) {
        animate(completion());
    }
    
    function cancel() {
        cleanup();

        post("BPAnimationStop");
        //trace("<" + id() + ">.cancel()");
        
        target.animationStopped(this);
    }
    
    function setup() {
        // OVERRIDE ME!
    }
    
    function animate(completion:Number) {
        // OVERRIDE ME!
    }

    function cleanup() {
        // OVERRIDE ME!
    }

    /****************
    *               *
    * Clock Methods *
    *               *
    ****************/
    
    function elapsed():Number {
        return (BPClock.clock.now() - startTime) / 1000.0;
    }
    
    function timer(name:String, seconds:Number, tickPeriod:Number):BPTimer {
        return new BPTimer(name + "_" + id(), seconds, tickPeriod);
    }
     
    /*********************
    *                    *
    * Completion Methods *
    *                    *
    *********************/
    
    // These get replaced as appropriate:
    
    function    waiting() { return 0.0; }
    function completion() { return 1.0; }
    
    function isContinuous():Boolean { return continuous; }
    
    /******************
    *                 *
    * Utility Methods *
    *                 *
    ******************/
    
     function toString():String {
         return "#<" + className() + ": " + id() + " -> " + target + ">";
     }

}
