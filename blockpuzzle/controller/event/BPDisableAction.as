import blockpuzzle.model.game.BPActor;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPDisableAction extends BPAction {
	
	var actor:BPActor;
	
	function BPDisableAction(actor:BPActor) {
	    setKey("Disable");
	    
		this.actor = actor;
	}
	
	function act() {
		actor.disable();
		performed = true;
	}
	
	function undo() {
		actor.enable();
	}
	
}