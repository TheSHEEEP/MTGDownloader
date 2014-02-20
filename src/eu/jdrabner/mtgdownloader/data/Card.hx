
package eu.jdrabner.mtgdownloader.data;

class Card 
{
    private var _edition      :Edition;
    private var _index        :String = "";
    private var _fullName     :String = "";

    /**
     * Constructor.
     * @param  p_edition The edition this card belongs to.
     * @param  p_index   The index of this card inside the edition.
     * @param  p_name    The name of this card.
     */
    public function new(p_edition :Edition, p_index :String, p_name :String)
    {
        _edition = p_edition;
        _index = p_index;
        _fullName = p_name;
    } 

    /**
     * @return The edition this card belongs to.
     */
    public function getEdition() :Edition
    {
        return _edition;
    }
    
    /**
     * @return The index of this card inside the edition.
     */
    public function getIndex() :String 
    {
        return _index;
    }

    /**
     * @return The full name of this card.
     */
    public function getFullName() :String
    {
        return _fullName;
    }

}