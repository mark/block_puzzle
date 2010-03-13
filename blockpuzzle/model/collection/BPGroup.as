import blockpuzzle.model.collection.*;
import blockpuzzle.model.game.BPPatch;

class blockpuzzle.model.collection.BPGroup extends BPSet {

	/***************
	*              *
	* Constructors *
	*              *
	***************/
	
	function BPGroup(of:Object) {
		super(of);
	}
	
	function another(of:Object):BPSet {
		return new BPGroup(of);
	}
	
	/**************
	*             *
	* That Are At *
	*             *
	**************/
	
    function thatAreAt(patch:BPPatch) {
		return thatAre( function(actor) { return actor.whereAmI().contains(patch); } );
	}

    function thatAreNotAt(patch:BPPatch) {
		return thatAreNot( function(actor) { return actor.whereAmI().contains(patch); } );
	}

	/**************
	*             *
	* That Are In *
	*             *
	**************/

    function thatAreIn(region:BPRegion) {
		return thatAre( function(actor) { return actor.whereAmI().overlaps(region); } );
    }

    function thatAreNotIn(region:BPRegion) {
        return thatAreNot( function(actor) { return actor.whereAmI().overlaps(region); } );
    }

	/******************
	*                 *
	* That Are Within *
	*                 *
	******************/
    
    function thatAreWithin(region:BPRegion) {
        return thatAre( function(actor) { return actor.whereAmI().containedIn(region); } );
    }

    function thatAreNotWithin(region:BPRegion) {
        return thatAreNot( function(actor) { return actor.whereAmI().containedIn(region); } );
    }
 
	/******************
	*                 *
	* That Are Active *
	*                 *
	******************/
	
	function thatAreActive() {
		return thatAre( function(actor) { return actor.isActive(); })
	}
	
	function thatAreNotActive() {
		return thatAreNot( function(actor) { return actor.isActive(); })
	}
	
	/*********************
	*                    *
	* That Can Be Player *
	*                    *
	*********************/
	
	function thatCanBePlayer() {
		return thatAre( function(actor) { return actor.isActive() && actor.canBePlayer(); })
	}

}