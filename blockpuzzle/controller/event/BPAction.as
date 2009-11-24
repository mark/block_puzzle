import blockpuzzle.base.BPObject;
import blockpuzzle.controller.event.*;
import blockpuzzle.view.animation.*;

class blockpuzzle.controller.event.BPAction extends BPObject {

	var event:BPEvent;

    // Choreography
    
    var _key:String;

	// Causality
	
	var cause:BPAction;
	var causeKey:String;
	
	var effects:Array;
	
	var performed:Boolean;
	var animated:Boolean;
	var cancelled:Boolean;
    var failed:Boolean;

	// Animation
	
	var _animation:BPAnimation;
	
	// Statuses
	
	static var POSTED = 0;
	static var PERFORMED = 1;
	static var CANCELLED = 3;
	static var UNDONE = 4;
	
	/**************
	*             *
	* Constructor *
	*             *
	**************/
	
	function BPAction() {
		effects = new Array();
		setKey("_Action");
		
		performed = false;
		animated = false;
		cancelled = false;
		failed = false;
	}
	
	/**************
	*             *
	* Key methods *
	*             *
	**************/
	
	function key():String {
	    return _key;
	}

	function isA(k:String):Boolean {
	    return key() == k;	    
	}
	
	function setKey(newKey:String) {
	    _key = newKey;
	}
	
	/*******************************
	*                              *
	* Event Initialization methods *
	*                              *
	*******************************/
	
	function wait(immediateMode:Boolean):BPAction {
		event = new BPEvent();
		
		if (immediateMode) { event.immediately(); }
		
		event.postAction(this);
		
		return this;
	}

	function start(postToUndoQueue:Boolean):Boolean {
		if (event == null) wait();

        var shouldPostToUndoQueue = postToUndoQueue == null || postToUndoQueue == true;
        
		return event.start(shouldPostToUndoQueue);
	}
	
	/**********************
	*                     *
	* Event Chain methods *
	*                     *
	**********************/
	
	function originalCause() {
		return event.originalCause();
	}
	
	function cancelEffects() {
		for (var i = 0; i < effects.length; i++)
			effects[i].stopAction();
	}

	function stopAction() {	
		cancelled = true;
				
		cancelEffects();
		
		if (performed) undo();
	}
	
	function resolve() {
		performed = true;
		
		act();
	}

	/**************************
	*                         *
	* Failure Cascade methods *
	*                         *
	**************************/
	
	function safelyFailed(effect:BPAction) {
		// This is for actions that you don't want to fail out the entire event chain.
		// You probably don't want to overwrite this.  If you want something different,
		// Then give it a custom cause key
	}
	
	function effectFailed(effect:BPAction) {
		// This is the catch-all effect failure method.
		// You probably don't want to overwrite this.  If you want something different,
		// Then give it a custom cause key
		fail();
	}

	/***************************
	*                          *
	* Event Resolution methods *
	*                          *
	***************************/
	
	function succeed() {
		// This is for code readability & debugging purposes, for now (?)
	}
	
	function fail() {
	    failed = true;
		stopAction();
		
		if (cause != null) {
			var fcn = cause[causeKey + "Failed"];
			if (fcn == null) fcn = cause["effectFailed"];
			
			fcn.call(cause, this);
		} else {
			event.failed();
		}
	}
	
	function causes(other:BPAction, causeKey:String):BPAction {
		other.cause = this;
		other.causeKey = causeKey != null ? causeKey : "effect";
		
		effects.push(other);
		event.postAction(other);
		
		return other;
	}
	
	// Helper methods
	
	function safelyCauses(other:BPAction) {
	    causes(other, "safely");
	}
	
	function require(condition:Boolean, action:BPAction) {
		if (condition) {
			succeed();
		} else {
			if (action == null)
				fail();
			else
				causes(action);
		}
	}
	
	/********************
	*                   *
	* Animation Methods *
	*                   *
	********************/
	
	function animate() {
		// SUBCLASS ONLY!
		return null; // <--- generates an empty animation
	}
	
	function animateUndo() {
	    // SUBCLASS ONLY!
	    return null; // <-- generates nothing
	}
	
	// This should be part of the choreographer...
	function animation():BPAnimation {
	    if (_animation == null) {
    	    var animation = animate();

    	    if (animation instanceof Array) {
                _animation = new BPWrapperAnimation(animation);
            } else if (animation == null) {
                _animation = new BPEmptyAnimation();
            } else {
                _animation = animation;
            }
            
            _animation.wait();
	    }
	    
	    animated = true;
	    return _animation;
	}
	
	/****************
	*               *
	* Trial methods *
	*               *
	****************/
	
	function endOfEvent() {
		// SUBCLASS ONLY!
	}
	
	/********************
	*                   *
	* Command functions *
	*                   *
	********************/
	
	function act() {
		// SUBCLASS ONLY!
	}
	
	function undo(){
		// SUBCLASS ONLY!
	}

    function revert() {
        undo();
        
        if (animated) {
            animateUndo();
        }
    }
    
	/******************
	*                 *
	* Utility Methods *
	*                 *
	******************/
	
	function description():String {
	    return key();
	}
	
	function toString():String {
	    var string = (failed ? '*' : '') + description();

	    if (effects.length > 1) {
	        string += " => [ ";
    	    
    	    for (var i = 0; i < effects.length; i++) {
    	        string += effects[i];
    	        
    	        if (i < (effects.length - 1)) string += ", ";
    	    }
    	    
    	    string += "]";
	    } else if (effects.length == 1) {
	        string += " => " + effects[0];
        }
        
	    return string;
	}	
	
}