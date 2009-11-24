import blockpuzzle.base.BPObject;
import blockpuzzle.controller.event.*;
import blockpuzzle.view.animation.*;

class blockpuzzle.controller.event.BPEvent extends BPObject {
	
	// Event Types
	
	static var      ENTER_EVENT = "Enter";
	static var       EXIT_EVENT = "Exit";
	
	static var       STEP_EVENT = "StepOn";
	static var STEPPED_ON_EVENT = "BeSteppedOnBy"
	
	static var      LEAVE_EVENT = "Leave";
	static var       LEFT_EVENT = "BeLeftBy";
	
	static var ChoreographerClass = BPChoreographer;
	
	// Instance Variables
	
	var settings:Object;
	var actions:Array;
	var failure:Boolean;

    var currentPosition:Number;
	var immediateMode:Boolean;
	
	function BPEvent() {
		actions = new Array();
		failure = false;
		
		currentPosition = 0;
		immediateMode = false;
	}
	
	function start(shouldPostToUndoQueue:Boolean):Boolean {
		//currentPosition = 0;
		
		while (! failure && currentPosition < actions.length) {
			var action = actions[currentPosition];
			if (! action.cancelled) action.resolve();
			
			currentPosition++;
		}
		
		if (failure) {
            post("BPEventFailed");
		    return false;
	    }

        // Uncomment the following line to get a description of each event as it occurs:
        // trace(this);
        
        if (! immediateMode) {
    		new ChoreographerClass(this);
        }
		
		if (shouldPostToUndoQueue) BPUndoManager.undoQueue().post(this);
        post("BPEventSucceeded");

		return true;
	}
	
	function postAction(action:BPAction) {
		actions.push(action);
		action.event = this;
		
		if (immediateMode && ! failure) {
		    currentPosition++;
		    action.resolve();
		    
		    if (! action.cancelled) {
		        action.animate();
		    }
		}
	}
	
	function failed() {
		failure = true;
	}

	function originalCause():BPAction {
		return actions[0];
	}

	function undo() {
		for (var i = actions.length-1; i >= 0; i--) {
			if (actions[i].performed) actions[i].revert();
		}
	}

    function toString() {
        return originalCause().toString();
    }

    /*****************
    *                *
    * Immediate Mode *
    *                *
    *****************/
    
    function immediately() {
        this.immediateMode = true;
        
        // Probably should perform actions up to this point
    }

}