/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWTrim{
    //@ngInject
    public static Factory(rbkeyService){
        return (text:string, max, wordwise=true, tail="...")=>{
            if(angular.isDefined(text) && angular.isString(text)){
               if (!text) return '';

                max = parseInt(max, 10);
                if (!max) return text;
                if (text.length <= max) return text;

                text = text.substr(0, max);
                if (wordwise) {
                    var lastSpace = text.lastIndexOf(' ');
                    if (lastSpace != -1) {
                        text = text.substr(0, lastSpace);
                    }
                }

                return text + tail;
            }
            return text;
        }
    }
    
}
export {
    SWTrim
};