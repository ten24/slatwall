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
<cfparam name="rc.subscriptionUsage" type="any">

<cfoutput>
<sw-listing-display data-collection="'SubscriptionUsageBenefitAccount'"
                    data-edit="false"
                    data-show-search="true"
                    data-has-search="false"
                    data-has-action-bar="false"
                    data-record-edit-action="admin:entity.editsubscriptionusagebenefitaccount"
                    data-is-angular-route="false">
    <sw-listing-column data-property-identifier="subscriptionUsageBenefit.subscriptionBenefit.subscriptionBenefitName" ></sw-listing-column>
    <sw-listing-column data-property-identifier="account.firstName" ></sw-listing-column>
    <sw-listing-column data-property-identifier="account.lastName" ></sw-listing-column>
    <sw-listing-column data-property-identifier="account.primaryEmailAddress.emailAddress" ></sw-listing-column>
    <sw-listing-filter data-property-identifier="subscriptionUsageBenefit.subscriptionUsage.subscriptionUsageID" data-comparison-operator="=" data-comparison-value="#rc.subscriptionUsage.getSubscriptionUsageID()#" ></sw-listing-filter>
</sw-listing-display>
</cfoutput>

