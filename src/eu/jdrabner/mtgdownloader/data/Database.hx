
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

}