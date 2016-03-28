/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWMarketingCampaignActivity{
    public static Factory(){
        var directive=(
            marketingAutomationPartialsPath, hibachiPathBuilder, $rootScope
        )=>new SWMarketingCampaignActivity(
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
            templateUrl : hibachiPathBuilder.buildPartialsPath(marketingAutomationPartialsPath) + "marketingcampaignactivity.html",
            link : function(scope, element, attrs) {
                $rootScope.marketingCampaignID = scope.entity.data.marketingCampaignID;
            }
        };
    }
}
export{
    SWMarketingCampaignActivity
}
