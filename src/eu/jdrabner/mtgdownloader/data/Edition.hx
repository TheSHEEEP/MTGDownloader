
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
     * @return The short name of this edition.
     */
    public function getShortName() :String
    {
        return _shortName;
    }

    /**
     * @return The full name of this edition.
     */
    public function getFullName() :String 
    {
        return _fullName;
    }

    /**
     * @return The number of cards in this edition.
     */
    public function getNumberOfCards() :Int 
    {
        return _numCards;
    }

    public function getCards() :Array<Card>
    {
        return _cards;
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
     * Will read the number of cards from the passed HTML.
     * @param  p_html     The HTML source of this edition.
     */
    public function readCardsFromEditionHtml(p_html :String) :Void 
    {
        // TODO: here
        var bodyIndex :Int = nthIndexOf(p_html, "<table", 2);
        var bodyEndIndex: Int = nthIndexOf(p_html, "</table>", 2);
        var dataStripped :String = p_html.substr(bodyIndex, bodyEndIndex - bodyIndex + 8);
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

            // _container.addObject(checkbox);
        }
    }
}