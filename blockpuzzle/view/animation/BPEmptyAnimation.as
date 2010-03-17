import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPEmptyAnimation extends BPSchedulable {

    var seconds:Number;
    
    function BPEmptyAnimation(seconds) {
        this.seconds = seconds;
    }
    
    function start() {
        super.start();
        
        if (seconds) {
            setDuration( seconds );
        } else {
            finish();
        }
    }

}