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
<cfimport prefix="swa" taglib="../tags" />
<cfimport prefix="hb" taglib="../org/Hibachi/HibachiTags" />
<cfparam name="attributes.address" type="any" />
<cfparam name="attributes.edit" type="boolean" default="true" />
<cfparam name="attributes.fieldNamePrefix" type="string" default="" />
<cfparam name="attributes.showCountry" type="boolean" default="true" />
<cfparam name="attributes.showPhoneNumber" type="boolean" default="false" />
<cfparam name="attributes.showEmailAddress" type="boolean" default="false" />
<cfparam name="attributes.showName" type="boolean" default="true" />
<cfparam name="attributes.showCompany" type="boolean" default="true" />
<cfparam name="attributes.showStreetAddress" type="boolean" default="true" />
<cfparam name="attributes.showStreet2Address" type="boolean" default="true" />
<cfparam name="attributes.showLocality" type="boolean" default="true" />
<cfparam name="attributes.showCity" type="boolean" default="true" />
<cfparam name="attributes.showState" type="boolean" default="true" />
<cfparam name="attributes.showPostalCode" type="boolean" default="true" />

<cfif isNull(attributes.address.getCountryCode()) and attributes.edit>
	<cfset attributes.address.setCountryCode('US') />
</cfif>

<cfif thisTag.executionMode is "start">
	<cfoutput>
		<div class="slatwall-address-container">
			<input type="hidden" name="#attributes.fieldNamePrefix#addressID" value="#attributes.address.getAddressID()#" />
			<cfif attributes.showCountry>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#countryCode" property="countryCode" fieldType="select" edit="#attributes.edit#" fieldClass="slatwall-address-countryCode" />
			</cfif>
			<cfif attributes.showName>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#name" property="name" edit="#attributes.edit#" fieldClass="slatwall-address-name" />
			</cfif>
			<cfif attributes.showCompany>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#company" property="company" edit="#attributes.edit#" fieldClass="slatwall-address-company"  />
			</cfif>
			<cfif attributes.showPhoneNumber>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#phoneNumber" property="phoneNumber" edit="#attributes.edit#" fieldClass="slatwall-address-phoneNumber"  />
			</cfif>
			<cfif attributes.showEmailAddress>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#emailAddress" property="emailAddress" edit="#attributes.edit#" fieldClass="slatwall-address-emailAddress"  />
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStreetAddressShowFlag()) and attributes.showStreetAddress>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#streetAddress" property="streetAddress" edit="#attributes.edit#" fieldClass="slatwall-address-streetAddress" />	
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStreet2AddressShowFlag()) and attributes.showStreet2Address>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#street2Address" property="street2Address" edit="#attributes.edit#" fieldClass="slatwall-address-street2Address" />	
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) ||  attributes.address.getCountry().getLocalityShowFlag()) and attributes.showLocality>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#locality" property="locality" edit="#attributes.edit#" fieldClass="slatwall-address-locality" />	
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) ||  attributes.address.getCountry().getCityShowFlag()) and attributes.showCity>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#city" property="city" edit="#attributes.edit#" fieldClass="slatwall-address-city" />	
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) || attributes.address.getCountry().getStateCodeShowFlag()) and attributes.showState>
				<cfif attributes.edit and arrayLen(attributes.address.getStateCodeOptions()) gt 1>
					<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="select" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				<cfelse>
					<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#stateCode" property="stateCode" fieldType="text" edit="#attributes.edit#" fieldClass="slatwall-address-stateCode" />
				</cfif>
			</cfif>
			<cfif (isNull(attributes.address.getCountry()) ||  attributes.address.getCountry().getPostalCodeShowFlag()) and attributes.showPostalCode>
				<hb:HibachiPropertyDisplay object="#attributes.address#" fieldName="#attributes.fieldNamePrefix#postalCode" property="postalCode" edit="#attributes.edit#" fieldClass="slatwall-address-postalCode" />	
			</cfif>
		</div>
	</cfoutput>
</cfif>
