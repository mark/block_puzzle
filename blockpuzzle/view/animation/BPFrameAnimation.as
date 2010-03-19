import blockpuzzle.view.sprite.*;
import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPFrameAnimation extends BPAnimation {
    
    var sprite:BPSpriteChange;
    
    var sequence:Array;
    
    var nextFrame:Number;
    var nextChange:Number;

    var duration:Number;
    var rate:Number;
    
    var instant:Boolean;
    var continuous:Boolean;
    
    function BPFrameAnimation(sprite:BPSpriteChange, sequence:Array, options) {
        super(sprite.sprite);
        
        this.sprite     = sprite;
        this.sequence   = sequence;
        
        this.duration   = options.seconds;
        this.rate       = options.speed;
        this.instant    = (options.speed == null && options.seconds == null) || changes() == 0;
        this.continuous = options.continuous;
    }

    function changes():Number {
        return sequence.length - 1;
    }
    
    function setup() {
        if (instant) {
            listenFor("BPAnimationStart", this, finish);
        } else {
            if (duration == null) duration = rate * changes();
            if (rate == null) rate = duration / changes();
            
            nextFrame = 1;
            nextChange = rate;
            
            if (continuous) {
                duration = null;
            }
        }

        setFrame(0);
    }
    
    function animate() {
        if (elapsed() >= nextChange) {
            nextChange += rate;
            setFrame(nextFrame);
            nextFrame++;
            
            if (continuous && nextFrame == sequence.length) nextFrame = 0;
        }
    }
    
    function cleanup() {
        setFrame(sequence.length - 1);
    }
    
    function setFrame(index) {
        //trace("\t" + id() + " frame -> " + sequence[index] + "\t" + completion());
        sprite.change("frame", sequence[index]);
    }
}