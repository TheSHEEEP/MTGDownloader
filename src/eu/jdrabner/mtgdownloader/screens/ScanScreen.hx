
package eu.jdrabner.mtgdownloader.screens;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.net.URLRequest;
import flash.Lib;
import openfl.Assets;
import htmlparser.HtmlDocument;
import htmlparser.HtmlNodeElement;
import eu.jdrabner.ui.SVGTextButton;
import eu.jdrabner.ui.SVGCheckBox;
import eu.jdrabner.ui.ScrollableContainer;
import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;

class ScanScreen extends Sprite
{
    public static inline var     DONE :String = "Done!";

    private var _database     :Database;

    private var _bgColor         :Int;
    private var _fontColor       :Int;
    private var _fontHoverColor  :Int;
    private var _relSize         :Float;
    private var _font            :String;

    private var _hint       :TextField;
    private var _progress   :ProgressBar;
    private var _allBtn     :SVGTextButton;
    private var _noneBtn    :SVGTextButton;
    private var _invertBtn  :SVGTextButton;
    private var _okBtn      :SVGTextButton;

    private var _container     :ScrollableContainer;
    private var _checkBoxes    :Map<SVGCheckBox, Edition>;

    /**
     * Constructor.
     * @param  p_database  The database to fill.
     * @param  p_bgColor   The background color.
     * @param  p_fontColor The font color.
     * @param  p_fontHoverColor The font color when hovering.
     * @param  p_relSize   The relative height of the screen, relative to stage height (0 .. 1).
     * @param  p_font      The font to use.
     */
    public function new(p_database :Database, p_bgColor :Int, p_fontColor :Int, p_fontHoverColor :Int, p_relSize :Float, p_font :String)
    {
        super();

        // Remember values
        _database = p_database;
        _bgColor = p_bgColor;
        _fontColor = p_fontColor;
        _fontHoverColor = p_fontHoverColor;
        _relSize = p_relSize;
        _font = p_font;

        _checkBoxes = new Map<SVGCheckBox, Edition>();

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

        // Create UI elements
        if (_allBtn == null)
        {
            // All
            _allBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "All", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _allBtn.addEventListener(MouseEvent.CLICK, handleAllClick);
            addChild(_allBtn);

            // None
            _noneBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "None", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _noneBtn.addEventListener(MouseEvent.CLICK, handleNoneClick);
            addChild(_noneBtn);

            // Invert
            _invertBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "Invert", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _invertBtn.addEventListener(MouseEvent.CLICK, handleInvertClick);
            addChild(_invertBtn);

            // Ok
            _okBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "OK", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _okBtn.addEventListener(MouseEvent.CLICK, handleOkClick);
            addChild(_okBtn);

            // Scrollable container
            _container = new ScrollableContainer(0.84 * stage.stageWidth, stage.stageHeight * _relSize, 0.02, _fontColor, _fontHoverColor);
            addChild(_container);

            // Progress bar
            _progress = new ProgressBar(0.2 * stage.stageWidth, 0.05 * stage.stageHeight, _fontColor, 0x0000FF);
            addChild(_progress);
        }

        // Create hint
        if (_hint == null)
        {
            var font :Font = Assets.getFont("fonts/OpenSans-Semibold.ttf");
            var textFormat :TextFormat = new TextFormat();
            textFormat.bold = true;
            textFormat.size = Std.int(stage.stageHeight * 0.05);
            textFormat.font = font.fontName;
            textFormat.color = _fontColor;

            _hint = new TextField();
            _hint.embedFonts = true;
            _hint.selectable = false;
            _hint.mouseEnabled = false;
            _hint.defaultTextFormat = textFormat;
            _hint.text = "Downloading edition information...";
            _hint.width = _hint.textWidth;
            _hint.height = _hint.textHeight * 1.03;
            addChild(_hint);
        }
        _hint.x = 0.1 * stage.stageWidth;
        _hint.y = height / 2 - _hint.height / 2;
        _progress.x = _hint.x + 0.5 * (_hint.width - _progress.width);
        _progress.y = _hint.y + _hint.height;

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
        var downloader :FileDownloader = new FileDownloader("http://magiccards.info/sitemap.html", _progress);
        trace("test");
        //var downloader :FileDownloader = new FileDownloader("jksajklfs.dhsadfhj", _progress);
        downloader.addEventListener(FileDownloader.DOWNLOAD_DONE, handleDownloadDone);
        downloader.startDownload();
        trace("test 2");
    }

