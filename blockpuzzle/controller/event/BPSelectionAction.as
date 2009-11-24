import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPSelectionAction extends BPAction {
    
    var controller:BPController;
    var previousSelection;
    
    function BPSelectionAction(controller:BPController) {
        this.controller = controller;
        
        setKey("Select");
    }
    
    function act() {
        previousSelection = controller.currentSelection;
        
        // This is where you turn on highlighting, or whatever...
        
        performed = true;
    }
    
    function undo() {
        var currentSelection = controller.currentSelection;
        
        // This is where you turn off highlighting...
        
        controller.currentSelection = previousSelection;
        
        // And now turn it on for the previous selection...
    }
    
}