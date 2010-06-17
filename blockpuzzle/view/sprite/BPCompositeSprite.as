import blockpuzzle.view.animation.BPFrameAnimation;
import blockpuzzle.view.sprite.*;

class blockpuzzle.view.sprite.BPCompositeSprite extends BPSprite {
    
    var nextDepth:Number;
    var elements:Array;
    
    var mainLayer:BPSprite;
    
    function BPCompositeSprite(owner, options) {
        super(owner, null, options);
        
        elements = new Array();
    }
    
    function generateMovieClip(parent, depth):MovieClip {
        var mc:MovieClip;
        
        mc = parent.createEmptyMovieClip("Sprite_" + id(), depth);
        mc._x = 0;
        mc._dx = 0;
        mc._real_x = 0;
        mc._y = 0;
        mc._dy = 0;
        mc._real_y = 0;
		mc._visible = true;
		mc._alpha = 100;

		nextDepth = 0;
		
		return mc;
    }
    
    function duplicateMovieClip(newParent:MovieClip, newDepth:Number):MovieClip {
        var mc = newParent.createEmptyMovieClip("Sprite_" + id(), newDepth);

        mc._x = movieClip._x;
        mc._dx = movieClip._dx;
        mc._real_x = movieClip._real_x;
        mc._y = movieClip._y;
        mc._dy = movieClip._dy;
        mc._real_y = movieClip._real_y;
		mc._visible = movieClip._visible;
		mc._alpha = movieClip._alpha;

        for (var i = 0; i < elements.length; i++) {
            if (elements[i] instanceof BPSprite) {}
        }
        
		return mc;
    }
    
    function layer(depth:Number):BPSprite {
        return elements[depth];
    }
    
    function addSpriteLayer(clip:String, depth:Number):BPSprite {
        depth = getDepth(depth);
        
        var newSprite = new BPSprite(owner, clip, { parent: movieClip, depth: depth, geometry: geom });
        elements[depth] = newSprite;
        
        if (mainLayer == null) mainLayer = newSprite;
        
        return newSprite;
    }
    
    function addEmptyLayer(depth:Number):BPCompositeSprite {
        depth = getDepth(depth);
        
        var newSprite = new BPCompositeSprite(owner, { parent: movieClip, depth: depth, geometry: geom });
        elements[depth] = newSprite;
        
        return newSprite;
    }

    function setLayer(sprite:BPSprite, depth:Number):BPSprite {
        return sprite;
    }
    
    function getDepth(givenDepth:Number):Number {
        if (givenDepth == null) {
            return nextDepth++;
        } else {
            if (givenDepth >= nextDepth) nextDepth = givenDepth + 1;

            return givenDepth;
        }
    }
    
    /******
    *     *
    * ??? *
    *     *
    ******/
    
    function finishAnimations() {
        super.finishAnimations();
        
        for (var i = 0; i < elements.length; i++) {
            elements[i].finishAnimations();
        }
    }
    
    /*********************
    *                    *
    * Main Layer Methods *
    *                    *
    *********************/
    
    // Composite sprites don't have frames, so calls to change the frame get sent to the main layer instead.
    // By default, the main layer is the first defined sprite layer, but that can be changed.
    
    function setMainLayer(newMainLayer:BPSprite) {
        mainLayer = newMainLayer;
    }
    
    // Intercept the animation call and pass it on to the main layer...
    
    function frame(frame_or_sequence, options):BPFrameAnimation {
        return mainLayer.frame(frame_or_sequence, options);
    }
    
}