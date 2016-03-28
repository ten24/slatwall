/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWMarketingCampaignBasic{
    public static Factory(){
        var directive=(
            marketingAutomationPartialsPath,
            hibachiPathBuilder
        )=>new SWMarketingCampaignBasic(
            marketingAutomationPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            'marketingAutomationPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    constructor(marketingAutomationPartialsPath, hibachiPathBuilder){

        return {
            restrict : 'A',
            scope : {
                entity : "="
            },
            templateUrl : hibachiPathBuilder.buildPartialsPath(marketingAutomationPartialsPath) + "marketingcampaignbasic.html",
            link : function(scope, element, attrs) {
                console.warn('MARKETING ACTIVITY');
                console.log(scope.entity);
            }
        };
    }
}
export{
    SWMarketingCampaignBasic
}
