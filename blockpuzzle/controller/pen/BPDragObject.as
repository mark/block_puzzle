import blockpuzzle.base.BPObject;
import blockpuzzle.view.gui.BPGeometry;

class blockpuzzle.controller.pen.BPDragObject extends BPObject {
    
    // How to identify what is being dragged
    
    var dragKey:String;
    
    // The draggable clip
    
    var movieClip:MovieClip;
    var isCentered:Boolean; // is the registration point in the center?
    
    // How big the movie clip is at 100% size
    
    var originalWidth:Number;
    var originalHeight:Number;
    
    // Where it is currently located
    
    var centerX:Number;
    var centerY:Number;
    var maxSize:Number;
    
    // Where it's being held (during a drag)
    
    var mouseDX:Number;
    var mouseDY:Number;
    
    function BPDragObject(dragKey:String, clipName:String, frameName:String, isCentered:Boolean) {
        if (clipName == null) clipName = dragKey;
        movieClip = _root.attachMovie(clipName, "BPDragObject_" + id(), BPGeometry.INTERFACE_DEPTH + id());
        
        if (frameName != null) movieClip.gotoAndStop(frameName);

        movieClip._visible = false;
        
        this.dragKey        = dragKey
        this.isCentered     = isCentered;
        this.originalWidth  = movieClip._width;
        this.originalHeight = movieClip._height;

        storePosition(0.0, 0.0, Math.max(originalHeight, originalWidth));
    }
    
    function centerAt(centerX:Number, centerY:Number) {
        position(centerX, centerY, maxSize);
    }

    function resizeTo(maxSize:Number) {
        position(centerX, centerY, maxSize);
    }
    
    function position(centerX:Number, centerY:Number, maxSize:Number) {
        var scaleX      = maxSize / originalWidth;
        var scaleY      = maxSize / originalHeight;
        var scaleFactor = Math.min(1.0, Math.min(scaleX, scaleY));
        var width       = originalWidth  * scaleFactor;
        var height      = originalHeight * scaleFactor;
        
        movieClip._width  = width;
        movieClip._height = height;

        if (isCentered) {
            movieClip._x = centerX;
            movieClip._y = centerY;
        } else {
            movieClip._x = centerX - width  / 2.0;
            movieClip._y = centerY - height / 2.0;
        }

        storePosition(centerX, centerY, maxSize);
        stopFollowingMouse();
    }
    
    function storePosition(centerX:Number, centerY:Number, maxSize:Number) {
        this.centerX = centerX;
        this.centerY = centerY;
        this.maxSize = maxSize;
    }
    
    function attach() {
        var dx = _root._xmouse - movieClip._x;
        var dy = _root._ymouse - movieClip._y;
        
        var rx = dx / movieClip._width;
        var ry = dy / movieClip._height;

        mouseDX = rx * originalWidth;
        mouseDY = ry * originalHeight;
        
        movieClip._width = originalWidth;
        movieClip._height = originalHeight;        
        
        var dragObject = this;
        movieClip.onMouseMove = function() { dragObject.followMouse(); };

        followMouse();
    }
    
    function detatch() {
        
    }

    function followMouse() {
        movieClip._x = _root._xmouse - mouseDX;
        movieClip._y = _root._ymouse - mouseDY;
    }
    
    function stopFollowingMouse() {
        movieClip.onMouseMove = null;
    }
    
    function hide() {
        movieClip._visible = false;
    }

    function show() {
        movieClip._visible = true;
    }

}
