import blockpuzzle.controller.game.BPController;
import blockpuzzle.model.collection.*;
import blockpuzzle.model.game.*;

class blockpuzzle.model.game.BPBoard {

	var controller:BPController;
	
	// How big is the board (in cells), not set until loading a level
	var patchesHigh = 0;
	var patchesWide = 0;
	
	// What does the floor look like?
	//  Includes empty, pit, wall, exit
	//  As a 2D array of patches
	var patches:Array;
	var patchSet:BPRegion;
		
	// What GameObject are on this gameboard?
	var objectSet:BPGroup;
	
	// Server information for loading & saving
	static var ServerURL:String;

	var serverName:String;
	var serverId = -1;    // By default, -1 means new & unsaved
    var serverIndex = -1;
	
	// Has loading been finished?
	var gameIsStarted;
	
	/*******************************
	*                              *
	* Constructors and Destructors *
	*                              *
	*******************************/
	
	// Create a GameBoard, with the given geometry
	// Does not specify the width or height, or any data.
	function BPBoard(controller:BPController) {
	    
	    this.controller = controller;
	    
        // Initialize the patch array & region
        clearPatches();
		
		// Initialize the objects group
		objectSet = new BPGroup();
		
		// Game hasn't been loaded yet...
		gameIsStarted = false;
	}
	
	// Clear all of the movieclips associated with this board,
	// For when loads fail, or when we're going to load a
	// new level.
	function destroy() {
		allPatches().each( function(patch) { patch.destroy(); } );
		
		while (allActors().areThereAny()) {
			allActors().theFirst().destroy();
		}
	}

	/***************************
	*                          *
	* Server Parameter Methods *
	*                          *
	***************************/
	
	// Set the id that this gameboard is on the server.
	function setServerId(serverId) {
		this.serverId = Number(serverId);
	}
	
	// What id is this on the server?
	function getServerId() {
	    return serverId;
	}

	function setServerIndex(serverIndex) {
	    this.serverIndex = Number(serverIndex);
	}
	
	function getServerIndex() {
	    return serverIndex;
	}
	
	function setServerName(serverName) {
	    this.serverName = serverName;
	}
	
	function getServerName() {
	    return serverName;
	}
	
	/****************
	*               *
	* Patch methods *
	*               *
	****************/
	
	function clearPatches():Array {
	    allPatches().each( function(patch) { patch.destroy(); } );
	    var oldPatches = patches;

	    patches = new Array();
	    patchSet = new BPRegion();
	    patchesWide = 0;
	    patchesHigh = 0;
	    
	    return oldPatches;
	}
	
	// Get the floor patch at the given location.
	function getPatch(locationX:Number, locationY:Number):BPPatch {
		if ((locationX >= 0) && (locationX < width()) && (locationY >= 0) && (locationY < height()))
			return patches[locationY][locationX];
		else 
			return null;
	}

    // Set the patch's location to the given location.
	function attach(patch:BPPatch, locationX:Number, locationY:Number) {
		//if (locationX >= 0 && locationX < width() && locationY >= 0 && locationY < height()) {
    		if (patches[locationY] == null) patches[locationY] = new Array();
    		patches[locationY][locationX] = patch;

			patchSet.insert(patch);
			patch.attach(this, locationX, locationY);
			
			patchesWide = Math.max(patchesWide, locationX + 1);
			patchesHigh = Math.max(patchesHigh, locationY + 1);
		//} else {
		//    //trace("Failed in attach()")
		//}
	}

	// How many cells wide is this board?
	function width():Number {
		return patchesWide;
	}
	
	// How many cells tall is this board?
	function height():Number {
		return patchesHigh;
	}
	
	// Returns the grid region corresponding to the
	// whole board.  Useful if you want to do something to
	// every cell or patch.
	function allPatches():BPRegion {
		return patchSet;
	}
	
	/*****************
	*                *
	* Object methods *
	*                *
	*****************/
	
	// If possible, adds a GameObject to the gameboard at the given location
	function addActor(actor:BPActor, location:BPPatch) {
		objectSet.insert(actor);
		actor.setBoard(this);
		actor.placeAt(location, true);
	}

	// Removes the object from the objects array
	function removeActor(actor:BPActor) {
		objectSet.remove(actor);
	}

    // A solution set of all the objects on the board.  Needed
    // all over the place to figure out which moves are valid, etc.
	function allActors():BPGroup {
		return objectSet;
	}

    // Only the active objects on the board.  Technically, this one is called more
    // than the previous (by outside objects).
    // It may be worthwhile to keep track of these, rather than generating a new one every time?
    function allActiveObjects():BPGroup { return BPGroup(allActors().thatAre('isActive')); }

	/*****************
	*                *
	* Player methods *
	*                *
	*****************/
	
	// Sends the 'heartbeat' to all objects, so that they can respond
	// to the player's move.
    function sendBeat() {
		objectSet.each( function(actor) { actor.beat(); } );
    }

    function firstPlayer():BPActor {
        return objectSet.thatCanBePlayer().theFirst();
    }
    
	function nextPlayer(currentPlayer:BPActor):BPActor {
		return objectSet.thatCanBePlayer().theNextAfter(currentPlayer);
	}
	
   	/******************
   	*                 *
   	* Utility methods *
   	*                 *
   	******************/

    // Quick string representation, for debugging.
	function toString():String { return "[" + width() + "x" + height() + "]"; }

}