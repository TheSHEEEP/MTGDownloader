
package eu.jdrabner.mtgdownloader.download;

import flash.events.EventDispatcher;
import flash.events.Event;
import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.mtgdownloader.data.Card;
import eu.jdrabner.mtgdownloader.data.Edition;

/**
 * This class manages one download job, including the whole download and file creation.
 */
class DownloadJob extends EventDispatcher
{
    public static inline var     DONE :String = "Done!";

    private var _isCard       :Bool = false;
    private var _card         :Card;
    private var _edition      :Edition;

    private var _downloader      :FileDownloader;
    private var _progressBar     :ProgressBar;


    /**
     * Constructor.
     * @param  p_source The source of the download. May be a Card or an Edition.
     * @param  p_bar    The progress bar to use. May be null to be set later.
     */
    public function new(p_source :Dynamic, p_bar :ProgressBar = null)
    {
        super();

        // Remember source
        if (Std.is(p_source, Card))
        {
            _isCard = true;
            _card = cast p_source;
        }
        else if (Std.is(p_source, Edition))
        {
            _isCard = false;
            _edition = cast p_source;
        }
        else
        {
            trace("Passed source is neither a card nor an edition: " + p_source);
        }

        // Set progress bar
        setProgressBar(p_bar);

        // Initialize the downloader
        var url :String = "http://magiccards.info/";
        if (_isCard)
        {
            url += "scans/en/";
            url += _card.getEdition().getShortName();
            url += "/" + _card.getIndex() + ".jpg";
        }
        else
        {
            url += _edition.getShortName();
            url += "/en.html";
        }
        _downloader = new FileDownloader(url, _progressBar);
        _downloader.addEventListener(FileDownloader.DOWNLOAD_DONE, handleDownloadDone);
    }

    /**
     * Will start the download.
     */
    public function start() :Void
    {
        _downloader.startDownload();
    }

    /**
     * @return The full description of the job, to be displayed to the user.
     */
    public function getFullDescription() :String
    {
        if (_isCard)
        {
            return "Card: " + _card.getEdition().getShortName() + ": " + _card.getFullName();
        }
        else
        {
            return "Edition:   " + _edition.getFullName();
        }
    }

    /**
     * @param p_bar The ProgressBar to use.
     */
    public function setProgressBar(p_bar :ProgressBar) :Void
    {
        if (p_bar != null && _progressBar == null)
        {
            _progressBar = p_bar;
            _progressBar.update(0.0);
            _downloader.setProgressBar(_progressBar);
        }
    }

    /**
     * @return The source of the download. Either an Edition or a Card.
     */
    public function getSource() :Dynamic
    {
        if (_isCard)
        {
            return _card;
        }
        else
        {
            return _edition;
        }
        return null;
    }

    /**
     * @return The data of the download.
     */
    public function getData() :Dynamic
    {
        return _downloader.getData();
    }

    /**
     * Will notify all listeners of the finished download.
     */
    private function handleDownloadDone(p_event :Event) :Void
    {
        dispatchEvent(new Event(DONE));
    }
}
