/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{

    //@ngInject
    public static Factory($sce,$log,$hibachi,$filter){
        var data = null, serviceInvoked = false;
        
        function realFilter(value, currencyCode:string, decimalPlace:number = 2, returnStringFlag = true) {

            if( isNaN( parseFloat(value) )  ){
                return returnStringFlag ? "--" : undefined; 
            } 
            
            value = $filter('number')(value.toString(), decimalPlace);

            if(returnStringFlag){
                var currencySymbol = "$";
                if(data != null && data[currencyCode] != null ){
                    currencySymbol = data[currencyCode];
                } 
                else {
                     $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                }
                return currencySymbol + value; 
            }
            
            return value;
        }

        var filterStub: any = function(value, currencyCode:string, decimalPlace:number, returnStringFlag =true) {
            if( data == null && returnStringFlag) {

                if( !serviceInvoked ) {
                    serviceInvoked = true;
                    $hibachi.getCurrencies().then((currencies)=>{
                        data = currencies.data;
                    });
                }
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