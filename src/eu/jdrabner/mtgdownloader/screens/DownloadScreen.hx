
package eu.jdrabner.mtgdownloader.screens;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.net.URLRequest;
import flash.Lib;
import flash.utils.Timer;
import flash.utils.ByteArray;
import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;
import openfl.Assets;
import htmlparser.HtmlDocument;
import htmlparser.HtmlNodeElement;
import eu.jdrabner.ui.SVGTextButton;
import eu.jdrabner.ui.SVGCheckBox;
import eu.jdrabner.ui.ScrollableContainer;
import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.ui.RGBColor;
import eu.jdrabner.mtgdownloader.download.FileDownloader;
import eu.jdrabner.mtgdownloader.download.DownloadJob;
import eu.jdrabner.mtgdownloader.download.DownloadSettings;
import eu.jdrabner.mtgdownloader.download.DownloadDisplay;
import eu.jdrabner.mtgdownloader.data.Database;
import eu.jdrabner.mtgdownloader.data.Edition;
import eu.jdrabner.mtgdownloader.data.Card;

/**
 * This screen is responsible for all the downloads.
 */
class DownloadScreen extends Sprite
{
    public static inline var     DONE :String = "Done!";
    public static inline var     BACK :String = "Back!";

    private var _database     :Database;

    private var _bgColor         :Int;
    private var _fontColor       :Int;
    private var _fontHoverColor  :Int;
    private var _relSize         :Float;
    private var _font            :String;

    private var _numEditionsTotal :Int = 0;
    private var _numEditionsDL    :Int = 0;
    private var _numCardsTotal    :Int = 0;
    private var _numCardsDL       :Int = 0;
    private var _editionsProgress :TextField;
    private var _cardsProgress    :TextField;
    private var _container        :ScrollableContainer;

    private var _displays             :Array<DownloadDisplay>;
    private var _waitingDownloads     :Array<Dynamic>;

    private var _backBtn          :SVGTextButton;

    private var _errordCards    :Array<Card>;

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

