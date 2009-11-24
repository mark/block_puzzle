import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPPatchColorAction extends BPAction {

	var pa:BPPatch;
	
	var newColor:BPColor;
	var oldColor:BPColor;
	
	var attr:String;
	
	function BPPatchColorAction(patch:BPPatch, newColor:BPColor) {
		this.pa = patch;
		this.newColor = newColor;
	}
	
	function act() {
		
		oldColor = pa.get("color")
		
		pa.set("color", newColor)
		pa.movieClip.gotoAndStop(pa.key() + newColor.name)
		//trace(pa.movieClip)
		performed = true;

	}
	
	function undo() {
		pa.set("color", oldColor);
		pa.movieClip.gotoAndStop(pa.key() + oldColor.name)
	}

}