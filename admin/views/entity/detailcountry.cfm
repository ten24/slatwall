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
<cfparam name="rc.country" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<cf_HibachiEntityDetailForm object="#rc.country#" edit="#rc.edit#">
		<cf_HibachiEntityActionBar type="detail" object="#rc.country#" edit="#rc.edit#" />
		
		<cf_HibachiPropertyRow>
			<cf_HibachiPropertyList divClass="span6">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryCode3Digit" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryISONumber" edit="#rc.country.getNewFlag()#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="activeFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="countryName" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeLabel" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeLabel" edit="#rc.edit#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span3">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeShowFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeShowFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
			<cf_HibachiPropertyList divClass="span3">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="streetAddressRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="street2AddressRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="localityRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="cityRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="stateCodeRequiredFlag" edit="#rc.edit#">
				<cf_HibachiPropertyDisplay object="#rc.country#" property="postalCodeRequiredFlag" edit="#rc.edit#">
			</cf_HibachiPropertyList>
		</cf_HibachiPropertyRow>
	</cf_HibachiEntityDetailForm>
	
	<cf_HibachiTabGroup object="#rc.country#">
		<cf_HibachiTab property="states" />
	</cf_HibachiTabGroup>
	
</cfoutput>

