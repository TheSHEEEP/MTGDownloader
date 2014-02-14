
package eu.jdrabner.mtgdownloader.data;

import flash.events.Event;

/**
 * This is the database that holds all editions.
 */
class Database extends flash.events.EventDispatcher
{
    private var _editions     :Array<Edition>;

    /**
     * Constructor.
     */
    public function new()
    {
        super();
        
        _editions = new Array<Edition>();
    }

    /**
     * @param p_edition The edition to add.
     */
    public function addEdition(p_edition :Edition) :Void 
    {
        _editions.push(p_edition);
    }

    /**
     * Will look through all editions and return those that should be downloaded.
     * @return The editions to download.
     */
    public function getEditionsToDownload() :Array<Edition>
    {
        var result :Array<Edition> = new Array<Edition>();
        for (edition in _editions)
        {
            if (edition.getShouldDownload())
            {
                result.push(edition);
            }
        }
        return result;
    }

}