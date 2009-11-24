import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPButtonArray extends BPGuiElement {
        
    var buttons:Array;

    var currentButton:Object;
    
    var buttonGroups:Object;
    var currentButtonInGroup:Object;
    
    static var ButtonBackground = [
        "Center", "Center",   "Center",      "Center",
        "Center", "TopLeft",  "BottomLeft",  "Left",
        "Center", "TopRight", "BottomRight", "Right",
        "Center", "Top",      "Bottom",      "Single"
    ];
    
    function BPButtonArray(controller:BPController, buttons:Array) {
        super(controller, true);
        
        this.buttons = buttons;
        this.buttonGroups = new Object();
        this.currentButtonInGroup = new Object();
    
        for (var y = 0; y < buttons.length; y++) {
            for (var x = 0; x < buttons[y].length; x++) {
                var button = buttons[y][x];

                if (button != null) {
                    button.setController(controller);
                    
                    var bkgnd = movieClip.attachMovie(button.backgroundSet(), "Button(" + x + ", " + y + ")", 3 * (buttons.length * x + y));
                    bkgnd.gotoAndStop(nameForButton(x, y) + "Up");

                    bkgnd._x = 48.0 * x;
                    bkgnd._y = 48.0 * y;

                    var icon = movieClip.attachMovie(button.iconSet(), "Icon(" + x + ", " + y + ")", 3 * (buttons.length * x + y) + 1);
                    icon.gotoAndStop(button.icon());

                    icon._x = 48.0 * x + 24.0;
                    icon._y = 48.0 * y + 24.0;

                    var highlight = movieClip.attachMovie("Button Highlight", "Highlight(" + x + ", " + y + ")", 3 * (buttons.length * x + y) + 2);

                    highlight._x = 48.0 * x;
                    highlight._y = 48.0 * y;
                    
                    if (button.group()) {
                        addButtonToGroup(x, y, button.group());
                    }
                }
            }
        }
    }
    
    function onMouseDown() {
        var buttonY = Math.floor((_ymouse - top) / this.buttonSize());
        var buttonX = Math.floor((_xmouse - left) / this.buttonSize());
        
        this.press(buttonX, buttonY);
    }


    function onMouseMove() {
        var buttonY = Math.floor((_ymouse - top) / this.buttonSize());
        var buttonX = Math.floor((_xmouse - left) / this.buttonSize());
        
        this.move(buttonX, buttonY);
    }

    function onMouseUp() {
        var buttonY = Math.floor((_ymouse - top) / this.buttonSize());
        var buttonX = Math.floor((_xmouse - left) / this.buttonSize());
        
        this.release(buttonX, buttonY);
    }
    
    function press(x:Number, y:Number) {
        var button = buttons[y][x];
        
        if (button) {
            currentButton = { x:x, y:y };
            setButtonState(x, y, true);
            
            if (button.callOnDown()) {
                button.call();
            }
        }
    }

    function move(x:Number, y:Number) {
        if (currentButton) {
            setButtonState(currentButton.x, currentButton.y, currentButton.x == x && currentButton.y == y);
        }
    }
    
    function release(x:Number, y:Number) {
        setButtonState(currentButton.x, currentButton.y, false);

        if (currentButton.x == x && currentButton.y == y) {
            // Actual button press
            
            if (! buttons[y][x].callOnDown()) {
                buttons[y][x].call();
            }
            
            if (buttons[y][x].group()) {
                var group = buttons[y][x].group();
                
                currentButtonInGroup[group] = [x, y];
                
                for (var i = 0; i < buttonGroups[group].length; i++) {
                    var button = buttonGroups[group][i];
                    
                    setButtonState(button[0], button[1], false);
                }
            }
        }

        currentButton = null;
    }
    
    function nameForButton(x:Number, y:Number) {
        var button = buttons[y][x];        
        if (button.background() != null) return button.background();

        var index = 0;
        
        if (buttons[y-1][x] == null) index += 1;
        if (buttons[y+1][x] == null) index += 2;

        if (buttons[y][x-1] == null) index += 4;
        if (buttons[y][x+1] == null) index += 8;
        
        return ButtonBackground[index];
    }    
    
    function setButtonState(x:Number, y:Number, down:Boolean) {
        var clip = movieClip["Button(" + x + ", " + y + ")"];
        var group = buttons[y][x].group();
        
        if (group != null && currentButtonInGroup[group][0] == x && currentButtonInGroup[group][1] == y) {
            var state = down ? "Down" : "Toggle";
        } else {
            var state = down ? "Down" : "Up";
        }

        var frame = nameForButton(x, y) + state;
        
        clip.gotoAndStop(frame);
    }
    
    function addButtonToGroup(x:Number, y:Number, group:String) {
        if (buttonGroups[group] == null) buttonGroups[group] = new Array();
        
        buttonGroups[group].push([x, y]);
    }
    
    function buttonSize():Number {
        return 48.0 * fraction;
    }
    
    function toString() { return "Button Array:" + id(); }
    
    /*****************
    *                *
    * Helper methods *
    *                *
    *****************/
    
    static function loadFromXml(controller:BPController, xml:XML) {
        var buttons = new Array();
        
        for (var i = 0; i < xml.childNodes.length; i++) {
            var row = xml.childNodes[i];
            
            if (row.nodeName == "button-row") {
                var rowArray = new Array();

                for (var j = 0; j < row.childNodes.length; j++) {
                    var btn = row.childNodes[j];
                    
                    if (btn.nodeName == "button") {
                        var button = BPButton.loadFromXml(btn);
                        
                        rowArray.push(button);
                    }
                    
                    if (btn.nodeName == "blank") {
                        rowArray.push(null);
                    }
                }
                
                buttons.push(rowArray);
            }
        }
        
        return new BPButtonArray(controller, buttons);
    }
    
    function toXml(bank:String) {
        var s = new String();
        
        s += "<button-array bank='" + allBanks() + "' left='" + left + "' top='" + top + "' scale='" + fraction + "'>\n";
        
        for (var i = 0; i < buttons.length; i++) {
            s += "<button-row>\n";
            
            for (var j = 0; j < buttons[i].length; j++) {
                if (buttons[i][j])
                    s += buttons[i][j].toXml();
                else
                    s += "<blank />\n";
            }
            
            s += "</button-row>\n"
        }
        
        s += "</button-array>\n";
        
        return s;
    }

}