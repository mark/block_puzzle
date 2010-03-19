import blockpuzzle.view.animation.BPAnimation;

class blockpuzzle.view.animation.BPEmptyAnimation extends BPAnimation {

    var seconds:Number;
    
    function BPEmptyAnimation(seconds) {
        setDuration( (seconds === null) ? 0.0 : seconds );
    }

}