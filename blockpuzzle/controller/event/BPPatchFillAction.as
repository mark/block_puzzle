import blockpuzzle.controller.event.*;
import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.view.animation.BPPatchAnimation;

class blockpuzzle.controller.event.BPPatchFillAction extends BPAction {
    
    var region:BPRegion;
    
    var fillKey:String;
    
    var oldKeys:Array;
    
    function BPPatchFillAction(region:BPRegion, fillKey:String) {
        setKey("PatchFill");
        
        this.region = region;
        this.fillKey = fillKey;
    }
    
    function act() {
        oldKeys = new Array();
        
        var self = this;
        
        region.each( function(patch) {
            self.oldKeys[patch.depth()] = patch.key();
            patch.setKey(self.fillKey);
            //patch.setFrame();
        });
        
        performed = true;
    }
    
    function undo() {
        var self = this;
        
        region.each( function(patch) {
            patch.setKey( self.oldKeys[patch.depth()] );
            
            patch.setFrame();
        });
    }
    
    function animate() {
        return new BPPatchAnimation(region);
    }

}