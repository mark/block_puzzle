import blockpuzzle.base.BPObject;
import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.BPActorController;
import blockpuzzle.model.game.*;
import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.view.gui.BPGrid;
import blockpuzzle.view.sprite.BPSprite;

class blockpuzzle.model.game.BPActor extends BPObject {
	
	// What board is this object on?
	var gameboard:BPBoard;

	// What controls this actor?
	var controller:BPActorController;
	
	var info:Object;
	
	// Where is this actor located?
	var location:BPPatch;
	var region:BPRegion;

	// Where was the actor at the start of this event?
	var lastLocation:BPPatch;
	
	// What movie clip is this object associated with?
	var movieClip:MovieClip;

	// Is the registration point in the top left corner
	// of the movie clip, or the middle?
	var rectWidth:Number;
	var rectHeight:Number;
	
	// Is this object currently in play?
	var active:Boolean;
	
	/*******************************
	*                              *
	* Constructors and Destructors *
	*                              *
	*******************************/
	
	function BPActor(controller:BPActorController, key:String, info:Object) {
		this.controller = controller;

		this.info = info == null ? new Object() : info;
		setKey(key);
		
		active = true;
	}

	// Get rid of this object
	function destroy() {
		disable();
		movieClip.removeMovieClip();
		movieClip = null;
		gameboard.removeActor(this);
	}

    /****************
    *               *
    * Board Methods *
    *               *
    ****************/

	function board():BPBoard {
		return gameboard;
	}
	
	function setBoard(gameboard:BPBoard) {
		this.gameboard = gameboard;
	}
	
    function gameIsStarted():Boolean {
        return gameboard.gameIsStarted;
    }
    
    /*******************
    *                  *
    * Position Methods *
    *                  *
    *******************/

	// Place this object at the given grid location
	function placeAt(newLocation:BPPatch, moveClip:Boolean) {
		var isLocated = location != null;

		location = newLocation;
		region = controller.regionForActorAtLocation(this, newLocation);
        
		if (! isLocated) lastLocation = location;
		
		if (moveClip || ! isLocated) sprite().goto(newLocation);
		// //trace("in BPActor#placeAt for " + this);
		// if (moveClip || ! isLocated) controller.displayActor(this);
	}

	/*****************
	*                *
	* Region methods *
	*                *
	*****************/
	
	// What region of the board do I take up?
	function whereAmI():BPRegion {
		return region;
	}

	// Am I on the given space?
	function amIAt(newPatch:BPPatch):Boolean { 
	    return whereAmI().contains(newPatch);
	}

	function amIIn(newRegion:BPRegion):Boolean {
		return whereAmI().overlaps(newRegion);
	}

	function amIWithin(newRegion:BPRegion):Boolean {
		return whereAmI().containedIn(newRegion);
	}

	function amIStandingOn(patchKey:String):Boolean {
		return whereAmI().areAllOfType(patchKey);
	}
	
	
    /*********************
    *                    *
    * Movie Clip Methods *
    *                    *
    *********************/
    
    function display(grid:BPGrid) {
        controller.displayActor(this, grid.geometry());
    }
    
    function sprite():BPSprite {
        return controller.spriteForActor(this);
    }
    
    function animationCreated(anim) {
        controller.animationCreated(this, anim);
    }
    
    function animationStopped(anim) {
        controller.animationStopped(this, anim);
    }
    
	/************************
	*                       *
	* Drag and Drop methods *
	*                       *
	************************/
	
    // Have the movie clip follow the mouse
    function startDrag() {
        var sprite = controller.spriteForActor(this);
        sprite.startDrag();
    }
    
    // Have the movie clip no longer follow the mouse
    function stopDrag() {
        var sprite = controller.spriteForActor(this);
        sprite.stopDrag();
    }
    
	/*********************
	*                    *
	* Activation methods *
	*                    *
	*********************/
	
	function enable() {
		active = true;
		movieClip._visible = true;
	}

	function disable(hide:Boolean) {
		active = false;
		region = null;

		if (hide) movieClip._visible = false;		
	}

	function isActive() {
		return active;
	}

	// Make this the currently active player
	function makePlayer(current:Boolean) {
		// SUBCLASS ONLY
	}

	function canBePlayer():Boolean {
		return controller.canBePlayer(this);
	}

	/**********************
	*                     *
	* Interaction methods *
	*                     *
	**********************/
	
	// This object receives the beat
	// SUBCLASS ONLY
	function beat() {}

	
	/****************
	*               *
	* Event methods *
	*               *
	****************/
	
	function stepEvent(action:BPAction, actor:BPActor) {
		// Active
		actor.controller.resolveEvent(action, BPEvent.STEP_EVENT, actor, this);
		
		// Passive
		controller.resolveEvent(action, BPEvent.STEPPED_ON_EVENT, this, actor);
	}
	
	function leaveEvent(action:BPAction, actor:BPActor) {
		// Active
		controller.resolveEvent(action, BPEvent.LEAVE_EVENT, actor, this);
		
		// Passive
		controller.resolveEvent(action, BPEvent.LEFT_EVENT, this, actor);
	}
	
	function performedActionFromLocation(action, originalPosition:BPPatch) {
		controller.performedActionFromLocation(this, action, originalPosition);
	}

	function endOfEvent() {
		lastLocation = location;
	}
	
	function startingLocation():BPPatch {
		return lastLocation;
	}
	
	/***************
	*              *
	* Info methods *
	*              *
	***************/
	
	function key():String {
		return info.key;
	}
	
	function setKey(theKey:String) {
		info.key = theKey;
	}
	
	function isA(testKey:String):Boolean {
		return key() == testKey;
	}
	
	function get(infoKey:String) {
		return info[infoKey];
	}
	
	function set(infoKey:String, value) {
		info[infoKey] = value;
	}
	
	/*********************
	*                    *
	* Controller methods *
	*                    *
	*********************/
	
	function ask(methodName) {
	    controller[methodName].apply(controller, arguments.splice(0, 1, this));
	}
	
	function good():Boolean {
	    return controller.isGood(this);
	}
	
	/*****************
	*                *
	* Saving methods *
	*                *
	*****************/
	
    // Should this object be included on the board itself?
    function includeOnBoard() { return controller.includeOnBoard(this); }
    
	// Create an xml representation of this object
	// SUBCLASS ONLY
	function toXml():String{
		return controller.toXml(this);
	}

	/******************
	*                 *
	* Utility methods *
	*                 *
	******************/
	
	// Create a string representation of this object, for debugging purposes
	function toString():String {
		var str = getDescriptionString();
		
		if (str == "")
			return "#<" + key() + ":" + id() + " @ " + location + ">";
		else
			return "#<" + key() + ":" + id() + " @ " + location + ", { " + getDescriptionString() + " }>";
	}

	function getDescriptionString():String {
		return controller.getDescriptionString(this);
	}
	
}