/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWCurrency{

    //@ngInject
    public static Factory($sce,$log,$hibachi,$filter){
        var data = null, serviceInvoked = false,locale='en-us';
        
        function realFilter(value, currencyCode:string, decimalPlace:number = 2, returnStringFlag = true,localeOverride?) {
            let useLocale = locale;
            if(localeOverride){
                useLocale = localeOverride
            }
            if( isNaN( parseFloat(value) )  ){
                return returnStringFlag ? "--" : undefined; 
            } 
            if(typeof value == 'string'){
                //if the value is a string remove any commas and spaces
                value = value.replace(/[, ]+/g, "").trim();
            }
   
            try{
                let newValue = parseFloat(value).toLocaleString(useLocale,{minimumFractionDigits:2,maximumFractionDigits:2});
                value = newValue;
            }catch(e){
            }

            if(returnStringFlag){
                var currencySymbol = "$";
                if(data != null && data[currencyCode] != null ){
                    currencySymbol = data[currencyCode].currencySymbol;
                }
                else {
                     $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                }
                if(data != null && data[currencyCode] != null && data[currencyCode].formatMask != null && data[currencyCode].formatMask.trim().length){
                    let formatMask = data[currencyCode].formatMask;
                    return formatMask.replace('$',currencySymbol).replace(/ /g,'\u00a0').replace('{9}',value);
                }else{
                    return currencySymbol + value; 
                }
            }
            //if they don't want a string returned, again make sure any commas and spaces are removed
            if(typeof value == 'string'){
                value = value.replace(/[, ]+/g, "").trim();
            }
            
            return value;
        }

        var filterStub: any = function(value, currencyCode:string, decimalPlace:number, returnStringFlag =true,localeOverride) {
            if( data == null && returnStringFlag) {
                if( !serviceInvoked ) {
                    serviceInvoked = true;
                    $hibachi.getCurrencies().then((currencies)=>{
                        data = currencies.data;
                        locale = $hibachi.getConfig().rbLocale.replace('_','-');
                    });
                }
                return  "--" + value;
            }
            else {
                return realFilter(value,currencyCode,decimalPlace,returnStringFlag,localeOverride);
            }
        }
        
        filterStub.$stateful = true;

        return filterStub;
    }

}
export {SWCurrency};