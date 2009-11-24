import blockpuzzle.model.collection.*;
import blockpuzzle.model.data.BPDirection;
import blockpuzzle.model.game.BPBoard;

class blockpuzzle.model.collection.BPRegion extends BPSet {
	
	/**********************
	*                     *
	* Constructor methods *
	*                     *
	**********************/
	
	function BPRegion(array:Array) {
		super(array);
	}

	function another(array:Array):BPSet {
		return new BPRegion(array);
	}
	
	function board():BPBoard {
	    return theFirst().board();
	}
	
	/*****************
	*                *
	* Region methods *
	*                *
	*****************/
	
	function inDirection(direction:BPDirection):BPRegion {
		var ary = map( function(patch) { return patch.inDirection(direction); } );
		return BPRegion(another(ary));
	}
	
	function overlaps(other:BPRegion):Boolean {
		return intersection(other).areThereAny();
	}
	
	function containedIn(other:BPRegion):Boolean {
		return intersection(other).howMany() == howMany();
	}
	
	function bounds() {
	    var b = { left: theFirst().x(), right: theFirst().x(), top: theFirst().y(), bottom: theFirst().y() };
	    
	    each( function(patch) {
	       b.left   = Math.min(b.left,   patch.x());
	       b.right  = Math.max(b.right,  patch.x());
	       b.top    = Math.min(b.top,    patch.y());
	       b.bottom = Math.max(b.bottom, patch.y());
	    });
	    
	    return b;
	}
}
