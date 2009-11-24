import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.event.*;
import blockpuzzle.model.game.*;
import blockpuzzle.model.collection.BPRegion;

class blockpuzzle.controller.event.BPCropAction extends BPBoardChangeAction {
    
    var region:BPRegion;
    var bounds:Object;
    
    function BPCropAction(controller:BPController, region:BPRegion) {
        super(controller);
        setKey("Crop");
        
        this.region = region;
        this.bounds = region.bounds();
    }
    
    function handleActor(actor:BPActor) {
        if (! actor.amIWithin(region))
            this.causes( new BPDestroyAction(actor) );
    }
    
    function updateBoard() {
	    var newWidth = bounds.right - bounds.left + 1;
	    var newHeight = bounds.bottom - bounds.top + 1;
	    
	    for (var y = 0; y < newHeight; y++) {
	        for (var x = 0; x < newWidth; x++) {
	            var patch = old(x + bounds.left, y + bounds.top);
	            
	            board().attach(patch, x, y);
	        }
	    }
    }
    
}
