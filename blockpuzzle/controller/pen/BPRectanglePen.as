import blockpuzzle.controller.event.*;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.*;
import blockpuzzle.model.collection.BPRegion;
import blockpuzzle.view.gui.BPSelectionRectangle;

class blockpuzzle.controller.pen.BPRectanglePen extends BPPen {

    var startX:Number;
    var startY:Number;

    var rectCursor:BPSelectionRectangle;
    
    function BPRectanglePen(controller:BPController) {
        super(controller);
        
        setName("rect");
        rectCursor = new BPSelectionRectangle(controller);
    }
    
    function down() {
        if (isOnBoard()) {
            controller.cursor = rectCursor; 
            startX = x();
            startY = y();

            rectCursor.redrawForBounds({ left: startX, right: startX, top: startY, bottom: startY });
        }
    }
    
    function move() {
        if (startX != null && startY != null && isOnBoard()) {
            
            rectCursor.redrawForBounds({
                left:   Math.min(x(), startX),
                right:  Math.max(x(), startX),
                top:    Math.min(y(), startY),
                bottom: Math.max(y(), startY)
            });
        }
    }
    
    function up() {
        if (startX != null && startY != null && isOnBoard()) {
            var selection = new BPRegion();

            var left   = Math.min(x(), startX);
            var right  = Math.max(x(), startX);
            var top    = Math.min(y(), startY);
            var bottom = Math.max(y(), startY);

            for (var ly = top; ly <= bottom; ly++) {
                for (var lx = left; lx <= right; lx++) {
                    selection.insert( board().getPatch(lx, ly) );
                }
            }

            controller.currentSelection = selection;
        }
        
        startX = null;
        startY = null;        
    }

    function cropRect() {
        var selection = controller.currentSelection;
        
        if (selection instanceof BPRegion) {
            new BPCropAction(controller, selection).start();

            controller.currentSelection = null;
            rectCursor.hide();
        } else {
            //trace("You can only crop a region!");
        }
    }

    function press_K() {
        cropRect();
    }

    function insertTop() {
        new BPInsertRowAction(controller, "top").start();
    }
    
    function insertBottom() {
        new BPInsertRowAction(controller, "bottom").start();
    }
    
    function insertLeft() {
        new BPInsertRowAction(controller, "left").start();
    }
    
    function insertRight() {
        new BPInsertRowAction(controller, "right").start();
    }
    
}