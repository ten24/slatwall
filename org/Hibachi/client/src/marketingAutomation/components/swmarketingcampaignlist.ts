/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWMarketingCampaignList{
    public static Factory(){
        var directive=(
            marketingAutomationPartialsPath, hibachiPathBuilder, $rootScope
        )=>new SWMarketingCampaignList(
            marketingAutomationPartialsPath, hibachiPathBuilder, $rootScope
        );
        directive.$inject = [
            'marketingAutomationPartialsPath',
            'hibachiPathBuilder',
            '$rootScope'
        ];
        return directive;
    }
    constructor( marketingAutomationPartialsPath, hibachiPathBuilder, $rootScope){

        return {
            restrict : 'A',
            scope : {
                entity : "="
            },
            templateUrl : hibachiPathBuilder.buildPartialsPath(marketingAutomationPartialsPath) + "marketingcampaignlist.html",
            link : function(scope, element, attrs) {
                $rootScope.marketingCampaignID = scope.entity.data.marketingCampaignID;
            }
        };
    }
}
export{
    SWMarketingCampaignList
}
