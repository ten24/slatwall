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


import { ChangeDetectorRef, OnDestroy, Pipe, PipeTransform, WrappedValue } from '@angular/core';
import { $Hibachi } from '../../../../../org/Hibachi/client/src/core/services/hibachiservice';
import { CurrencyService } from '../../../../../org/Hibachi/client/src/core/services/currencyservice';

@Pipe({name: 'swcurrency', pure: false})
export class SwCurrency implements PipeTransform {
        
    private value: any = '-';
    private data = null;
    private currentValue: any;
    private currentCurrencyCode: string;
    private currentDecimalPlace: any;
    
    constructor( 
        private $hibachi: $Hibachi, 
        private currencyService: CurrencyService,
        private changeDetectorRef: ChangeDetectorRef) {
        
    }
    

    transform(value, currencyCode, decimalPlace, returnStringFlag=true): any {
        if(
            this.currentValue === value && 
            this.currentCurrencyCode === currencyCode &&
            this.currentDecimalPlace === decimalPlace ) {
            return this.value;    
        } else {
            this.currentValue = value;
            this.currentCurrencyCode = currencyCode;
            this.currentDecimalPlace = decimalPlace;    
        }
        if( this.currencyService.hasCurrencySymbols() ) {
            this.data = this.currencyService.getCurrencySymbol(currencyCode);
            return this.realFilter(value, decimalPlace,this.data, returnStringFlag);
        } else  {
          this.currencyService.getCurrencySymbolsPromise().then((currencies) => {
            let currencySymbols = currencies.data;
            this.currencyService.setCurrencySymbols(currencySymbols);  
            this.data = this.currencyService.getCurrencySymbol(currencyCode);
            this.value = this.realFilter(value, decimalPlace,this.data, returnStringFlag);  
            this.changeDetectorRef.markForCheck(); 
          });   
          if(this.data !== null) {
            this.changeDetectorRef.detach();    
          } 
          return WrappedValue.wrap(this.value);
        }
    }

    realFilter(value,decimalPlace,data,returnStringFlag=true) {
        // REAL FILTER LOGIC, DISREGARDING PROMISES
        if(!angular.isDefined(data)){
            data="$";
        }
        if(!value || value.toString().trim() == ''){
            value = 0;
        }
        if(angular.isDefined(value)){
            if(angular.isDefined(decimalPlace)){
                //value = $filter('number')(value.toString(), decimalPlace);
                value = parseFloat(value).toFixed(decimalPlace);
            } else {
                //value = $filter('number')(value.toString(), 2);
                value = parseFloat(value).toFixed(2);
            }
        }
        if(returnStringFlag){
            return data + value;
        } else { 
            return value;
        }   
    }
}