/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{
   
    //@ngInject
    public static Factory($sce,$log,$hibachi){
        var data = null, serviceInvoked = false;
        function realFilter(value,decimalPlace,returnStringFlag=true) {
            // REAL FILTER LOGIC, DISREGARDING PROMISES
            if(!angular.isDefined(data)){
                $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                data="$";
            }
            if(angular.isDefined(value)){
                if(angular.isDefined(decimalPlace)){
                    value = parseFloat(value.toString()).toFixed(decimalPlace)
                } else {
                    value = parseFloat(value.toString()).toFixed(2)
                }
            }
            if(returnStringFlag){
                return data + value;
            } else { 
                return value;
            }   
        }

        var filterStub:any;
        filterStub = function(value,currencyCode,decimalPlace,returnStringFlag=true) {

            if( data === null && returnStringFlag) {
                if( !serviceInvoked ) {
                    serviceInvoked = true;
                        $hibachi.getCurrencies().then((currencies)=>{
                        var result = currencies.data;
                        data = result[currencyCode];
                    });
                }
                return "-";
            }
            else return realFilter(value,decimalPlace,returnStringFlag);
        }

        filterStub.$stateful = true;

        return filterStub;
    }


}
export {SWCurrency};
