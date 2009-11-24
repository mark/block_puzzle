import blockpuzzle.model.game.*;
import blockpuzzle.controller.game.BPController;
import blockpuzzle.controller.pen.BPMouseEvent;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPGrid extends BPGuiElement {
    
    var geom:BPGeometry;
    
    var layers:Object;
    
    var board:BPBoard;
    
    static var LAYERS = [ "underlayLayer", "patchLayer", "innerLayer", "actorLayer", "overlayLayer" ];
    
    function BPGrid(controller:BPController, geometry:BPGeometry) {
        super(controller, true);
        
        this.geom = geometry;
        geometry.setGrid(this);
        
        this.layers = new Object();

        for (var i = 0; i < LAYERS.length; i++) {
            layers[LAYERS[i]] = movieClip.createEmptyMovieClip(LAYERS[i], i);
        }
    }
    
    function geometry():BPGeometry {
        return geom;
    }
    
    function layer(layerName:String):MovieClip {
        return layers[layerName];
    }
 
    static function loadFromXml(controller:BPController, xml:XML):BPGrid {
        var geom:BPGeometry;
        
        for (var i = 0; i < xml.childNodes.length; i++) {
            var child = xml.childNodes[i];
            
            if (child.nodeName == "geometry") {
                geom = BPGeometry.loadFromXml(child);
            }
            
            // No more children for now...
        }
        
        var grid = new BPGrid(controller, geom);
        
        return grid;
    }
 
    function setBoard(board:BPBoard) {
        this.board = board;
    }
    
    /****************
    *               *
    * Mouse Methods *
    *               *
    ****************/

    function patchHit():BPPatch {
        var x = geometry().screenToGridX(movieClip._xmouse);
        var y = geometry().screenToGridY(movieClip._ymouse);

        return board.getPatch(x, y);
    }
    
    function onMouseDown() {
        if (isHit()) {
            var event = new BPMouseEvent(controller);
            event.downOnGrid(patchHit());
        }
    }
    
    function onMouseMove() {
        if (mouse() != null && isHit()) {
            var patch = patchHit();
            
            mouse().dragOnGrid(patchHit(), geometry().xCenterForPatch(patch) + movieClip._x, geometry().yCenterForPatch(patch) + movieClip._y);
        }
    }
    
    function onMouseUp() {
        if (mouse() != null && isHit()) {
            mouse().upOnGrid(patchHit());
        }
    }
    
}