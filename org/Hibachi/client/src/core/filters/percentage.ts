/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class PercentageFilter{

    public static Factory(){
        return (input, decimals, suffix)=> {
            decimals = angular.isNumber(decimals)? decimals :  3;
            suffix = suffix || '%';
            if (isNaN(input)) {
                return '';
            }
            return Math.round(input * Math.pow(10, decimals + 2))/Math.pow(10, decimals) + suffix;
        };
    }

}
export {PercentageFilter};