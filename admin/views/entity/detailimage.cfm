<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="rc.image" type="any">
<cfparam name="rc.edit" type="boolean">

<cfset backAction = rc.entityActionDetails.backAction />
<cfset backQueryString = "" />

<!--- find the correct back action & QS --->
<cfif not isNull(rc.image.getProduct())>
	<cfset backAction = "admin:entity.detailproduct" />
	<cfset backQueryString = "productID=#rc.image.getProduct().getProductID()#" />	
<cfelseif  not isNull(rc.image.getPromotion())>
	<cfset backAction = "admin:entity.detailpromotion" />
	<cfset backQueryString = "promotionID=#rc.image.getPromotion().getPromotionID()#" />
<cfelseif not isNull(rc.image.getOption())>
	<cfset backAction = "admin:entity.detailoption" />
	<cfset backQueryString = "optionID=#rc.image.getOption().getOptionID()#" />
</cfif>

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.image#" edit="#rc.edit#" enctype="multipart/form-data">
		<cf_HibachiEntityActionBar type="detail" object="#rc.image#" edit="#rc.edit#" 
								   backAction="#backAction#" 
								   backQueryString="#backQueryString#"
								   deleteQueryString="redirectAction=#backAction#&#backQueryString#"  />

		<cf_HibachiPropertyRow>
			
			<cf_HibachiPropertyList divclass="span8">
				<cf_HibachiPropertyDisplay object="#rc.image#" property="imageName" edit="#rc.edit#">
				#rc.image.getImage()#
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divclass="span2">
				<h4>Resize Preview</h4>
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
		
		<cf_HibachiTabGroup object="#rc.image#">
		</cf_HibachiTabGroup>
	</cf_HibachiEntityDetailForm>
</cfoutput>
