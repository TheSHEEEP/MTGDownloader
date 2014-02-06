
package eu.jdrabner.mtgdownloader.screens;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.net.URLRequest;
import flash.Lib;
import openfl.Assets;
import haxe.htmlparser.HtmlDocument;
import haxe.htmlparser.HtmlNodeElement;
import eu.jdrabner.ui.SVGTextButton;
import eu.jdrabner.mtgdownloader.download.FileDownloader;

class ScanScreen extends Sprite
{
    private var _bgColor     :Int;
    private var _fontColor   :Int;
    private var _relSize     :Float;
    private var _font        :String;

    private var _hint       :TextField;
    private var _allBtn     :SVGTextButton;
    private var _noneBtn    :SVGTextButton;
    private var _invertBtn  :SVGTextButton;
    private var _okBtn      :SVGTextButton;

    /**
     * Constructor.
     * @param  p_bgColor   The background color.
     * @param  p_fontColor The font color.
     * @param  p_relSize   The relative height of the screen, relative to stage height (0 .. 1).
     * @param  p_font      The font to use.
     */
    public function new(p_bgColor :Int, p_fontColor :Int, p_relSize :Float, p_font :String)
    {
        super();

        // Remember values
        _bgColor = p_bgColor;
        _fontColor = p_fontColor;
        _relSize = p_relSize;
        _font = p_font;

        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    /**
     * [init description]
     * @param  p_event :Event        [description]
     * @return         [description]
     */
    private function init(p_event :Event) :Void 
    {
        // Draw background
        graphics.clear();
        graphics.beginFill(_bgColor);
        graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight * _relSize);
        graphics.endFill();

        // Create buttons
        if (_allBtn == null)
        {
            // All
            _allBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "All", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            addChild(_allBtn);

            // None
            _noneBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "None", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            addChild(_noneBtn);

            // Invert
            _invertBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "Invert", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            addChild(_invertBtn);

            // Ok
            _okBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight), 
                "OK", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            addChild(_okBtn);
        }
        
        // Create hint
        if (_hint == null)
        {
            var font :Font = Assets.getFont("fonts/OpenSans-Semibold.ttf");
            var textFormat :TextFormat = new TextFormat();
            textFormat.bold = true;
            textFormat.size = stage.stageHeight * 0.05;
            textFormat.font = font.fontName;
            textFormat.color = _fontColor;

            _hint = new TextField();
            _hint.embedFonts = true;
            _hint.selectable = false;
            _hint.mouseEnabled = false;
            _hint.defaultTextFormat = textFormat;
            _hint.text = "Downloading edition information";
            _hint.width = _hint.textWidth;
            _hint.height = _hint.textHeight;
            addChild(_hint);
        }
        _hint.x = stage.stageWidth / 2 - _hint.width / 2;
        _hint.y = height / 2 - _hint.height / 2;

        // Position buttons
        _allBtn.x = 0.85 * stage.stageWidth;
        _noneBtn.x = 0.85 * stage.stageWidth;
        _invertBtn.x = 0.85 * stage.stageWidth;
        _okBtn.x = 0.85 * stage.stageWidth;

        _allBtn.y = 0.05 * stage.stageHeight;
        _noneBtn.y = _allBtn.y + _allBtn.height + 0.05 * stage.stageHeight;
        _invertBtn.y = _noneBtn.y + _noneBtn.height + 0.05 * stage.stageHeight;
        _okBtn.y = height - 0.05 * stage.stageHeight - _okBtn.height;
    }

    /**
     * Download the site that holds the information about all editions.
     */
    public function go() :Void 
    {
        // var downloader :FileDownloader = new FileDownloader("file://C:/Coding/GitHubRepos/MTGDownloader/sitemap.html");
        var downloader :FileDownloader = new FileDownloader("http://magiccards.info/sitemap.html");
        downloader.addEventListener(FileDownloader.DOWNLOAD_DONE, handleDownloadDone);
        downloader.startDownload();
    }

    private function nthIndexOf(p_string :String, p_lookFor :String, p_n :Int) :Int 
    {
        var lastIndex :Int = 0;
        for (count in 0 ... p_n)
        {
            lastIndex = p_string.indexOf(p_lookFor, lastIndex + p_lookFor.length);
        }
        return lastIndex;
    }

    /**
     * Will parse the downloaded HTML file to get all editions.
     */
    private function handleDownloadDone(p_event :Event) :Void 
    {
        // Find all "a" inside the second table
        // We can't parse the whole site as it contains errors and freaks out any parser
        var downloader :FileDownloader = cast p_event.target;
        var data :String = downloader.getData();
        var bodyIndex :Int = nthIndexOf(data, "<table", 2);
        var bodyEndIndex: Int = nthIndexOf(data, "</table>", 2);
        var dataStripped :String = data.substr(bodyIndex, bodyEndIndex - bodyIndex + 8);
        var xml :HtmlDocument = new HtmlDocument(dataStripped);
        var finds :Array<HtmlNodeElement> = xml.find("a");

        // Trace each node with title and full link
        var title :String = "";
        var link :String = "";
        for (element in finds)
        {
            title = element.innerHTML;
            link = "http://magiccards.info" + element.getAttribute("href");
            trace(title + " : " + link);
        }
    }
}