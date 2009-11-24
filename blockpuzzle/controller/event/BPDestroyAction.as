import blockpuzzle.model.game.BPActor;
import blockpuzzle.model.game.BPPatch;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPDestroyAction extends BPAction {
	
	var actor:BPActor;
	var oldLocation:BPPatch;
	
	function BPDestroyAction(actor:BPActor) {
	    setKey("Destroy");
	    
		this.actor = actor;
	}
	
	function act() {
		performed = true;
	
		oldLocation = actor.location;
		actor.destroy();
	}
	
	function undo() {
		actor.enable();
		actor.board().addActor(actor, oldLocation);
		actor.display();
	}

}