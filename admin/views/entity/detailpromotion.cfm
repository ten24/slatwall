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
<cfparam name="rc.promotion" type="any">
<cfparam name="rc.edit" type="boolean">

<cfif arrayLen(rc.promotion.getPromotionPeriods()) eq 1 and !arrayLen(rc.promotion.getPromotionPeriods()[1].getPromotionRewards())>
	<cfset request.slatwallScope.showMessageKey('admin.pricing.detailpromotion.norewards_info') />
</cfif>

<cfif arrayLen(rc.promotion.getPromotionCodes()) gt 0 and rc.promotion.getCurrentPromotionPeriodFlag() and not rc.promotion.getCurrentPromotionCodeFlag()>
	<cfset request.slatwallScope.showMessageKey('admin.entity.detailpromotion.currentPeriodWithNoCurrentPromoCode_info') />
</cfif>


<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.promotion#" edit="#rc.edit#" saveActionQueryString="promotionID=#rc.promotion.getPromotionID()#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.promotion#" edit="#rc.edit#" >
			<cf_HibachiActionCaller action="admin:entity.createpromotioncode" querystring="promotionID=#rc.promotion.getPromotionID()#&redirectAction=#request.context.slatAction#" type="list" modal="true" />
			<cf_HibachiActionCaller action="admin:entity.createpromotionperiod" querystring="promotionID=#rc.promotion.getPromotionID()#&redirectAction=#request.context.slatAction#" type="list" modal="true" />
		</cf_HibachiEntityActionBar>
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList>
				<cf_HibachiPropertyDisplay object="#rc.Promotion#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.Promotion#" property="promotionName" edit="#rc.edit#">
				<cfif rc.promotion.isNew()>
					<hr />
					<h5>#$.slatwall.rbKey('admin.pricing.detailpromotion.initialperiod')#</h5><br />
					<cf_HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].startDateTime" property="startDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].endDateTime" property="endDateTime" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumUseCount" property="maximumUseCount" edit="#rc.edit#">
					<cf_HibachiPropertyDisplay object="#rc.promotionPeriod#" fieldName="promotionPeriods[1].maximumAccountUseCount" property="maximumAccountUseCount" edit="#rc.edit#">
					<input type="hidden" name="promotionPeriods[1].promotionPeriodID" value="#rc.promotionPeriod.getPromotionPeriodID()#" />
				</cfif>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.promotion#">
			<cf_HibachiTab view="admin:entity/promotiontabs/promotionperiods" />
			<cf_HibachiTab view="admin:entity/promotiontabs/promotioncodes" />
			<cf_HibachiTab view="admin:entity/promotiontabs/promotionsummary" />
			<cf_HibachiTab view="admin:entity/promotiontabs/promotiondescription" />
		</cf_HibachiTabGroup>
		
	</cf_HibachiEntityDetailForm>
</cfoutput>

