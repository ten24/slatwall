/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
import {BaseService} from "./baseservice";
class UtilityService extends BaseService{

    constructor(){
        super();

    }
    //used to do inheritance at runtime
    public extend = (ChildClass, ParentClass)=> {
        ChildClass.prototype = new ParentClass();
        ChildClass.prototype.constructor = ChildClass;
    }

    public getQueryParamsFromUrl = (url) =>{
      // This function is anonymous, is executed immediately and
      // the return value is assigned to QueryString!
      var query_string = {};
      if(url && url.split){
          var spliturl = url.split('?');
          if(spliturl.length){
              url = spliturl[1];
              if(url && url.split){
                  var vars = url.split("&");
                  if(vars && vars.length){
                      for (var i=0;i<vars.length;i++) {
                        var pair = vars[i].split("=");
                            // If first entry with this name
                        if (typeof query_string[pair[0]] === "undefined") {
                          query_string[pair[0]] = pair[1];
                            // If second entry with this name
                        } else if (typeof query_string[pair[0]] === "string") {
                          var arr = [ query_string[pair[0]], pair[1] ];
                          query_string[pair[0]] = arr;
                            // If third or later entry with this name
                        } else {
                          query_string[pair[0]].push(pair[1]);
                        }
                      }
                  }
              }
          }

        }
        return query_string;
    };

    public isAngularRoute = () =>{
        return /[\?&]ng#!/.test(window.location.href);
    };

    public ArrayFindByPropertyValue = (arr:any[],property:string,value:any):number =>{
        let currentIndex = -1;
        arr.forEach((arrItem,index)=>{
           if(arrItem[property] && arrItem[property] === value){
               currentIndex = index;
           }
        });
        return currentIndex;
    };

    public listLast = (list:string='',delimiter:string=','):string =>{

        var listArray = list.split(delimiter);

		return listArray[listArray.length-1];
    };

    public listRest = (list:string='',delimiter:string=","):string =>{
        var listArray = list.split(delimiter);
        if(listArray.length){
            listArray.splice(0,1);
        }
        return listArray.join(delimiter);
    };

    public listFirst = (list:string='',delimiter:string=','):string =>{

        var listArray = list.split(delimiter);

        return listArray[0];
    };

    public listPrepend = (list: string = '', substring: string = '', delimiter: string = ','): string => {

        var listArray = list.split(delimiter);
        if(listArray.length){
            return substring + delimiter + list;
        }else{
            return substring
        }
    };

    public listAppend = (list: string = '', substring: string = '', delimiter: string = ','): string => {
        var listArray = list.split(delimiter);
        if (list.trim() != '' && listArray.length) {
            return list + delimiter + substring;
        }else{
            return substring
        }
    };

    public listAppendUnique = (list: string = '', substring: string = '', delimiter: string = ','): string => {
        var listArray = list.split(delimiter);
        if (list.trim() != '' && listArray.length && listArray.indexOf(substring) == -1) {
            return list + delimiter + substring;
        } else {
            return substring
    }
    };


    public formatValue=(value,formatType,formatDetails,entityInstance)=>{
        if(angular.isUndefined(formatDetails)){
            formatDetails = {};
        }
        var typeList = ["currency","date","datetime","pixels","percentage","second","time","truefalse","url","weight","yesno"];

        if(typeList.indexOf(formatType)){
            this['format_'+formatType](value,formatDetails,entityInstance);
        }
        return value;
    };

    public format_currency=(value,formatDetails,entityInstance)=>{
        if(angular.isUndefined){
            formatDetails = {};
        }
    };

    public format_date=(value,formatDetails,entityInstance)=>{
        if(angular.isUndefined){
            formatDetails = {};
        }
    };

   public format_datetime=(value,formatDetails,entityInstance)=>{
        if(angular.isUndefined){
            formatDetails = {};
        }
    };

    public format_pixels=(value,formatDetails,entityInstance)=>{
        if(angular.isUndefined){
            formatDetails = {};
        }
    };

   public  format_yesno=(value,formatDetails,entityInstance)=>{
        if(angular.isUndefined){
            formatDetails = {};
        }
        if(Boolean(value) === true ){
            return entityInstance.metaData.$$getRBKey("define.yes");
        }else if(value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0'){
            return entityInstance.metaData.$$getRBKey("define.no");
        }
    };

    public left = (stringItem:string,count:number):string =>{
        return stringItem.substring(0,count);
    };

    public right = (stringItem:string,count:number):string =>{
        return stringItem.substring(stringItem.length-count,stringItem.length);
    };

    //this.utilityService.mid(propertyIdentifier,1,propertyIdentifier.lastIndexOf('.'));
    public mid = (stringItem:string,start:number,count:number):string =>{
        var end = start + count;
        return stringItem.substring(start,end);
    };

