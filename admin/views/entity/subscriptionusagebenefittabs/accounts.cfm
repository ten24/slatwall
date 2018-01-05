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
<cfparam name="rc.subscriptionUsageBenefit" type="any">

<cfoutput>
    <sw-listing-display
            data-collection="SubscriptionUsageBenefitAccount"
            data-multi-slot="true"
            data-edit="true"
            data-has-search="true"
            data-is-angular-route="false"
            data-angular-links="false"
            data-has-action-bar="false"
            data-record-detail-action="admin:entity.detailSubscriptionUsageBenefitAccount"
            data-name="subscriptionUsageBenefitAccountListingDisplay">

    <sw-collection-configs>
    <sw-collection-config
            data-entity-name="SubscriptionUsageBenefitAccount"
            parent-directive-controller-as-name="swListingDisplay">

    <sw-collection-filters>
            <sw-collection-filter data-property-identifier="subscriptionUsageBenefit.subscriptionUsageBenefitID" data-comparison-operator="=" data-comparison-value="#rc.subscriptionUsageBenefit.getSubscriptionUsageBenefitID()#"></sw-collection-filter>
</sw-collection-filters>

    <sw-collection-columns>
        <sw-collection-column is-only-keyword-column="false" data-property-identifier="account.firstName" ></sw-collection-column>
        <sw-collection-column is-only-keyword-column="false" data-property-identifier="account.lastName" ></sw-collection-column>
        <sw-collection-column is-only-keyword-column="false" data-property-identifier="account.primaryEmailAddress.emailAddress" ></sw-collection-column>
    </sw-collection-columns>
</sw-collection-config>
</sw-collection-configs>

    <sw-listing-column data-title="First Name" data-property-identifier="account.firstName" ></sw-listing-column>
    <sw-listing-column data-title="Last Name" data-property-identifier="account.lastName" ></sw-listing-column>
    <sw-listing-column data-title="Email Address" data-property-identifier="account.primaryEmailAddress.emailAddress" ></sw-listing-column>

</sw-listing-display>
</cfoutput>
