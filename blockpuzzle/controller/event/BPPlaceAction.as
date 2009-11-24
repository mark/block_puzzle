import blockpuzzle.model.game.BPActor;
import blockpuzzle.model.game.BPPatch;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPPlaceAction extends BPAction {
	
	var actor:BPActor;

    var oldLocation:BPPatch;
	var newLocation:BPPatch;
	
	function BPPlaceAction(actor:BPActor, location:BPPatch) {
		this.actor = actor;	
		this.newLocation = location == null ? actor.location : location;
		
		setKey("Place");
	}
	
	function act() {
		performed = true;
		
		oldLocation = actor.location;
		actor.placeAt(newLocation, true);
	}
	
	function undo() {
		actor.placeAt(oldLocation);
	}
	
	function animateUndo() {
	    actor.sprite().goto(oldLocation);
	}
	
}