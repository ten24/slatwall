/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{
   
    //@ngInject
    public static Factory($sce,$log,$hibachi,$filter){
        var data = null, serviceInvoked = false;
        function realFilter(value,decimalPlace,returnStringFlag=true) {
            // REAL FILTER LOGIC, DISREGARDING PROMISES
            if(!angular.isDefined(data)){
                $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                data="$";
            }
            if(!value || value.toString().trim() == ''){
                value = 0;
            }
            if(angular.isDefined(value)){
                if(angular.isDefined(decimalPlace)){
                    value = $filter('number')(value.toString(), decimalPlace);
                } else {
                    value = $filter('number')(value.toString(), 2);
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
