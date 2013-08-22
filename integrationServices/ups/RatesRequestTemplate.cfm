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
	<?xml version="1.0"?>
	<AccessRequest>
		<AccessLicenseNumber>#setting('apiKey')#</AccessLicenseNumber>
		<UserId>#setting('username')#</UserId>
		<Password>#setting('password')#</Password>
	</AccessRequest>
	<RatingServiceSelectionRequest xml:lang="en-US">
		<Request>
			<RequestOption>Shop</RequestOption>
		</Request>
		<PickupType>
			<Code>#setting('pickupTypeCode')#</Code>
		</PickupType>
		<CustomerClassification>
			<Code>#setting('customerClassificationCode')#</Code>
		</CustomerClassification>
		<Shipment>
			<Shipper>
				<Address>
					<City>#setting('shipFromCity')#</City>
					<StateProvinceCode>#setting('shipFromStateCode')#</StateProvinceCode>
					<PostalCode>#setting('shipFromPostalCode')#</PostalCode>
					<CountryCode>#setting('shipFromCountryCode')#</CountryCode>
				</Address>
                		<ShipperNumber>#setting('shipperNumber')#</ShipperNumber>
			</Shipper>
			<ShipTo>
				<Address>
					<City>#arguments.requestBean.getShipToCity()#</City>
					<StateProvinceCode>#arguments.requestBean.getShipToStateCode()#</StateProvinceCode>
					<PostalCode>#arguments.requestBean.getShipToPostalCode()#</PostalCode>
					<CountryCode>#arguments.requestBean.getShipToCountryCode()#</CountryCode>
					<ResidentialAddressIndicator>1</ResidentialAddressIndicator>
				</Address>
			</ShipTo>
			<ShipFrom>
				<Address>
					<City>#setting('shipFromCity')#</City>
					<StateProvinceCode>#setting('shipFromStateCode')#</StateProvinceCode>
					<PostalCode>#setting('shipFromPostalCode')#</PostalCode>
					<CountryCode>#setting('shipFromCountryCode')#</CountryCode>
				</Address>
			</ShipFrom>
			<ShipmentWeight>
				<Weight>#arguments.requestBean.getTotalValue()#</Weight>
			</ShipmentWeight>
			<Package>
				<PackagingType>
					<Code>02</Code>
				</PackagingType>
				<PackageWeight>
					<cfset weightlbs = arguments.requestBean.getTotalWeight( unitCode='lb' ) />
					<cfif weightlbs lt 1>
						<cfset weightlbs = 1 />
					</cfif>
					<Weight>#weightlbs#</Weight>
					<UnitOfMeasurement>
						<Code>LBS</Code>
					</UnitOfMeasurement>
				</PackageWeight>
			</Package>
		</Shipment>
	</RatingServiceSelectionRequest>
</cfoutput>
