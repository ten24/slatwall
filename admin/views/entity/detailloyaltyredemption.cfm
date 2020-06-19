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


<cfparam name="rc.loyaltyRedemption" type="any">
<cfparam name="rc.loyalty" type="any" default="#rc.loyaltyRedemption.getLoyalty()#">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.loyaltyRedemption#" edit="#rc.edit#"  
								saveActionQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()#">
								
		<hb:HibachiEntityActionBar type="detail" object="#rc.loyaltyRedemption#" edit="#rc.edit#"
								   backAction="admin:entity.detailloyalty"
								   backQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()###tabloyaltyRedemption"
								   cancelAction="admin:entity.detailloyalty"
								   cancelQueryString="loyaltyID=#rc.loyalty.getLoyaltyID()#" 
							  	   deleteQueryString="redirectAction=admin:entity.detailloyalty&loyaltyID=#rc.loyalty.getLoyaltyID()#" />
		
		<input type="hidden" name="loyalty.loyaltyID" value="#rc.loyalty.getLoyaltyID()#" />
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="activeFlag" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="redemptionPointType" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="minimumPointQuantity" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="autoRedemptionType" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="redemptionType" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="priceGroup" edit="#rc.edit#">
				<!--- Add this back when the feature is available --->
				<!---<hb:HibachiDisplayToggle selector="select[name=autoRedemptionType]" showValues="loyaltyTermEnd" loadVisable="#rc.loyaltyRedemption.getNewFlag() or rc.loyaltyRedemption.getValueByPropertyIdentifier('autoRedemptionType') eq 'loyaltyTermEnd'#">
					<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="loyaltyTerm" edit="#rc.edit#">
				</hb:HibachiDisplayToggle>--->
				<!---<hb:HibachiDisplayToggle selector="select[name=redemptionType]" showValues="pointPurchase" loadVisable="#rc.loyaltyRedemption.getNewFlag() or rc.loyaltyRedemption.getValueByPropertyIdentifier('redemptionType') eq 'pointPurchase'#">
					<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="amountType" edit="#rc.edit#">
					<hb:HibachiPropertyDisplay object="#rc.loyaltyRedemption#" property="amount" edit="#rc.edit#">	
				</hb:HibachiDisplayToggle>--->
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>
		
		<cfif not rc.loyaltyRedemption.getRedemptionType() eq "priceGroupAssignment">
			<hb:HibachiTabGroup object="#rc.loyaltyRedemption#">
				<hb:HibachiTab view="admin:entity/loyaltyRedemptiontabs/producttypes" />
				<hb:HibachiTab view="admin:entity/loyaltyRedemptiontabs/products" />
				<hb:HibachiTab view="admin:entity/loyaltyRedemptiontabs/skus" />
				<hb:HibachiTab view="admin:entity/loyaltyRedemptiontabs/brands" />
			</hb:HibachiTabGroup>
		</cfif>

	</hb:HibachiEntityDetailForm>
</cfoutput>
