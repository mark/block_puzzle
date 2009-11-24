import blockpuzzle.model.data.BPDirection;
import blockpuzzle.model.game.BPActor;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPSlideAction extends BPBehavior {
	
	var direction:BPDirection;
	var firstTime:Boolean;
	
	function BPSlideAction(actor:BPActor, direction:BPDirection, firstTime:Boolean) {
		super(actor);
		setKey("Slide");
		
		this.direction = direction;
		this.firstTime = firstTime == null;
		
		//if (firstTime == false) trace("Slide again")
		//else trace("Start slide")
	}
	
	function act() {
		// super.act();
		
		this.causes(new BPMoveAction(actor(), direction));
		this.causes(new BPSlideAction(actor(), direction, false), "safely");
	}
	
}