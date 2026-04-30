//Den här klassen håller bara status för hur mycket pengar som finns, kan öka och minska det värdet 

class CoinsState {
    int _counter = 0;

    void increaseCounter(int value) {
        _counter = _counter + value;
    } 

    void decreaseCounter(int value) {
         _counter = _counter - value;
    } 
 
    int getCounterValue(){
        return _counter; 
    }

}