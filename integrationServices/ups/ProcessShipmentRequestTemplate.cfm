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

<cfoutput >
{
  "UPSSecurity": {
    "ServiceAccessToken":{
    	"AccessLicenseNumber": "#setting('apiKey')#"
    },
    "UsernameToken":{
      "Username": "#setting('username')#",
      "Password": "#setting('password')#"
    }
    
  },
  "ShipmentRequest": {
    "Request":{
      "RequestOption":"validate"
    },
    "TransactionReference":"1111",
    "Shipment":{
      "Service":{
        "Code":"03"
      },
      "Shipper":{
    	"Name":"#setting('shipFromName')#",
    	<cfif len(setting('shipFromCompany'))>
    		"CompanyDisplayableName":"#setting('shipFromCompany')#",
    	</cfif>
    	<cfif len(setting('shipFromPhoneNumber'))>
        "Phone":{
    		"Number":"#setting('shipFromPhoneNumber')#"
      	},
    	</cfif>
    	<cfif len(setting('shipFromEmailAddress'))>
	    "EmailAddress":"#setting('shipFromEmailAddress')#",
    	</cfif>
        "Address": {
        	"AddressLine":"#setting('shipFromAddressLine')#",
            "City": "#setting('shipFromCity')#",
            "StateProvinceCode": "#setting('shipFromStateCode')#",
            "PostalCode": "#setting('shipFromPostalCode')#",
            "CountryCode": "#setting('shipFromCountryCode')#"
        },
        "ShipperNumber": "#setting('shipperNumber')#"
  	  },
      "ShipTo":{
        "Name":"#arguments.requestBean.getShipToName()#",
        <cfif len(arguments.requestBean.getShipToCompany())>
    		"CompanyDisplayableName":"#arguments.requestBean.getShipToCompany()#",
        </cfif>
        <cfif len(arguments.requestBean.getShipToPhoneNumber())>
	        "Phone":{
	    		"Number":"#arguments.requestBean.getShipToPhoneNumber()#"
	      	},
        </cfif>
        <cfif len(arguments.requestBean.getShipToEmailAddress())>
	    	"EmailAddress":"ryan.marchand@ten24web.com",
        </cfif>
        "Address":{
          "AddressLine":"#arguments.requestBean.getShipToStreetAddress()#",
          "City":"#arguments.requestBean.getShipToCity()#",
          "StateProvinceCode":"#arguments.requestBean.getShipToStateCode()#",
          "PostalCode":"#arguments.requestBean.getShipToPostalCode()#",
          "CountryCode":"#arguments.requestBean.getShipToCountryCode()#",
          "ResidentialAddressIndicator":"1"
        }
	  },
      "ShipFrom":{
        "Name":"#setting('shipFromName')#",
    	<cfif len(setting('shipFromCompany'))>
    		"CompanyDisplayableName":"#setting('shipFromCompany')#",
    	</cfif>
    	<cfif len(setting('shipFromPhoneNumber'))>
        "Phone":{
    		"Number":"#setting('shipFromPhoneNumber')#"
      	},
    	</cfif>
    	<cfif len(setting('shipFromEmailAddress'))>
	    "EmailAddress":"#setting('shipFromEmailAddress')#",
    	</cfif>
        "Address": {
        	"AddressLine":"#setting('shipFromAddressLine')#",
            "City": "#setting('shipFromCity')#",
            "StateProvinceCode": "#setting('shipFromStateCode')#",
            "PostalCode": "#setting('shipFromPostalCode')#",
            "CountryCode": "#setting('shipFromCountryCode')#"
        }
	  },
  	  "PaymentInformation":{
        "ShipmentCharge":{
          "Type":"01",
          "BillShipper":{
            "AccountNumber":"#setting('shipperNumber')#"
          }
        }
      },
        <cfset local.totalWeight = arguments.requestBean.getTotalWeight( unitCode='lb' )>
		<cfif local.totalWeight gt 150>
			<cfset local.finalWeight = local.totalWeight MOD 150>
			<cfloop index="count" from="1" to="#round(abs(local.totalWeight / 150))#">
				
			  "Package": {
			    "PackagingType": { "Code": "02" },
			    "PackageWeight": {
			      "Weight": "150",
			      "UnitOfMeasurement": { "Code": "LBS" }
			    }
			  }
					
			</cfloop>
			<cfif local.finalWeight gt 0>
				
			  "Package": {
			    "PackagingType": { "Code": "02" },
				"PackageWeight": {
					<cfif local.finalWeight lt 1>
						"Weight":"1",
					<cfelse>
						"Weight":"#local.finalWeight#",
					</cfif>
					"UnitOfMeasurement": { "Code": "LBS" }
				}
							
			</cfif>
		<cfelse>
			
		  "Package": {
		    "PackagingType": { "Code": "02" },
			"PackageWeight":{
				<cfif arguments.requestBean.getTotalWeight( unitCode='lb' ) lt 1>
					"Weight":"1",
				<cfelse>
					"Weight":"#arguments.requestBean.getTotalWeight( unitCode='lb' )#",	
				</cfif>
				"UnitOfMeasurement": { "Code": "LBS" }
			},
			"Packaging":{
	          "Code":"02"
	          <!--- TODO:implement containers with dimensions
	          	"Dimensions":{
	            "UnitOfMeasurement":{
	              "Code":"01"
	            },
	            "Length":"1",
	            "Width":"1",
	            "Height":"1"
	            
	          }--->
	        }
		  }
			
		</cfif>
    }
  }
  
}
</cfoutput>

