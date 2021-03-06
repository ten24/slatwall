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

<cfparam name="rc.productReviewSmartList" type="any" />
<cfset rc.productReviewSmartList.addOrder("createdDateTime|DESC") />
<cfoutput>
	<hb:HibachiEntityActionBar type="listing" object="#rc.productReviewSmartList#" showCreate="false" >
	
	
	<!--- Create --->
		<hb:HibachiEntityActionBarButtonGroup>
			<hb:HibachiActionCaller action="admin:entity.createProductReview" entity="productReview" class="btn btn-primary" icon="plus icon-white" modal="false" />
		</hb:HibachiEntityActionBarButtonGroup>
	</hb:HibachiEntityActionBar>
	<!--- <hb:HibachiListingDisplay smartList="#rc.productReviewSmartList#"
								recordDetailAction="admin:entity.detailproductreview"
								recordEditAction="admin:entity.editproductreview">
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="reviewTitle" />
		<hb:HibachiListingColumn propertyIdentifier="reviewerName" />
		<hb:HibachiListingColumn propertyIdentifier="rating" />
		<hb:HibachiListingColumn propertyIdentifier="product.productName" />
		<hb:HibachiListingColumn propertyIdentifier="createdDateTime" />
		<hb:HibachiListingColumn propertyIdentifier="activeFlag" />
	</hb:HibachiListingDisplay> --->

	<!---<sw-listing-display data-using-personal-collection="true"
		data-collection="'ProductReview'"
		data-edit="false"
		data-has-search="true"
		record-edit-action="admin:entity.editproductreview"
		record-detail-action="admin:entity.detailproductreview"
		data-is-angular-route="false"
		data-angular-links="false"
		data-has-action-bar="false"
	>
		<sw-listing-column data-property-identifier="productReviewID" data-is-visible="false"  data-is-deletable="false"></sw-listing-column>
		<sw-listing-column data-property-identifier="reviewTitle" tdclass="primary" ></sw-listing-column>
		<sw-listing-column data-property-identifier="reviewerName" ></sw-listing-column>
		<sw-listing-column data-property-identifier="rating" ></sw-listing-column>
		<sw-listing-column data-property-identifier="product.productName" ></sw-listing-column>
		<sw-listing-column data-property-identifier="product.defaultSku.price" ></sw-listing-column>
		<sw-listing-column data-property-identifier="createdDateTime" ></sw-listing-column>
		<sw-listing-column data-property-identifier="createdDateTime" ></sw-listing-column>
		<sw-listing-column data-property-identifier="productReviewStatusType.typeName" ></sw-listing-column>
	</sw-listing-display>--->
	<cfset displayPropertyList = "product.productName,rating,reviewTitle,review,reviewerName,account.primaryEmailAddress.emailAddress,createdDateTime"/>
	<cfset rc.productReviewCollectionList.setDisplayProperties(
		displayPropertyList,
		{
			isVisible=true,
			isSearchable=true,
			isDeletable=true
		}
	)/>

	<cfset rc.productReviewCollectionList.addDisplayProperty(displayProperty='productReviewStatusType.typeName',title="#getHibachiScope().rbKey('entity.ProductReview.productReviewStatusType')#",columnConfig={
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset rc.productReviewCollectionList.addDisplayProperty(displayProperty='productReviewID',columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	
	<hb:HibachiListingDisplay 
		collectionList="#rc.productReviewCollectionList#"
		usingPersonalCollection="true"
		recordEditAction="admin:entity.edit#lcase(rc.productReviewCollectionList.getCollectionObject())#"
		recordDetailAction="admin:entity.detail#lcase(rc.productReviewCollectionList.getCollectionObject())#"
	>
	</hb:HibachiListingDisplay>

</cfoutput>
