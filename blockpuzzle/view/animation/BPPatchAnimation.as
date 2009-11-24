import blockpuzzle.model.game.BPPatch;
import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPPatchAnimation extends BPAnimation {
	
	var region:BPRegion;
	
	function BPPatchAnimation(region:BPRegion) {
		super(null);
		this.region = region;
	}

	function setup() {
		finish();
	}

	function cleanup() {
		region.each(function(patch:BPPatch) { patch.setFrame(); } );
	}
	
}