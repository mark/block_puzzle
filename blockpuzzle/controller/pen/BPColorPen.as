import blockpuzzle.controller.pen.*;

class blockpuzzle.controller.pen.BPColorPen extends BPPen {
	
	var targetColor:BPColor;
	var targetAttr:String;
	
	function BPColorPen(controller:BPController) {
        super(controller);
        
		setName("color");
		setAttr("color");
	}
	
	function setColor(color:String) {
		this.targetColor = BPColor.getColor(color);
	}
	
	function setAttr(attr:String) {
		this.targetAttr = attr;
	}
	
	/********************
	*                   *
	* respondTo Methods *
	*                   *
	********************/

	function colorHand(){}
/*		
	function drawPatch(key:String) {
        setKey(key);
    }

*/	

    /********************
    *                   *
    * Interface Actions *
    *                   *
    ********************/
	function down(){

		var target = board().allActors().thatAreAt(patch()).theFirst();
		var colorAct;
		
		////trace(targetColor)
		if (target != null){
    	    // FIXME: Chris needs to add some files to the repo
			colorAct = new BPActorColorAction(target, targetAttr, targetColor);
			colorAct.start();
		}
		else {
		var target = patch();
			if (target != null){
        	    // FIXME: Chris needs to add some files to the repo
				colorAct = new BPPatchColorAction(target, targetColor);
				colorAct.start();
	
			}
		}
	}
	

}

