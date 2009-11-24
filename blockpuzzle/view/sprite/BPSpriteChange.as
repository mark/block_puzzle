import blockpuzzle.view.sprite.*;

class blockpuzzle.view.sprite.BPSpriteChange {
    
    var sprite:BPSprite;
    
    var changes:Object;
    
    function BPSpriteChange(sprite:BPSprite) {
        this.sprite = sprite;
        this.changes = new Object();
    }
    
    function get(method):Number {
        if (changes[method])
            return changes[method];
        else
            return sprite.get(method);
    }
    
    function change(method, value) {
        // //trace("\t" + sprite + "." + method + " -> " + value);
        changes[method] = value;
        
        sprite.updated();
    }
    
    function update() {
        var clip = sprite.getMovieClip();
        
        if (changes.x != null) {
            clip._x = changes.x;
            clip._real_x = changes.x;
        }    
            
        if (changes.dx != null) {
            clip._dx = changes.dx;
            clip._x = clip._real_x + clip._dx;
        }
        
        if (changes.y != null) {
            clip._y = changes.y;
            clip._real_y = changes.y;
        }
        
        if (changes.dy != null) {
            clip._dy = changes.dy;
            clip._y = clip._real_y + clip._dy;
        }
        
        var oldRotation = clip._rotation;
        clip._rotation = 0;
        
        if (changes.width != null) clip._width = changes.width;
        if (changes.height != null) clip._height = changes.height;

        if (changes.rotation != null)
            clip._rotation = changes.rotation;
        else
            clip._rotation = oldRotation;
            
        if (changes.fade != null) clip._alpha = changes.fade;
        
        if (changes.frame != null) clip.gotoAndStop(changes.frame);
    }
    
    function clearChanges() {
        for (var key in changes) {
            changes[key] = null;
        }
    }
    
}