    /**
     * Returns the nth index of the passed string token.
     * @param  p_string  The string to look in.
     * @param  p_lookFor The token to look for.
     * @param  p_n       The n.
     * @return The nth index.
     */
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
        // Find all "a" inside the second table, which contains all editions
        // We can't parse the whole site as it contains errors and freaks out any parser
        var downloader :FileDownloader = cast p_event.target;
        var data :String = downloader.getData();
        var bodyIndex :Int = nthIndexOf(data, "<table", 2);
        var bodyEndIndex: Int = nthIndexOf(data, "</table>", 2);
        var dataStripped :String = data.substr(bodyIndex, bodyEndIndex - bodyIndex + 8);
        var xml :HtmlDocument = new HtmlDocument(dataStripped);
        var finds :Array<HtmlNodeElement> = xml.find("a");

        // Construct every edition and add it to the database
        // Also create a check box for it
        var title :String = "";
        var shorty :String = "/bng/en.html";
        var edition :Edition = null;
        for (element in finds)
        {
            // Get the title and the shorty
            title = element.innerHTML;
            shorty = element.getAttribute("href");
            shorty = shorty.substr(1, shorty.length - 1 - 8); // 8 is "/en.html"

            // Create the edition and add it to the database
            edition = new Edition(title, shorty);
            _database.addEdition(edition);

            // Construct a checkbox for the edition
            var checkbox :SVGCheckBox = new SVGCheckBox(Std.int(stage.stageWidth * 0.2), Std.int(stage.stageHeight * 0.04), 0.18,
                edition.getFullName(), _fontColor, _fontHoverColor, _font,
                "svg/cb_grey_un_normal", "svg/cb_grey_un_hover", "svg/cb_grey_normal", "svg/cb_grey_hover");
            checkbox.addEventListener(MouseEvent.CLICK, handleCheckBoxClicked);
            _checkBoxes[checkbox] = edition;
            _container.addObject(checkbox);
        }

        // Now that we have all editions, construct the check boxes
        _hint.visible = false;
        _progress.visible = false;
    }

    /**
     * Will take note of the edition to check/uncheck.
     */
    private function handleCheckBoxClicked(p_event :MouseEvent) :Void
    {
        // Get the checkbox
        var checkbox :SVGCheckBox = null;
        if (Std.is(p_event.target, SVGCheckBox))
        {
            checkbox = cast p_event.target;
        }
        else
        {
            checkbox = cast p_event.target.parent;
        }

        // Apply checked/unchecked
        _checkBoxes[checkbox].setShouldDownload(checkbox.getChecked());
    }

    /**
     * Will mark all editions to be downloaded.
     */
    private function handleAllClick(p_event :MouseEvent) :Void
    {
        for (cb in _checkBoxes.keys())
        {
            cb.setChecked(true);
            _checkBoxes[cb].setShouldDownload(true);
        }
    }

    /**
     * Will mark all editions NOT to be downloaded.
     */
    private function handleNoneClick(p_event :MouseEvent) :Void
    {
        for (cb in _checkBoxes.keys())
        {
            cb.setChecked(false);
            _checkBoxes[cb].setShouldDownload(false);
        }
    }

    /**
     * Will invert the selection of each edition.
     */
    private function handleInvertClick(p_event :MouseEvent) :Void
    {
        for (cb in _checkBoxes.keys())
        {
            cb.setChecked(!_checkBoxes[cb].getShouldDownload());
            _checkBoxes[cb].setShouldDownload(!_checkBoxes[cb].getShouldDownload());
        }
    }

    /**
     * Will continue to the next step.
     */
    private function handleOkClick(p_event :MouseEvent) :Void
    {
        // Only proceed if any edition is selected
        for (edition in _checkBoxes)
        {
            if (edition.getShouldDownload())
            {
                dispatchEvent(new Event(DONE));
                return;
            }
        }
    }
}
