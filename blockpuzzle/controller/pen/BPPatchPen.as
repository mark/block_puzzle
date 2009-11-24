import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.*;
import blockpuzzle.model.collection.BPRegion;

class blockpuzzle.controller.pen.BPPatchPen extends BPPen {
	
	var key:String;
	
	function BPPatchPen(controller:BPController) {
        super(controller);
        
		setName("patch");
	}
	
	function setKey(key:String) {
		this.key = key;
	}
	
	/********************
	*                   *
	* respondTo Methods *
	*                   *
	********************/
	
	function patchHand() {}
	
	function drawPatch(key:String) {
        setKey(key);
    }

    function press_F() {
        var selection = controller.currentSelection;
        var fillRegion = (selection instanceof BPRegion) ? selection : board().allPatches();
            
	    new BPPatchFillAction(fillRegion, key).start();
    }
	
    /********************
    *                   *
    * Interface Actions *
    *                   *
    ********************/
    
    function down() {
		var p = patch();
		
        if (p != null) {
			new BPPatchPenAction(p, key).start();
        }
    }

}

