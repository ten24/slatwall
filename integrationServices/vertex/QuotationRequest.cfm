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
<cfoutput>
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:vertexinc:o-series:tps:6:0">
	   	<soapenv:Header/>
	   	<soapenv:Body>
	      	<urn:VertexEnvelope>
	      		<urn:Login>
	      		<cfif len(setting('webServicesTrustedID'))>
	      			<urn:TrustedId>#setting('webServicesTrustedID')#</urn:TrustedId>
	      		<cfelseif len(setting('webServicesUsername'))>
	      			<urn:UserName>#setting('webServicesUsername')#</urn:UserName>
	            	<urn:Password>#setting('webServicesPassword')#</urn:Password>
	         	</cfif>
	      		</urn:Login>
	         	<urn:QuotationRequest documentDate="#dateTimeFormat(Now(), 'yyyy-mm-dd')#" documentNumber="#arguments.requestBean.getOrderID()#" transactionId="#createUUID()#" transactionType="SALE">
				  	<urn:Currency isoCurrencyCodeAlpha="#addressTaxRequestItems[ 1 ].getCurrencyCode()#"/>
				  	<urn:Seller>
				    	<urn:Company>#xmlFormat(setting('company'))#</urn:Company>
				    	<urn:Division>#xmlFormat(setting('division'))#</urn:Division>
				    	<urn:Department>#xmlFormat(setting('department'))#</urn:Department>
				    	<urn:PhysicalOrigin>
				      		<urn:City>#xmlFormat(setting('originCity'))#</urn:City>
				      		<urn:MainDivision>#xmlFormat(setting('originMainDivision'))#</urn:MainDivision>
				      		<urn:PostalCode>#xmlFormat(setting('originPostalCode'))#</urn:PostalCode>
				     		<urn:Country>#xmlFormat(setting('originCountry'))#</urn:Country>
				     		<cfif addressTaxRequestItems[ 1 ].getCurrencyCode() neq setting('originCurrencyCode')>
			     				<urn:CurrencyConversion isoCurrencyCodeAlpha="#xmlFormat(setting('originCurrencyCode'))#">#getService('currencyCode').getCurrencyConversionRate(originalCurrencyCode=addressTaxRequestItems[ 1 ].getCurrencyCode(), convertToCurrencyCode=setting('originCurrencyCode'))#</urn:CurrencyConversion>
			     			<cfelse>
			     				<urn:CurrencyConversion isoCurrencyCodeAlpha="#xmlFormat(setting('originCurrencyCode'))#">1</urn:CurrencyConversion>
			     			</cfif>
				   		</urn:PhysicalOrigin>
				  	</urn:Seller>
				  	<urn:Customer>
				    	<urn:CustomerCode>#arguments.requestBean.getAccountID()#</urn:CustomerCode>
				    	<urn:Destination>
				    		<urn:StreetAddress1>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxStreetAddress())#</urn:StreetAddress1>
				      		<urn:StreetAddress2>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxStreet2Address())#</urn:StreetAddress2>
							<urn:City>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxCity())#</urn:City>
				      		<urn:MainDivision>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxStateCode())#</urn:MainDivision>
				      		<urn:PostalCode>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxPostalCode())#</urn:PostalCode>
				     		<urn:Country>#xmlFormat(addressTaxRequestItems[ 1 ].getTaxCountryCode())#</urn:Country>
				     		<cfset local.destinationCurrencyCode = 'USD' />
				     		<cfset local.destinationCountry = getService('addressService').getCountry(addressTaxRequestItems[ 1 ].getTaxCountryCode()) />
				     		<cfif !isNull(local.destinationCountry) and !isNull(local.destinationCountry.getDefaultCurrency())>
				     			<cfset local.destinationCurrencyCode = local.destinationCountry.getDefaultCurrency().getCurrencyCode() />
				     		</cfif>
				     		<cfif addressTaxRequestItems[ 1 ].getCurrencyCode() neq local.destinationCurrencyCode>
			     				<urn:CurrencyConversion isoCurrencyCodeAlpha="#xmlFormat(local.destinationCurrencyCode)#">#getService('currencyService').getCurrencyConversionRate(originalCurrencyCode=addressTaxRequestItems[ 1 ].getCurrencyCode(), convertToCurrencyCode=local.destinationCurrencyCode)#</urn:CurrencyConversion>
			     			<cfelse>
			     				<urn:CurrencyConversion isoCurrencyCodeAlpha="#xmlFormat(local.destinationCurrencyCode)#">1</urn:CurrencyConversion>
			     			</cfif>
				    	</urn:Destination>
					 </urn:Customer>
					 <cfset var count = 0 />
					 <cfloop array="#addressTaxRequestItems#" index="taxRequestItem">
					 	<cfset count++ />
					 	 <urn:LineItem lineItemNumber="#count#" materialCode="#taxRequestItem.getOrderItemID()#">
					    	<urn:ExtendedPrice>#taxRequestItem.getExtendedPriceAfterDiscount()#</urn:ExtendedPrice>
							<urn:FlexibleFields>
								<cfif !isNull(arguments.requestBean.getAccount())>
						      		<urn:FlexibleCodeField fieldId="7">#left(xmlFormat(arguments.requestBean.getAccount().getFullName()), 40)#</urn:FlexibleCodeField>
								</cfif>
					      		<urn:FlexibleCodeField fieldId="11">#xmlFormat(taxRequestItem.getTaxCategoryRateCode())#</urn:FlexibleCodeField>
					      		<urn:FlexibleCodeField fieldId="12">#left(xmlFormat(taxRequestItem.getOrderItem().getSku().getProduct().getProductName()), 40)#</urn:FlexibleCodeField>
					    	</urn:FlexibleFields>
					  	</urn:LineItem>
					</cfloop>			 
				</urn:QuotationRequest>
			</urn:VertexEnvelope>
		</soapenv:Body>
	</soapenv:Envelope>
</cfoutput>
