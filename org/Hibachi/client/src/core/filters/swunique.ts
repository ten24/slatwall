/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWUnique{
   
    //@ngInject
    public static Factory(){
        
        var filterStub:any;
        filterStub = function (items, filterOn) {

            if (filterOn === false) {
                return items;
            }

            if ((filterOn || angular.isUndefined(filterOn)) && angular.isArray(items)) {
                var hashCheck = {}, newItems = [];

                var extractValueToCompare = (item)=>{
                    if (angular.isDefined(item) && item[filterOn] != null) {
                        return item[filterOn];
                    }
                    return item; 
                };

                angular.forEach(items, (item)=>{
                    var isDuplicate = false;

                    for (var i = 0; i < newItems.length; i++) {
                        if (extractValueToCompare(newItems[i]) == extractValueToCompare(item)){
                            isDuplicate = true;
                            break;
                        }
                    }
                    if (!isDuplicate) {
                        newItems.push(item);
                    }
                });
            }
            return newItems;
        };

        //filterStub.$stateful = true;

        return filterStub;
    }
}
export {SWUnique};
