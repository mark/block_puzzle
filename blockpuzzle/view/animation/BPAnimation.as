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

        ////trace("\tANIMATION\t" + this);
        target.animationCreated(this);
		
		this.continuous = false;
		
		// if (target instanceof BPActor)
		//     BPMailbox.mailbox.post("BPActorAnimationCreated", target, this);
		// else if (target instanceof BPPatch)
	    //     BPMailbox.mailbox.post("BPPatchAnimationCreated", target, this);
		
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
	
    /****************************
    *                           *
    * Indirect Starting Methods *
    *                           *
    ****************************/
    
    function startInSeconds(seconds:Number) {
        shouldAutostart = false;
        
        var startTimer = timer("startInSeconds", seconds);

        waiting = function() { return startTimer.completion(); }
        
        listenFor("BPTimerStop", startTimer, start);
    }
    
    function startWhenAnimationStarts(link:BPAnimation) {
        shouldAutostart = false;
        
        waiting = function() { return link.waiting(); }
        
        listenFor("BPAnimationStart", link, start);
    }
    
    function startWhenAnimationEnds(link:BPAnimation) {
        shouldAutostart = false;
        
        waiting = function() { return link.completion(); }
        
        listenFor("BPAnimationStop", link, start);
    }
    
    /**************************
    *                         *
    * Indirect Ending Methods *
    *                         *
    **************************/
    
    function endInSeconds(seconds:Number) {
        var runTimer = timer("endInSeconds", seconds);

        completion = function() { return runTimer.completion(); };
        
        listenFor("BPTimerActive", runTimer, runFrame);
        listenFor("BPTimerStop",   runTimer, finish);
    }
    
    function endInSecondsAfterStart(seconds:Number) {
        listenFor("BPAnimationStart", this, function() { endInSeconds(seconds); });
    }

    function endWhenAnimationStarts(link:BPAnimation) {
        completion = function() { link.waiting(); }
        
        listenForAny("BPStartOfFrame",       runFrame);
        listenFor("BPAnimationStart",  link, finish);
    }
    
    function endWhenAnimationEnds(link:BPAnimation) {
        completion = function() { return link.completion(); }
        
        listenForAny("BPStartOfFrame",       runFrame);
        listenFor("BPAnimationStop",   link, finish);
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
        // return BPClock.clock.addTimer(name + "_" + id(), seconds);
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
