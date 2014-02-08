
package eu.jdrabner.mtgdownloader.data;

import flash.events.Event;

class Edition extends flash.events.EventDispatcher
{
    private var _fullName     :String = "None";
    private var _shortName    :String = "None";

    private var _numCards  :Int = 0; 
    private var _cards     :Array<Card>;

    private var _download     :Bool = false;

    /**
     * Constructor.
     * @param  p_fullName  The full name (e.g. "Magic 2014")
     * @param  p_shortName The short name (e.g. "M14")
     */
    public function new(p_fullName : String, p_shortName :String)
    {
        super();

        _fullName = p_fullName;
        _shortName = p_shortName;

        _cards = new Array<Card>();
    }

    /**
     * @return The full name of this edition.
     */
    public function getFullName() :String 
    {
        return _fullName;
    }

    /**
     * @param p_download if this is true, the edition will be downloaded.
     */
    public function setShouldDownload(p_download :Bool) :Void 
    {
        _download = p_download;
    }

    /**
     * @return true if this edition should download.
     */
    public function getShouldDownload() :Bool
    {
        return _download;
    }
}