import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPImage extends BPGuiElement {
    
    var imageName:String;
    
    function BPImage(controller:BPController, imageName:String) {
        super(controller, true);
        
        this.imageName = imageName;
        
        var data = flash.display.BitmapData.loadBitmap(imageName);
        movieClip.attachBitmap(data, 0, "auto", true);
    }

    /***************************
    *                          *
    * Loading & Saving Methods *
    *                          *
    ***************************/
    
    function toXml(bank:String) {
        return "<image source='" + imageName + "' bank='" + allBanks() + "' left='" + left + "' top='" + top + "' scale='" + fraction + "' />\n";
    }

    static function loadFromXml(controller:BPController, xml:XML) {
        return new BPImage(controller, xml.attributes.source);
    }

}