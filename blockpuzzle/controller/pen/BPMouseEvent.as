import blockpuzzle.model.game.BPPatch;
import blockpuzzle.model.collection.BPPath;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.BPDragObject;
import blockpuzzle.view.gui.*;

class blockpuzzle.controller.pen.BPMouseEvent {
    
    static var currentMouseEvent:BPMouseEvent;
    
    var controller:BPController;
    var path:BPPath;
    
    var isStarted:Boolean;
    var isDragging:Boolean;
    var isEnded:Boolean;
    
    var startingWell:BPWell; // If the drag started at a well
    var endingWell:BPWell;   // If the drag ended at a well
    
    var dragObject:BPDragObject;
    
    function BPMouseEvent(controller:BPController) {
        this.controller = controller;  
        this.path       = new BPPath();
        this.isStarted  = false;
        this.isDragging = false;
        this.isEnded    = false;
        
        BPMouseEvent.currentMouseEvent = this;
        
        Mouse.addListener(this);
    }
    
    /**********************
    *                     *
    * Drag Object Methods *
    *                     *
    **********************/
    
    function attach(dragObject:BPDragObject) {
        this.dragObject = dragObject;
        dragObject.attach();
    }
    
    /***************
    *              *
    * Well Methods *
    *              *
    ***************/
    
    function downOnWell(well:BPWell) {
        isStarted    = true;
        isDragging   = true;
        startingWell = well;
        controller.respondTo(well.wellKey + "Drag", [this]);
    }
    
    function upOnWell(well:BPWell) {
        isEnded = true;
        endingWell = well;
        controller.respondTo(well.wellKey + "Drop", [this]);

        BPMouseEvent.currentMouseEvent = null;
    }
    
    /***************
    *              *
    * Grid Methods *
    *              *
    ***************/
    
    function downOnGrid(patch:BPPatch) {        
        isStarted = true;
        path.addStep(patch);
        controller.respondTo("down", [this]);
    }
    
    function dragOnGrid(patch:BPPatch, centerX:Number, centerY:Number) {
        if (path.current() != patch) { // The pen has moved
            if (! dragging()) { // We're just starting to drag
                isDragging = true;
                controller.respondTo("startDrag", [this]);
            }
            
            path.addStep(patch);
            controller.respondTo("drag", [this]);
            
            if (dragObject) {
                dragObject.centerAt(centerX, centerY);
            }
        }
        
    }
    
    function upOnGrid(patch:BPPatch) {
        isEnded = true;
        
        if (dragging()) {
            controller.respondTo("endDrag", [this]);
        } else {
            controller.respondTo("up", [this]);
        }

        BPMouseEvent.currentMouseEvent = null;
    }
    
    /***********************
    *                      *
    * Element-less Methods *
    *                      *
    ***********************/
    
    function dragOnNothing() {
        if (dragObject)
            dragObject.followMouse();
    }
    
    function upOnNothing() {
        isEnded = true;
        controller.respondTo("cancelDrag", [this]);
        
        BPMouseEvent.currentMouseEvent = null;
    }

    /*****************
    *                *
    * Helper Methods *
    *                *
    *****************/
    
    function patch():BPPatch {
        return path.current();
    }
    
    function started():Boolean {
        return isStarted;
    }

    function dragging():Boolean {
        return isDragging;
    }
    
    function ended():Boolean {
        return isEnded;
    }

}