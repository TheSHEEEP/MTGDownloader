
package eu.jdrabner.mtgdownloader.data;

import flash.events.Event;
import haxe.htmlparser.HtmlDocument;
import haxe.htmlparser.HtmlNodeElement;

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
        // We can parse the full HTML, it does not seem to contain errors.
        var xml :HtmlDocument = new HtmlDocument(p_html);
        // The cards are in .even and .odd rows
        var rows :Array<HtmlNodeElement> = xml.find(".even, .odd");

        // Parse each row to get the link to the card
        var link :HtmlNodeElement = null;
        var card :Card = null;
        var index  :String = "";
        var getIndex :EReg = ~/[0-9]+[a-zA-Z]{0,1}/;
        for (element in rows)
        {
            link = element.find("a")[0];

            // Get the index
            getIndex.match(link.getAttribute("href"));
            index = getIndex.matched(0);

            // Create and add card
            card  = new Card(this, index, link.innerHTML);
            _cards.push(card);
        }
    }
}