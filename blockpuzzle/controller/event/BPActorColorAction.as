import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPActorColorAction extends BPAction {

	var ac:BPActor;
	
	var newColor:BPColor;
	var oldColor:BPColor;
	
	var attr:String;
	
	function BPActorColorAction(actor:BPActor, attr:String, newColor:BPColor) {
		this.ac = actor;
		this.newColor = newColor;
		this.attr = attr;
	}
	
	function act() {
		
		oldColor = ac.get(attr)
		
		ac.set(attr,newColor);
		ac.place();
		
		performed = true;

	}
	
	function undo() {
		ac.set(attr, oldColor);
		ac.place();
	}

}