import blockpuzzle.controller.event.*;
import blockpuzzle.model.game.BPPatch;

class blockpuzzle.controller.event.BPPatchPenAction extends BPAction {

	var patch:BPPatch;
	
	var newKey:String;
	var oldKey:String;
	
	function BPPatchPenAction(patch:BPPatch, newKey:String) {
	    setKey("PatchPen");
	    
		this.patch = patch;
		this.newKey = newKey;
	}
	
	function act() {
		oldKey = patch.key();
		
		patch.setKey(newKey);
		patch.controller.initializePatch(patch);
		patch.setFrame();
		
		performed = true;
	}
	
	function undo() {
		patch.setKey(oldKey);
		patch.setFrame();
	}

}