import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.event.*;

class blockpuzzle.controller.event.BPInsertRowAction extends BPBoardChangeAction {
    
    static var offsetX = { top: 0, bottom: 0, left: 1, right: 0 };
    static var offsetY = { top: 1, bottom: 0, left: 0, right: 0 };

    var direction:String;
    
    function BPInsertRowAction(controller:BPController, direction:String) {
        super(controller);
        setKey("InsertRow");
        
        this.direction = direction;
    }
    
    function updateBoard() {
        for (var y = 0; y < oldHeight(); y++) {
            for (var x = 0; x < oldWidth(); x++) {
                var patch = old(x, y);
                
                board().attach(patch, x + offsetX[direction], y + offsetY[direction])
            }
        }
        
        if (direction == "top") {
            for (var x = 0; x < oldWidth(); x++) {
                controller.patchController.createPatch(x, 0);
            }
        }
        
        if (direction == "bottom") {
            for (var x = 0; x < oldWidth(); x++) {
                controller.patchController.createPatch(x, oldHeight());
            }
        }
        
        if (direction == "left") {
            for (var y = 0; y < oldHeight(); y++) {
                controller.patchController.createPatch(0, y);
            }
        }

        if (direction == "right") {
            for (var y = 0; y < oldHeight(); y++) {
                controller.patchController.createPatch(oldWidth(), y);
            }
        }
    }

}