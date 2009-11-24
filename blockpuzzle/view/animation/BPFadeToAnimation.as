import blockpuzzle.view.animation.*;

class blockpuzzle.view.animation.BPFadeToAnimation extends BPAnimation {

	var seconds:Number;
	var fadeTo:String;
	var fadeFrom:String;
	var overlayMC:MovieClip;
	var fadeAnimation:BPFadeAnimation;
	
	function BPFadeToAnimation(target, startkey:String, endkey:String) {
		super(target);

		fadeFrom = startkey
		fadeTo = endkey;
	}
	
	function setup() {
		overlayMC = target.generateMovieClipOverlay(target.movieClip._grid);

		fadeAnimation = new BPFadeAnimation(overlayMC);
        
		fadeAnimation.endWhenAnimationEnds(this);
        
		target.setKey(fadeTo);
		target.setFrame();

		fadeAnimation.start();
	}
	
	function cleanup() {
    	overlayMC.removeMovieClip();
    }
    
}