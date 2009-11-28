import blockpuzzle.view.animation.BPAnimation;
import blockpuzzle.model.game.*;
import blockpuzzle.view.gui.BPButton;
import blockpuzzle.controller.event.BPAction;
import blockpuzzle.controller.game.*;

class blockpuzzle.controller.game.BPPatchController {
	
	var controller:BPController;
	
	var tileLibrary:BPTileLibrary;
	
	function BPPatchController(controller:BPController) {
		this.controller = controller;

        controller.setPatchController(this);
    }
	
	function board():BPBoard {
		return controller.board();
	}
	
	/***********************
	*                      *
	* Tile Library Methods *
	*                      *
	***********************/
	
	function tile(key:String, xmlChars:String, frame:String) {
	    if (tileLibrary == null) tileLibrary = new BPTileLibrary([]);

	    var newTile = new BPTile(key, xmlChars, frame);
	    tileLibrary.addTile(newTile);
	}
	
	function setTiles(tileArray:Array) {
		tileLibrary = new BPTileLibrary(tileArray);
	}
	
	function tiles():BPTileLibrary {
		return tileLibrary;
	}

	/*********************
	*                    *
	* Movie Clip Methods *
	*                    *
	*********************/
	
	// This can be overridden, but probably shouldn't be.
	function movieClipName() { return "Patch"; }
	
	function frameName(patch:BPPatch) { return tiles().frameForKey(patch.key()); }

	function modifyMovieClip(patch:BPPatch, movieClip:MovieClip) { }

    /**************************
    *                         *
    * Event-cascading Methods *
    *                         *
    **************************/
    
	function resolveEvent(action:BPAction, eventType:String, source:BPActor, target:BPPatch):Boolean {
		var eventMethod:Function;

		if (eventMethod == null) eventMethod = this["can" + source.key() + eventType + target.key()];
		if (eventMethod == null) eventMethod = this["can" + eventType + target.key()];
		if (eventMethod == null) eventMethod = this["can" + source.key() + eventType];
		if (eventMethod == null) eventMethod = this["can" + eventType];

		return eventMethod.call(this, action, source, target);
	}

	function canEnter(action, source:BPActor, target:BPPatch) {
		action.succeed();
	}

	function canExit(action, source:BPActor, target:BPPatch) {
		action.succeed();
	}
	
    /*************************
    *                        *
    * Idle Animation Methods *
    *                        *
    *************************/
    
    function idleAnimation(patch:BPPatch):BPAnimation {
        return null;
    }
    
    function idlePeriod(patch:BPPatch):Number {
        return -1; // No idle animation
    }
    
	/******************
	*                 *
	* Loading Methods *
	*                 *
	******************/
	
	function loadPatch(board:BPBoard, tile:String, locationX:Number, locationY:Number) {
		var key = tileLibrary.keyForTile(tile);
		var newPatch = new BPPatch(this, key);
		newPatch.set("tile", tile);

		board.attach(newPatch, locationX, locationY);
		initializePatch(newPatch);
		
		return newPatch;
	}

	function createPatch(locationX:Number, locationY:Number) {
		var key = tileLibrary.defaultKey();
		var newPatch = new BPPatch(this, key);

		board().attach(newPatch, locationX, locationY);
		initializePatch(newPatch);

		return newPatch;
	}
	
	function initializePatch(patch:BPPatch) {
		// OVERRIDE ME!
	}
	
	/*****************
	*                *
	* Saving Methods *
	*                *
	*****************/
	
	function exportPatch(patch:BPPatch):String {
		var tile = tiles().tileForKey(patch.key());
		
		return tile.toXml();
	}

	function button(key:String):BPButton {
	    return new BPButton("drawPatch", key, { group: "PatchPen" });
	}

}