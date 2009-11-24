import blockpuzzle.controller.pen.*;

class blockpuzzle.controller.pen.BPColorPen extends BPPen {
	
	var key:String;
	var targetAttr:String;
	
	function BPColorPen(controller:BPController) {
        super(controller);
        
		setName("color");
	}
	
	function setKey(key:String) {
		this.key = key;
	}
	
	function setAttr(attr:String) {
		this.targetAttr = attr;
	}
	
	/********************
	*                   *
	* respondTo Methods *
	*                   *
	********************/
	
/*	function patchHand() {}
	
	function drawPatch(key:String) {
        setKey(key);
    }

*/	
    /********************
    *                   *
    * Interface Actions *
    *                   *
    ********************/
/*    
    function down() {
		var p = patch();
		
        if (p != null) {
			new BPPatchPenAction(p, key).start();
        }
    }
*/
}

