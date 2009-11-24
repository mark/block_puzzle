import blockpuzzle.model.game.BPActor;
import blockpuzzle.model.game.BPPatch;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPAddAction extends BPAction {

	var actor:BPActor;
	var patch:BPPatch;
	
	function BPAddAction(actor:BPActor) {
		this.actor = actor;
		
		setKey("Add");
	}
	
	function act() {
		performed = true;
	}
	
	function undo() {
		actor.destroy();
	}

}