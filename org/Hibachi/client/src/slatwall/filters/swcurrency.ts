/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{
    // public $slatwall;
    // public realFilter = (value,decimalPlace):string=> {
    //     // REAL FILTER LOGIC, DISREGARDING PROMISES
    //     if(!angular.isDefined(data)){
    //         $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
    //         data="$";
    //     }
    //     if(angular.isDefined(value)){
    //         if(angular.isDefined(decimalPlace)){
    //             value = parseFloat(value.toString()).toFixed(decimalPlace) 
    //         } else { 
    //             value = parseFloat(value.toString()).toFixed(2)
    //         }
    //     }
    //     return data + value;
    // }
    
    // public filterStub = (value:string, currencyCode:string, decimalPlace:number)=> {
    //     if( data === null ) {
    //         if( !serviceInvoked ) {
    //             serviceInvoked = true;
    //                 $slatwall.getCurrencies().then((currencies)=>{
    //                 var result = currencies.data;
    //                 data = result[currencyCode];
    //             });
    //         }
    //         return "-";
    //     }
    //     else 
    //     return realFilter(value,decimalPlace);
    // }
    
    //@ngInject
   
    
     public static Factory($sce,$log,$slatwall){
        // var data = null, serviceInvoked = false;
        
        // var filterStub = this.filterStub;
        // filterStub.$stateful = true;
        
        
        // return filterStub;  
        return (value:string, currencyCode:string, decimalPlace:number)=>{
            
            var data = null, serviceInvoked = false;
            function realFilter(value,decimalPlace) {
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
                return data + value;
            }
            
            
            function filterStub(value,currencyCode,decimalPlace) {
                this.$stateful = true;
                if( data === null ) {
                    if( !serviceInvoked ) {
                        serviceInvoked = true;
                         $slatwall.getCurrencies().then((currencies)=>{
                            var result = currencies.data;
                            data = result[currencyCode];
                        });
                    }
                    return "-";
                }
                else return realFilter(value,decimalPlace);
            }
            
            return filterStub;  
        }
    }
    
  
}
export {SWCurrency};