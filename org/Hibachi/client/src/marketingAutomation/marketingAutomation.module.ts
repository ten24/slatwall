/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//services

//directives
import {SWMarketingCampaignBasic} from "./components/swmarketingcampaignbasic";
import {SWMarketingCampaignActivity} from "./components/swmarketingcampaignactivity";
import {SWMarketingCampaignList} from "./components/swmarketingcampaignlist";
//filters


var marketingautomationmodule = angular.module('hibachi.marketingautomation',[]).config(()=>{})
//constants
        .constant('marketingAutomationPartialsPath','marketingautomation/components/')
//services

//directives
        .directive('swMarketingCampaignBasic',SWMarketingCampaignBasic.Factory())
        .directive('swMarketingCampaignActivity',SWMarketingCampaignActivity.Factory())
        .directive('swMarketingCampaignList',SWMarketingCampaignList.Factory())
//filters
    ;
export{
    marketingautomationmodule
}