//Den här klassen håller bara status för hur mycket pengar som finns, kan öka och minska det värdet 

class CoinsState {
    int _coinValue = 0;

    void increaseCoinValue(int addedValue) {
        _coinValue = _coinValue + addedValue;
    } 

    void decreaseCoinValue(int deletedValue) {
         _coinValue = _coinValue - deletedValue;
    } 
 
    int getCoinValue(){
        return _coinValue; 
    }

}