        _displays = new Array<DownloadDisplay>();
        _waitingDownloads = new Array<Dynamic>();
        _errordCards = new Array<Card>();

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
        if (_editionsProgress == null)
        {
            // Create text format to use
            var font :Font = Assets.getFont(_font);
            var textFormat :TextFormat = new TextFormat();
            textFormat.bold = true;
            textFormat.size = Std.int(stage.stageHeight * _relSize * 0.03);
            textFormat.font = font.fontName;
            textFormat.color = _fontColor;

            // Editions progress
            _editionsProgress = new TextField();
            _editionsProgress.embedFonts = true;
            _editionsProgress.selectable = false;
            _editionsProgress.mouseEnabled = false;
            _editionsProgress.defaultTextFormat = textFormat;
            _editionsProgress.text = "Edition progress: 0 / 0";
            _editionsProgress.width = _editionsProgress.textWidth * 1.03;
            _editionsProgress.height = _editionsProgress.textHeight * 1.03;
            addChild(_editionsProgress);

            // Cards progress
            _cardsProgress = new TextField();
            _cardsProgress.embedFonts = true;
            _cardsProgress.selectable = false;
            _cardsProgress.mouseEnabled = false;
            _cardsProgress.defaultTextFormat = textFormat;
            _cardsProgress.text = "Cards progress: 0 / 0";
            _cardsProgress.width = _cardsProgress.textWidth * 1.03;
            _cardsProgress.height = _cardsProgress.textHeight * 1.03;
            addChild(_cardsProgress);

            // Back
            _backBtn = new SVGTextButton(Std.int(0.1 * stage.stageWidth), Std.int(0.1 * stage.stageHeight),
                "Back", _fontColor, _font,
                "svg/btn_grey_normal", "svg/btn_grey_click", "svg/btn_grey_hover");
            _backBtn.addEventListener(MouseEvent.CLICK, handleBackClick);
            addChild(_backBtn);

            // Scrollable container
            _container = new ScrollableContainer(0.84 * stage.stageWidth, stage.stageHeight * _relSize * 0.8, 0.02,
                                                _fontColor, _fontHoverColor);
            addChild(_container);

            // Create a timer that lets the screen check regularly for pending downloads
            var timer:Timer = new Timer(100, 0);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, checkPendingDownloads);
            timer.start();
        }

        // Position UI elements
        _editionsProgress.x = 0.03 * stage.stageWidth;
        _cardsProgress.x = 0.03 * stage.stageWidth;

        _editionsProgress.y = 0.03 * stage.stageHeight;
        _cardsProgress.y = _editionsProgress.y + _editionsProgress.height + 0.03 * stage.stageHeight;
        _container.y = _cardsProgress.y + _cardsProgress.height + 0.03 * stage.stageHeight;

        // Position buttons
        _backBtn.x = 0.85 * stage.stageWidth;
        _backBtn.y = height - 0.05 * stage.stageHeight - _backBtn.height;
    }

    /**
     * Start downloading all editions.
     */
    public function go() :Void
    {
        // First, start downloading all editions
        var editions :Array<Edition> = _database.getEditionsToDownload();
        _numEditionsTotal = editions.length;
        updateProgressDisplay();

        for (edition in editions)
        {
            createDownloadFolder(edition);
            addDownload(edition);
        }
    }

    /**
     * Updates the display of the download progress.
     */
    private function updateProgressDisplay() :Void
    {
        _editionsProgress.text = "Edition progress: " + _numEditionsDL + " / " + _numEditionsTotal;
        _editionsProgress.width = _editionsProgress.textWidth * 1.03;
        _editionsProgress.height = _editionsProgress.textHeight * 1.03;
        _cardsProgress.text = "Cards progress: " + _numCardsDL + " / " + _numCardsTotal;
        _cardsProgress.width = _cardsProgress.textWidth * 1.03;
        _cardsProgress.height = _cardsProgress.textHeight * 1.03;
    }

    /**
     * Will create the download folder for the passed edition.
     * @param  p_edition  The edition to get the short name from.
     */
    private function createDownloadFolder(p_edition :Edition) :Void
    {
        // Get the full path
        var fullPath :String = DownloadSettings.targetFolder + "/" + p_edition.getShortName();
        fullPath = StringTools.replace(fullPath, "\\", "/");
        fullPath = StringTools.replace(fullPath, "//", "/");

        // This function should create complete path, recursively
        FileSystem.createDirectory(fullPath);
        return;

        // Split into tokens
        var tokens :Array<String> = fullPath.split("/");

        // On Windows, the first two tokens must be combined
        // "C:" + "folder" -> C:/folder
        #if windows
            if (tokens.length > 1)
            {
                tokens[0] += "/" + tokens[1];
                tokens.splice(1, 1);
            }
        #end

        // Now create each token directory
        var currentPath :String = "";
        for (token in tokens)
        {
            currentPath += token;

            FileSystem.createDirectory(currentPath);

            currentPath += "/";
        }
    }

    /**
     * Will add a download.
     * @param p_edition The Edition or Card to download.
     * @return  True if the download was not only added, but also started.
     */
    private function addDownload(p_source :Dynamic) :Bool
    {
        // Create download job
        var job :DownloadJob = new DownloadJob(p_source);
        job.addEventListener(DownloadJob.DONE, handleJobDone);
        job.addEventListener(DownloadJob.ERROR, handleJobError);

        // Try recycling an existing display
        for (display in _displays)
        {
            // Re-use an idle display
            if (display.getIsIdle())
            {
                display.setDownloadJob(job);
                display.setIsIdle(false);
                job.start();
                return true;
            }
        }

        // Try creating a new display
        if (_container.getNumObjects() <= DownloadSettings.numParallelDownloads)
        {
            // Create download display
            var color :RGBColor = new RGBColor(_fontColor);
            color.subtract(0xAA22AA);
            var display :DownloadDisplay =
                new DownloadDisplay(0.2 * stage.stageWidth, 0.05 * stage.stageHeight, _font, _fontColor, color.toInt(), job);

            // Add it
            _container.addObject(display);
            _displays.push(display);
            display.setIsIdle(false);
            job.start();
            return true;
        }
        else
        {
            // Add this job to the waiting queue
            _waitingDownloads.push(p_source);
            return false;
        }

        return false;
    }

    /**
     * Will handle completed downloads of an edition or a card.
     */
    private function handleJobDone(p_event :Event) :Void
    {
        var job :DownloadJob = cast p_event.target;
        job.removeEventListener(DownloadJob.DONE, handleJobDone);
        job.removeEventListener(DownloadJob.ERROR, handleJobError);

        // If this was an edition, parse the HTML
        if (Std.is(job.getSource(), Edition))
        {
            // Let the edition read the HTML
            var edition :Edition = cast job.getSource();
            edition.readCardsFromEditionHtml(job.getData());
            _numEditionsDL++;

            // Start a download for each card
            var cards :Array<Card> = edition.getCards();
            _numCardsTotal += cards.length;
            for (card in cards)
            {
                addDownload(card);
            }
        }
        // Otherwise, store the card
        else
        {
            var card :Card = cast job.getSource();
            storeCard(card, job.getData());
            _numCardsDL++;
        }
        updateProgressDisplay();

        // If we have waiting downloads, add those
        while (_waitingDownloads.length > 0)
        {
            var source :Dynamic = _waitingDownloads[0];
            _waitingDownloads.splice(0, 1);
            if (!addDownload(source))
            {
                break;
            }
        }

        // Are we done?
        if (_numCardsDL >= _numCardsTotal && _numEditionsDL >= _numEditionsTotal)
        {
            trace("We are done!");
            trace("Leftovers: " + _errordCards.length);
        }
    }

    /**
     * Will handle error'd downloads of an edition or a card.
     */
    private function handleJobError(p_event :Event) :Void
    {
        var job :DownloadJob = cast p_event.target;
        job.removeEventListener(DownloadJob.DONE, handleJobDone);
        job.removeEventListener(DownloadJob.ERROR, handleJobError);

        // So far, errors only happened for cards (and only on linux)
        if (Std.is(job.getSource(), Card))
        {
            var card :Card = cast job.getSource();
            trace("Adding card to error'd ones: " + card.getFullName());
            _errordCards.push(card);
        }

        updateProgressDisplay();

        // If we have waiting downloads, add those
        while (_waitingDownloads.length > 0)
        {
            var source :Dynamic = _waitingDownloads[0];
            _waitingDownloads.splice(0, 1);
            if (!addDownload(source))
            {
                break;
            }
        }
    }

    /**
     * Will store the downloaded card to a file.
     * @param  p_card The card to store.
     * @param  p_data The actual image data.
     */
    private function storeCard(p_card :Card, p_data :Dynamic) :Void
    {
        // Get folder path
        var fullPath :String = DownloadSettings.targetFolder + "/" + p_card.getEdition().getShortName() + "/";
        fullPath = StringTools.replace(fullPath, "\\", "/");
        fullPath = StringTools.replace(fullPath, "//", "/");

        // Get the card name
        var cardName :String = p_card.getFullName();
        if (DownloadSettings.toLower)
        {
            cardName = cardName.toLowerCase();
        }
        else if (DownloadSettings.toUpper)
        {
            cardName = cardName.toUpperCase();
        }
        // Some cards have a "/" in the name - must replace that with something non-path-related
        cardName = StringTools.replace(cardName, "/", "_");
        // We need to replace the Æ with something everyone can read
        cardName = StringTools.replace(cardName, "Æ", "AE");
        // Some cards have "" in their name - can't do that with files
        cardName = StringTools.replace(cardName, "\"", "");
        // Some cards have ? in their name - can't do that with files
        cardName = StringTools.replace(cardName, "?", "");


        fullPath += DownloadSettings.prefix + cardName + DownloadSettings.postfix + ".jpg";

        // Create file object
        var file :FileOutput = null;
        try {
            file = File.write(fullPath, true);
        } catch( error : Dynamic ) {
            trace("Error : " + error);
            trace("Will try again after done with the rest.");
            _errordCards.push(p_card);
            return;
        }

        // Store image bytes
        var bytes :ByteArray = cast p_data;
        bytes.position = 0;
        file.writeBytes(bytes, 0, bytes.bytesAvailable);
        file.close();
    }

    /**
     * Will go back to the last step.
     */
    private function handleBackClick(p_event :MouseEvent) :Void
    {
        dispatchEvent(new Event(BACK));
    }

    /**
     * Will check for pending downloads.
     */
    private function checkPendingDownloads(p_event :TimerEvent) :Void
    {
        // If we have waiting downloads, add those
        while (_waitingDownloads.length > 0)
        {
            var source :Dynamic = _waitingDownloads[0];
            _waitingDownloads.splice(0, 1);
            if (!addDownload(source))
            {
                break;
            }
        }
    }
}
