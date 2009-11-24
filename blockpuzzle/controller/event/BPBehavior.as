import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.model.game.BPActor;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPBehavior extends BPAction {
	
	var _actor:BPActor;
	
	function BPBehavior(actor:BPActor) {
	    setKey("_Behavior");
	    
		this._actor = actor;
	}
	
	function actor():BPActor { return _actor; }
	
	/********************
	*                   *
	* Animation Methods *
	*                   *
	********************/
	
	function animate() {
	    var actorController = actor().controller;
	    return actorController["animate" + key()](actor(), this);
	}
	
	/***************************
	*                          *
	* Event Resolution methods *
	*                          *
	***************************/
	
	function resolve() {
		var oldRegion = _actor.whereAmI();

		performed = true;

		act();

		var newRegion = _actor.whereAmI();

		actorEntersRegion(_actor, oldRegion, newRegion);
		
		listenFor("BPEventSucceeded", event, endOfEvent);
	}

	function actorEntersRegion(actor:BPActor, oldRegion:BPRegion, newRegion:BPRegion) {
		var self = this;
		
		// Validity check -- can't walk off the board
		
			if (! newRegion.isValid()) fail();
			
    	// Now we have to test for the actors
        
    	var oldActors = actor.board().allActors().thatAreIn(oldRegion);
    	var newActors = actor.board().allActors().thatAreIn(newRegion);
        
    	// Actors that you're stepping on
        
    		var steppedActors = newActors.minus(oldActors);
        
    		steppedActors.each( function(other) { if (! self.failed && actor != other) other.stepEvent(self, actor); } );
        
    	// Actors that you're leaving
        
    		var leftActors = oldActors.minus(newActors);
        
    		leftActors.each( function(other) { if (! self.failed && actor != other) other.leaveEvent(self, actor); } );

		// Patches that you're entering into
		
			var enteredPatches = newRegion.minus(oldRegion);
			
			enteredPatches.each( function(patch) { if (! self.failed) patch.enterEvent(self, actor); } );
        	
		// Patches that you're exiting from

			var exitedPatches = oldRegion.minus(newRegion);
			
			exitedPatches.each( function(patch) { if (! self.failed) patch.exitEvent(self, actor); } );

	}
	
	function endOfEvent() {
		actor().endOfEvent();
	}

}