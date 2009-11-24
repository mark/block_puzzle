import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPFadeAnimation extends BPAnimation {

	var seconds:Number;
	var direction:Boolean;
	
	function BPFadeAnimation(target, direction:Boolean) {
		super(target);
		this.direction = (direction != null) ? direction : true;
	}
	
	function setup() {
	    movieClip._visible = true;
	}
	
	function animate(completion:Number) {
		var n = (1.0 - completion) * 100.0;
		movieClip._alpha = direction ? n : 100.0 - n;
	}
	
	function cleanup() {
    	movieClip._visible = ! direction;
		movieClip._alpha = 100;
    }
    
}