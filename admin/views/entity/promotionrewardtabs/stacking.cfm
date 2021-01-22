<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.promotionreward" type="any">
<cfparam name="rc.promotionperiod" type="any" default="#rc.promotionreward.getPromotionPeriod()#" />
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.edit" type="boolean">

<cfif rc.promotionreward.getRewardType() == 'order'>
    <cfset local.includeRewardType = 'Order' >
    <cfset local.excludeRewardType = 'Merchandise' >
<cfelse>
    <cfset local.includeRewardType = 'Merchandise' >
    <cfset local.excludeRewardType = 'Order' >
</cfif>

<cfset local.includeRewardCollection = $.slatwall.getService('PromotionService').getPromotionRewardCollectionList() />
<cfset local.includeRewardCollection.setDisplayProperties('promotionPeriod.promotion.promotionName,promotionPeriod.promotionPeriodName,amountType,amount',{isVisible:true,isSearchable:true}) />
<cfset local.includeRewardCollection.addDisplayProperty(displayProperty="promotionRewardID",columnConfig={isVisible:false})>
<cfset local.includeRewardCollection.addFilter('rewardType',local.includeRewardType) />
<cfset local.includeRewardCollection.addFilter('promotionRewardID',rc.promotionReward.getPromotionRewardID(),"!=") />
<cfset local.includeRewardCollection.addFilter('promotionPeriod.promotion.activeFlag',"true") />
<cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.endDateTime',value='#now()#',comparisonOperator='>=',filterGroupAlias="endDateTime") />
<cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.endDateTime',value='null',comparisonOperator="IS",logicalOperator="OR",filterGroupAlias="endDateTime") />
<cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.startDateTime',value='#now()#',comparisonOperator='<=',filterGroupAlias="startDateTime") />
<cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.startDateTime',value='null',comparisonOperator="IS",logicalOperator="OR", filterGroupAlias="startDateTime") />
<cfif !isNull(rc.promotionPeriod.getPromotion().getSite()) >
    <cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.promotion.site.siteID',value="#rc.promotionPeriod.getPromotion().getSite().getSiteID()#",filterGroupAlias="site") />
    <cfset local.includeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.promotion.site.siteID',value="null",comparisonOperator="IS", logicalOperator="OR",filterGroupAlias="site") />
</cfif>

<cfset local.excludeRewardCollection = $.slatwall.getService('PromotionService').getPromotionRewardCollectionList() />
<cfset local.excludeRewardCollection.setDisplayProperties('promotionPeriod.promotion.promotionName,promotionPeriod.promotionPeriodName,amountType,amount',{isVisible:true,isSearchable:true}) />
<cfset local.excludeRewardCollection.addDisplayProperty(displayProperty="promotionRewardID",columnConfig={isVisible:false}) >
<cfset local.excludeRewardCollection.addFilter('rewardType',local.excludeRewardType) />
<cfset local.excludeRewardCollection.addFilter('promotionPeriod.promotion.activeFlag',"true") />
<cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.endDateTime',value='#now()#',comparisonOperator='>=',filterGroupAlias="endDateTime") />
<cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.endDateTime',value='null',comparisonOperator="IS",logicalOperator="OR",filterGroupAlias="endDateTime") />
<cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.startDateTime',value='#now()#',comparisonOperator='<=',filterGroupAlias="startDateTime") />
<cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.startDateTime',value='null',comparisonOperator="IS",logicalOperator="OR", filterGroupAlias="startDateTime") />
<cfif !isNull(rc.promotionPeriod.getPromotion().getSite()) >
    <cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.promotion.site.siteID',value="#rc.promotionPeriod.getPromotion().getSite().getSiteID()#",filterGroupAlias="site") />
    <cfset local.excludeRewardCollection.addFilter(propertyIdentifier='promotionPeriod.promotion.site.siteID',value="null",comparisonOperator="IS",logicalOperator="OR",filterGroupAlias="site") />
</cfif>

<cfset local.includedRewardIDs = rc.promotionReward.getIncludedStackableRewardsIDList() />
<cfset local.excludedRewardIDs = rc.promotionReward.getExcludedStackableRewardsIDList() />
<cfif NOT rc.edit>
    <cfset local.includeRewardCollection.addFilter('promotionRewardID',local.includedRewardIDs,'IN') />
    <cfset local.excludeRewardCollection.addFilter('promotionRewardID',local.excludedRewardIDs,'IN') />
</cfif>


<cfoutput>
    <div class="col-md-6">
        <hb:HibachiListingDisplay 
            collectionList="#local.includeRewardCollection#" 
            title="Included #local.includeRewardType# Rewards"
            edit="#rc.edit#" 
            displaytype="plainTitle"
            showSimpleListingControls="false"
            multiselect="true"
            multiselectPropertyIdentifier="promotionRewardID"
            multiselectFieldName="includedStackableRewards"
            multiselectValues="#local.includedRewardIDs#"/>
        <input type="hidden" name="includedStackableRewards" value="" />
	</div>
	<div class="col-md-6">
	    <hb:HibachiListingDisplay 
	        collectionList="#local.excludeRewardCollection#" 
	        title="Excluded #local.excludeRewardType# Rewards" 
	        edit="#rc.edit#" 
            displaytype="plainTitle"
            showSimpleListingControls="false"
            multiselect="true"
            multiselectPropertyIdentifier="promotionRewardID"
            multiselectFieldName="excludedStackableRewards"
            multiselectValues="#local.excludedRewardIDs#"/>
        <input type="hidden" name="excludedStackableRewards" value="" />
	</div>
</cfoutput>