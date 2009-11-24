import blockpuzzle.model.data.BPDirection;
import blockpuzzle.model.game.*;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPMoveAction extends BPBehavior {
	
	var direction:BPDirection;
	var steps:Number;

	var oldPosition:BPPatch;
	var newPosition:BPPatch;
	
	function BPMoveAction(actor:BPActor, direction:BPDirection, steps:Number) {
		super(actor);
		setKey("Move");
		
		this.direction = direction;
		this.steps = steps == null ? 1 : steps;
	}
	
	function act() {
		oldPosition = actor().location;
		newPosition = oldPosition.inDirection(direction, steps);

		actor().placeAt(newPosition);
	}
	
	function undo() {
		actor().placeAt(oldPosition);
	}

    function animateUndo() {
        actor().sprite().goto(oldPosition);
    }
    
    function description():String {
        return key() + "<" + actor().key() + ">";
    }
    
}
