import blockpuzzle.base.BPObject;
import blockpuzzle.model.game.BPPatch;
import blockpuzzle.model.collection.BPRegion;

class blockpuzzle.model.collection.BPPath {
    
    var path:Array;
    
    function BPPath() {
        path = new Array();
    }
    
    /***************
    *              *
    * Base Methods *
    *              *
    ***************/
    
    function length():Number {
        return path.length;
    }
    
    function addStep(patch:BPPatch) {
        path.push(patch);
    }
    
    function region():BPRegion {
        return new BPRegion(path);
    }
    
    /***************
    *              *
    * Step Methods *
    *              *
    ***************/
    
    function step(n:Number):BPPatch {
        return path[n];
    }
    
    function start() {
        return step(0);
    }
    
    function current() {
        return step( this.length() - 1 );
    }
    
    function previous() {
        return step( this.length() - 2 );
    }
    
    /**************
    *             *
    * Walk Method *
    *             *
    **************/
    
    function walk(walk_fcn:Function, info:Object):Object { //, start:Number, steps:Number)
        var prev:BPPatch;
        
        for (var i = 0; i < this.length(); i++) {
            info = walk_fcn.call(null, prev, step(i), info);
            prev = step(i);
        }
        
        return info;
    }
    
}