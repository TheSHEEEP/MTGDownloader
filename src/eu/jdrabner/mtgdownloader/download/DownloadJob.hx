
package eu.jdrabner.mtgdownloader.download;

import eu.jdrabner.ui.ProgressBar;
import eu.jdrabner.mtgdownloader.data.Card;
import eu.jdrabner.mtgdownloader.data.Edition;

/**
 * This class manages one download job, including the whole download and file creation.
 */
class DownloadJob 
{
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
    }

    /**
     * @return The full description of the job, to be displayed to the user.
     */
    public function getFullDescription() :String
    {
        return "Hello".
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
        }
    }
}