    public getPropertiesFromString = (stringItem:string):Array<string> =>{
            if(!stringItem) return;
            var capture = false;
            var property = '';
            var results = [];
            for(var i=0; i < stringItem.length; i++){
                if(!capture && stringItem.substr(i,2) == "${"){
                    property = '';
                    capture = true;
                    i = i+1;//skip the ${
                } else if(capture && stringItem[i] != '}'){
                    property = property.concat(stringItem[i]);
                } else if(capture) {
                    results.push(property);
                    capture = false;
                }
            }
            return results;
    };

        public replacePropertiesWithData = (stringItem:string, data)=>{
            var results = this.getPropertiesFromString(stringItem);
            for(var i=0; i < results.length; i++){
                stringItem = stringItem.replace('${'+results[i]+'}', data[i]);
            }
            return stringItem;
    };

    public replaceAll = (stringItem:string, find:string, replace:string):string => {
        return stringItem.replace(new RegExp(this.escapeRegExp(find), 'g'), replace);
    };

    public escapeRegExp = (stringItem:string) =>{
        return stringItem.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
    };

    public createID = (count:number):string =>{
          var count = count || 26;

          var text = "";
          var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

          for( var i=0; i < count; i++ )
              text += possible.charAt(Math.floor(Math.random() * possible.length));

          return text;
    };

      //list functions
      public arrayToList = (array:Array<any>, delimiter?:string) =>{
          if(delimiter != null){
              return array.join(delimiter);
          } else {
              return array.join();
          }
    };


    public getPropertyValue=(object, propertyIdentifier):void=> {

        var keys = propertyIdentifier.split('.'), obj = object, keyPart;
        while ((keyPart = keys.shift()) && keys.length) {
            obj = obj[keyPart];
        }
        return obj[keyPart];

    }

    public setPropertyValue=(object, propertyIdentifier,value):void=> {

        var keys = propertyIdentifier.split('.'), obj = object, keyPart;


        while ((keyPart = keys.shift()) && keys.length) {
            if(!obj[keyPart]){
                obj[keyPart] = {};
            }
            obj = obj[keyPart];

        }
        obj[keyPart] = value;



    };

    public nvpToObject=(NVPData):{}=>{
        var object = {};
        for(var key in NVPData){
            var value = NVPData[key];
            var propertyIdentitifer = key.replace(/\_/g,'.');
            this.setPropertyValue(object,propertyIdentitifer,value);


        }
        return object;
    };

    public isDescendantElement = (parent, child) => {
        var node = child.parentNode;
        while (node != null) {
            if (node == parent) {
                return true;
            }
            node = node.parentNode;
        }
        return false;
    };

    public listFind = (list: string = '', value: string = '', delimiter: string = ','): number => {
          var splitString = list.split(delimiter);
          var stringFound = -1;
          for (var i = 0; i < splitString.length; i++) {
              var stringPart = splitString[i];
              if (stringPart === value){
                  stringFound = i;
              }
          }
         return stringFound;
    };

      public listLen = (list:string='',delimiter:string=','):number =>{

          var splitString = list.split(delimiter);
          return splitString.length;
    };

        //This will enable you to sort by two separate keys in the order they are passed in
      public arraySorter = (array:any[], keysToSortBy:string[]):any[] =>{
          var arrayOfTypes = [],
                returnArray = [],
                firstKey = keysToSortBy[0];

            if(angular.isDefined(keysToSortBy[1])){
                var secondKey = keysToSortBy[1];
            }

            for(var itemIndex in array){
                if(!(arrayOfTypes.indexOf(array[itemIndex][firstKey]) > -1)){
                    arrayOfTypes.push(array[itemIndex][firstKey]);
                }
            }
            arrayOfTypes.sort(function(a, b){
                if(a < b){
                    return -1;
                }else if(a > b){
                    return 1;
                }else{
                    return 0;
                }
            });
            for(var typeIndex in arrayOfTypes){
                var tempArray = [];
                for(var itemIndex in array){
                    if(array[itemIndex][firstKey] == arrayOfTypes[typeIndex]){
                        tempArray.push(array[itemIndex]);
                    }
                }
                if(keysToSortBy[1] != null){
                    tempArray.sort(function(a, b){
                        if(a[secondKey]< b[secondKey]){
                            return -1;
                        }else if(a[secondKey] > b[secondKey]){
                            return 1;
                        }else{
                            return 0;
                        }
                    });
                }

                for(var finalIndex in tempArray){
                    returnArray.push(tempArray[finalIndex]);
                }

            }
            return returnArray;
    };

        public minutesOfDay = (m):number=>{
            return m.getMinutes() + m.getHours() * 60;
        };
}
export {
    UtilityService
};

