/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{

    //@ngInject
    public static Factory($sce,$log,$hibachi,$filter){
        var data = null, serviceInvoked = false;
        
        function realFilter(value, currencyCode:string, decimalPlace:number = 2, returnStringFlag = true) {
            console.log('lineeeeeee 12', value)
  
            if( isNaN( parseFloat(value) )  ){
                console.log('returning')
                return returnStringFlag ? "--" : undefined; 
            } 
            if(value == '')
            value = $filter('number')(value.toString(), decimalPlace);
            console.log('line 18 value', value);
       
            if(returnStringFlag){
                var currencySymbol = "$";
                if(data != null && data[currencyCode] != null ){
                    currencySymbol = data[currencyCode];
                } 
                else {
                     $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                }
                console.log('line 27 value', value)
                return currencySymbol + value; 
            }
            
            return value;
        }

        var filterStub: any = function(value, currencyCode:string, decimalPlace:number, returnStringFlag =true) {
            console.log(' =======entry point ==============!', value)
           
            if( data == null && returnStringFlag) {

                if( !serviceInvoked ) {
                    serviceInvoked = true;
                    $hibachi.getCurrencies().then((currencies)=>{
                        data = currencies.data;
                    });
                }
                console.log('line 47', value)
                return  "--" + value;
            }
            else {
                return realFilter(value,currencyCode,decimalPlace,returnStringFlag);
            }
        }
        
        filterStub.$stateful = true;

        return filterStub;
    }

}
export {SWCurrency};