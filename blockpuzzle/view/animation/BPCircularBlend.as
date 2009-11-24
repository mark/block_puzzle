import blockpuzzle.view.sprite.BPSpriteChange;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPCircularBlend extends BPBlend {

    var isClockwise:Boolean;
    var isCounterclockwise:Boolean;

    var by:Number;
    
    function BPCircularBlend(sprite:BPSpriteChange, methods, options) {
        super(sprite, methods, options);

        this.isClockwise = options.clockwise;
        this.isCounterclockwise = options.counterclockwise;
    }
    
    function setup() {
        var clockwise:Boolean;

        // Get the initial value
        if (initial == null) initial = sprite.get(method);

        // Set to within 0-360
        while (initial > 360.0) initial -= 360.0;
        while (initial < 0.0)   initial += 360.0;

        // Figure our which direction we're actually rotating
        if (isClockwise != null) {
            clockwise = isClockwise;
        } else if (isCounterclockwise != null) {
            clockwise = ! isCounterclockwise;
        } else {
            clockwise = (initial > final) == Math.abs(initial - final) > 180.0;
        }        

        // Make sure that we have a straight shot to the final, and the sign for rate is correct
        if (clockwise) {
            if (by != null)
                final = initial + by;
            else
                while (initial > final) final += 360.0;

            rate = Math.abs(rate);
        } else {
            if (by != null)
                final = initial - by;
            else
                while (initial < final) final -= 360.0;

            rate = -Math.abs(rate);
        }
        
        if (duration == null) duration = Math.abs(final - initial) / Math.abs(rate);
        
        setupBlend();
    }

}
