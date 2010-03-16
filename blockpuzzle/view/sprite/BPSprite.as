import blockpuzzle.base.BPObject;
import blockpuzzle.model.game.BPPatch;
import blockpuzzle.view.gui.BPGeometry;
import blockpuzzle.view.animation.*;
import blockpuzzle.view.sprite.*;

class blockpuzzle.view.sprite.BPSprite extends BPObject {

    static var ValidBlends = { x: "x", y: "y", rotation: "rotation", width: "width", height: "height", fade: "fade",
                               x_y: ["x", "y"], w_h: ["width", "height"], dx_dy: ["dx", "dy"] };
    
    static var VisualAttributes = { x: "_x", y: "_y", rotation: "_rotation", fade: "_alpha", width: "_width", height: "_height", dx: "_dx", dy: "_dy" };
    
    // Instance Variables

    var owner:Object;        // What owns this sprite
    
    var movieClip:MovieClip; // The movie clip itself
    var geom:BPGeometry;     // The screen's geometry
    var clip:String;         // The linkage name of the movie clip
    var clipName:String;     // The unique identifier of the movie clip
    var clipDepth:Number;    // The z-axis depth of the movie clip

    var animations:Array;    // The animations that this sprite is currently involved in...
    
    // Options:
    
    var centered:Boolean;
    
    // For redrawing:
    
    var updates:BPSpriteChange;
    var updatedThisFrame:Boolean;
    
    /**************
    *             *
    * Constructor *
    *             *
    **************/
    
    function BPSprite(owner, clip:String, options:Object) {
        this.owner      = owner;
        this.clip       = clip;
        this.clipName   = "Sprite_" + id;
        this.clipDepth  = options.depth != null ? options.depth : id();
        this.geom       = options.geometry;
        this.centered   = options.centered;
        this.animations = new Array();
        
        generateMovieClip(options.parent, clipDepth, options.visible === false);
        
		this.updates = new BPSpriteChange(this);
		// listenFor("BPAnimationCreated", this, animationCreated);
		// listenFor("BPAnimationStopped", this, animationStopped);
    }

    function destroy() {
        movieClip.removeMovieClip();
    }
    
    /******************
    *                 *
    * Visual Elements *
    *                 *
    ******************/

    function generateMovieClip(parent:MovieClip, depth:Number, hidden:Boolean) {
        movieClip = parent.attachMovie(clip, clipName, depth);
        movieClip._visible = true;
		movieClip._alpha = hidden ? 0 : 100;
        movieClip._x = 0;
        movieClip._dx = 0;
        movieClip._real_x = 0;
        movieClip._y = 0;
        movieClip._dy = 0;
        movieClip._real_y = 0;
		movieClip.gotoAndStop(1);
    }
    
    // I think this is temporary
    
    function setFrame(frame:String) {
        movieClip.gotoAndStop(frame);
    }
    
    /*************
    *            *
    * Movie Clip *
    *            *
    *************/
    
    function getMovieClip() {
        return movieClip;
    }
    
    function get(method) {
        return movieClip[VisualAttributes[method]]
    }
    
    function updated() {
        if (! updatedThisFrame) {
            updatedThisFrame = true;
            later(repaint, "repaint");
        }
    }
    
    function repaint() {
        ////trace('repaint')
        updates.update();
        updates.clearChanges();
        updatedThisFrame = false;
    }
    
    /*******************
    *                  *
    * Dragging Methods *
    *                  *
    *******************/
    
    // Have the movie clip follow the mouse
    function startDrag() {
    	movieClip._x = _xmouse;
    	movieClip._y = _ymouse;
    	movieClip.startDrag();
    }
    
    // Have the movie clip no longer follow the mouse
    function stopDrag() {
        movieClip.stopDrag();
    }
    
    /*******************
    *                  *
    * Animation Blends *
    *                  *
    *******************/
    
    // The atomic animation function
    
    function animate(method:String, options):BPBlend {
        var blend:BPBlend;

        if (ValidBlends[method]) {
            
            if (ValidBlends[method] instanceof Array) blend = new BP2DBlend(updates, ValidBlends[method], options);
            else if (method == "rotation") blend = new BPCircularBlend(updates, ValidBlends[method], options);
            else blend = new BPBlend(updates, ValidBlends[method], options);
        }
        
        return blend;
    }

    // Derived animation functions

    function goto(where, options):BPBlend {
        if (options == null) options = new Object();
        
        if (where instanceof BPPatch) {
            options.to_x = geom.leftForPatch(where) + (centered ? geom.lengthForCells(0.5) : 0.0);
            options.to_y = geom.topForPatch(where) + (centered ? geom.lengthForCells(0.5) : 0.0);
            
            if (options.speed) options.speed = geom.lengthForCells(options.speed);
        } else if (where instanceof Array) {
            options.to_x = where[0];
            options.to_y = where[1];
        }

        return animate("x_y", options);
    }
    
    function shift(how_much, options):BPBlend {
        if (options == null) options = new Object();
        
        options.to_x  = how_much[0];
        options.to_y  = how_much[1];

        return animate("dx_dy", options);
    }
    
    function hide(options):BPBlend {
        return fade(0.0, options);
    }

    function show(options):BPBlend {
        return fade(100.0, options);
    }
    
    function fade(to:Number, options):BPBlend {
        var opts = copyOptions(options);
        opts.to = to;
                
        return animate("fade", opts);
    }
    
    function rotate(direction, options):BPBlend {
        var opts = copyOptions(options);
        opts.to = direction;
        
        return animate("rotation", opts);
    }
    
    function turn(direction, options):BPBlend {
        var opts = copyOptions(options);
        opts.by = direction;
        
        return animate("rotation", opts);
    }
    
    function resize(dimensions:Array, options) {
        if (options == null) options = new Object();
        
        options.to_x = geom.lengthForCells(dimensions[0]);
        options.to_y = geom.lengthForCells(dimensions[1]);
        options.speed = geom.lengthForCells(options.speed);

        // options.to_x = dimensions[0];
        // options.to_y = dimensions[1];

        return animate("w_h", options);
    }
    
    /**************************
    *                         *
    * Non-Blending Animations *
    *                         *
    **************************/
    
    function frame(frame_or_sequence, options):BPFrameAnimation {
        var sequence:Array;
        if (frame_or_sequence instanceof Array)
            sequence = frame_or_sequence;
        else
            sequence = [ frame_or_sequence ];
        
        return new BPFrameAnimation(updates, sequence, options);
    }
    
    /***************
    *              *
    * Idle Methods *
    *              *
    ***************/
    
    function animationCreated(animation) {
        animations.push(animation);
        
        owner.animationCreated(animation);
    }
    
    function animationStopped(animation) {
        for (var i = 0; i < animations.length; i++) {
            if (animations[i] == animation) animations.splice(i, 1);
        }
        
        owner.animationStopped(animation);
    }

    /******
    *     *
    * ??? *
    *     *
    ******/
    
    function finishAnimations() {
        for (var i = 0; i < animations.length; i++) {
            animations[i].finish();
        }
    }

    /*****************
    *                *
    * Helper methods *
    *                *
    *****************/

    function geometry() {
        return geom;
    }
    
    function printOptions(options) {
        for (var o in options) {
            //trace("options[" + o + "] = " + options[o]);
        }
    }

    function copyOptions(options) {
        var newOptions = new Object();
        
        for (var key in options) {
            newOptions[key] = options[key];
        }
        
        return newOptions;
    }

}