import blockpuzzle.controller.game.BPController;
import blockpuzzle.view.gui.*;

class blockpuzzle.view.gui.BPLabel extends BPGuiElement {
    
    var rawValue;
    var formattedText:String;

    var format:String;

    var textFormat:TextFormat;
    
    function BPLabel(controller:BPController, format:String) {
        super(controller, false);
        
        createMovieClip("Label");
        
        displayAs(format == null ? "plain" : format);
        this.textFormat = movieClip.labelText.getNewTextFormat();
    }

    /*************
    *            *
    * Formatting *
    *            *
    *************/
    
    function setFormat(font:String, bold:Boolean, italic:Boolean) {
        textFormat.font = font;
        textFormat.bold = bold;
        textFormat.italic = italic;

        movieClip.labelText.setNewTextFormat(textFormat);
        
        update(rawValue);
    }

    function setAlignment(align:String) {
        movieClip.labelText.autoSize = align;
    }
    
    function displayAs(format:String) {
        if (this[format + "Format"]) {
            this.format = format.toLowerCase();
        }
    }
    
    function setColor(textColor:Number, backgroundColor:Number) {
        if (textColor) movieClip.labelText.textColor = textColor;
        if (backgroundColor) {
            movieClip.labelText.background = true;
            movieClip.labelText.backgroundColor = backgroundColor;
        } else {
            movieClip.labelText.background = false;
        }
    }
    
    function scale(fraction) {
        super.scale(fraction);
        
        updateSize();
        
        return this;
    }
    
    function updateSize() {
        movieClip.labelText._width  = this.movieClip.labelText.textWidth  + 8.0;
        movieClip.labelText._height = this.movieClip.labelText.textHeight + 8.0;
    }
    
    /*********************
    *                    *
    * Label Text Methods *
    *                    *
    *********************/
    
    function update(rawValue) {
        this.rawValue = rawValue;
        
        movieClip.labelText.text = formattedText = this[format + "Format"](rawValue);
        
        updateSize();
    }
    
    function plainFormat(raw) {
        return raw.toString();
    }
    
    function moneyFormat(raw) {
        var money = Math.floor(Number(raw) * 100);
        
        var cents = Math.floor(money % 100);
        var dollars = Math.floor(money / 100);
        
        return "$" + scoreFormat(dollars) + "." + (cents < 10 ? "0" : "") + cents;
    }
    
    function scoreFormat(raw) {
        var text = Number(raw).toString();
        var split = text.split("").reverse();
        var splitted = new Array();
        
        for (var i = 0; i < split.length; i++) {
            if (i % 3 == 0 && i != 0) splitted.push(",");
            splitted.push(split[i]);
        }
        
        return splitted.reverse().join("");
    }

    function timerFormat(raw) {
        var time = Math.floor(Number(raw));
        
        var seconds = Math.floor(time % 60);
        var minutes = Math.floor(time / 60 % 60);
        var hours = Math.floor(time / 3600);
        
        var formatted = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
        if (hours > 0) formatted = hours + ":" + (minutes < 10 ? "0" : "") + formatted;
        
        return formatted;
    }

    /***************************
    *                          *
    * Saving & Loading Methods *
    *                          *
    ***************************/
    
    function toXml(bank:String):String {
        var textColor = movieClip.labelText.textColor;
        var backgroundColor = movieClip.labelText.backgroundColor;
        var autoSize = movieClip.labelText.autoSize;
        
        var s = "<label bank='" + allBanks() + "' top='" + top + "' left='" + left + "' scale='" + fraction + "' color='" + backgroundColor + "'>\n";
        s += "<text format='" + format + "' color='" + textColor + "'>" + rawValue + "</text>\n";
        s += "<font bold='" + textFormat.bold + "' italic='" + textFormat.italic + "' align='" + autoSize + "'>" + textFormat.font + "</font>\n";
        s += "</label>";

        return s;
    }
    
    static function loadFromXml(controller:BPController, xml:XML) {
        var font, bold, italic, textColor, backgroundColor, format, alignment, text;

        backgroundColor = xml.attributes.color;
        
        for (var i = 0; i < xml.childNodes.length; i++) {
            var child = xml.childNodes[i];
            
            if (child.nodeName == "text") {
                format = child.attributes.format;
                textColor = child.attributes.color;
                alignment = child.attributes.align;
                text = child.childNodes[0];
            }
            
            if (child.nodeName == "font") {
                bold = child.attributes.bold == "true";
                italic = child.attributes.italic == "true";
                font = child.nodeValue;
            }
        }
        
        var label = new BPLabel(controller, format);
        label.setAlignment(alignment);
        label.setFormat(font, bold, italic);
        label.setColor(textColor, backgroundColor);
        label.update(text);
        
        return label;
    }

}