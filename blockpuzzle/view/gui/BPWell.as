import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;
import blockpuzzle.controller.pen.*;

class blockpuzzle.view.gui.BPWell extends BPGuiElement {

    static var FullSize         = 48.0;
    static var MaxDraggableSize = 36.0;
    
    var dragObject:BPDragObject;
    var wellKey:String;
    var settings:Object;
    
    function BPWell(controller:BPController, wellKey:String, settings:Object) {
        super(controller, false);
        this.wellKey = wellKey;
        this.settings = settings;
        
        createMovieClip("DragWell");
    }
    
    function centerX():Number { return left + BPWell.FullSize * fraction / 2.0; }
    function centerY():Number { return top  + BPWell.FullSize * fraction / 2.0; }
    
    function attach(dragKey:String, clipName:String, frameName:String, isCentered:Boolean) {
        dragObject = new BPDragObject(dragKey, clipName, frameName, isCentered);

        dragObject.centerAt(centerX(), centerY());
        dragObject.resizeTo(BPWell.MaxDraggableSize * fraction);
    }
    
    /*******************
    *                  *
    * Override Methods *
    *                  *
    *******************/
    
    function at(top:Number, left:Number):BPGuiElement {
        super.at(top, left);
        dragObject.centerAt(centerX(), centerY());
        return this;
    }
    
    function scale(fraction:Number):BPGuiElement {
        super.scale(fraction);
        dragObject.resizeTo(BPWell.MaxDraggableSize * fraction);
        return this;
    }
    
    function hide() {
        super.hide();
        dragObject.hide();
    }
    
    function show() {
        super.show();
        dragObject.show();
    }

    function onMouseDown() {
        // this.dragObject.attach();
        //if (dragObject) controller.respondTo(wellKey + "Drag", [ dragObject ]);
        if (dragObject != null && isHit()) {
            var event = new BPMouseEvent(controller);

            event.attach(dragObject);
            this.dragObject = null;

            event.downOnWell(this);
        }
    }
    
    function onMouseUp() {
        if (mouse() != null && isHit()) {
            mouse().upOnWell(this);
        }
    }
}
