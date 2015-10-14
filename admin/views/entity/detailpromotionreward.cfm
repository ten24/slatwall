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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.promotionReward" type="any">
<cfparam name="rc.promotionPeriod" type="any" default="#rc.promotionReward.getPromotionPeriod()#">
<cfparam name="rc.rewardType" type="string" default="#rc.promotionReward.getRewardType()#">
<cfparam name="rc.amountType" type="string" default="percentage">
<cfparam name="rc.edit" type="boolean">

<!--- prevent editing promotion reward if its promotion period has expired --->
<cfif rc.edit and rc.promotionperiod.isExpired()>
	<cfset rc.edit = false />
	<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.editdisabled_info') />
</cfif>
<cfif rc.edit>
	<cfset rc.promotionReward.setRewardType(rc.rewardType) />
</cfif>



<!--- Show a message if the user has not yet selected a product type, sku, etc...when reward type is merchandise --->
<cfif not rc.promotionperiod.isExpired() and not rc.edit and rc.promotionReward.getRewardType() eq "merchandise">
	<cfif not arrayLen(rc.promotionReward.getSkus()) and not arrayLen(rc.promotionReward.getProducts()) and not arrayLen(rc.promotionReward.getProductTypes())>
		<cfset rc.$.slatwall.showMessageKey('admin.pricing.promotionperiod.productortypeorskunotdefined_info') />
	</cfif>
</cfif>

<cfif not isnull(rc.promotionReward.getAmountType())>
	<cfset rc.amountType=rc.promotionReward.getAmountType()>
</cfif>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.promotionreward#" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.promotionreward#" edit="#rc.edit#" 
							  cancelAction="admin:entity.detailpromotionreward"
							  cancelQueryString="promotionRewardID=#rc.promotionReward.getPromotionRewardID()#" 
							  backAction="admin:entity.detailpromotionperiod" 
							  backQueryString="promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()###tabPromotionRewards" 
							  deleteQueryString="redirectAction=admin:entity.detailpromotionperiod&promotionPeriodID=#rc.promotionPeriod.getPromotionPeriodID()#" />
		
		<hb:HibachiEntityDetailGroup object="#rc.promotionreward#">
			<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/basic" open="true" text="#$.slatwall.rbKey('admin.define.basic')#" showOnCreateFlag=true />
			<cfif rc.amountType neq 'percentage'>
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/currencies"/>
			</cfif>
			<cfif listFindNoCase("merchandise,subscription,contentaccess", rc.rewardType)>
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/producttypes" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/products" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/skus" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/brands" />
				<cfif rc.rewardType eq "merchandise">
					<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/options" />
				</cfif>
			<cfelseif rc.rewardType eq "fulfillment">
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/fulfillmentMethods" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/shippingMethods" />
				<hb:HibachiEntityDetailItem view="admin:entity/promotionrewardtabs/shippingAddressZones" />
			</cfif>
		</hb:HibachiEntityDetailGroup>

	</hb:HibachiEntityDetailForm>
</cfoutput>
