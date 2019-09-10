/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{

    //@ngInject
    public static Factory($sce,$log,$hibachi,$filter){
        var data = null, serviceInvoked = false;
        
        function realFilter(value,currencyCode,decimalPlace,returnStringFlag=true) {

            // REAL FILTER LOGIC, DISREGARDING PROMISES
            var currencySymbol = "$";
            if(data != null &&
               data[currencyCode] != null
            ){
                currencySymbol=data[currencyCode];
            } else {
                 $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
            }
            
            if(!value || value.toString().trim() == ''){
                value = 0;
            }
            
            if(angular.isDefined(value) && angular.isDefined(decimalPlace)){
                value = $filter('number')(value.toString(), decimalPlace);
            } else {
                value = $filter('number')(value.toString(), 2);
            }
        
            if(returnStringFlag){
                return currencySymbol + value;
            } else { 
                return value;
            }   
        }

        var filterStub:any;
        filterStub = function(value,currencyCode,decimalPlace,returnStringFlag=true) {
            if( data == null && returnStringFlag) {
                if( !serviceInvoked ) {
                    serviceInvoked = true;
                    $hibachi.getCurrencies().then((currencies)=>{
                        data = currencies.data;
                    });
                }
                return "-";
            }
            else return realFilter(value,currencyCode,decimalPlace,returnStringFlag);
        }

        filterStub.$stateful = true;

        return filterStub;
    }


}
export {SWCurrency};