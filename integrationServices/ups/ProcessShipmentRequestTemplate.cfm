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
<cfset local.orderPaymentCollectionList = getService('orderService').getOrderPaymentCollectionList() />
<cfset local.orderPaymentCollectionList.addFilter('order.orderID',arguments.requestBean.getOrder().getOrderID()) />
<cfset local.orderPaymentCollectionList.addFilter('purchaseOrderNumber','null','IS NOT') />
<cfset local.orderPaymentCollectionList.addFilter('orderPaymentStatusType.systemCode','opstActive','=') />
<cfset local.orderPaymentCollectionList.setDisplayProperties('purchaseOrderNumber') />
<cfset local.orderPayments = local.orderPaymentCollectionList.getRecords() />
<cfloop array="#local.orderPayments#" index="local.currentOrderPayment">
	<cfif len(local.currentOrderPayment['purchaseOrderNumber']) >
		<cfset local.orderPayment = local.currentOrderPayment />
	</cfif>
</cfloop>

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
    "TransactionReference":"#arguments.requestBean.getOrder().getOrderNumber()#",
    "Shipment":{
      "Service":{
        "Code":"#arguments.requestBean.getShippingIntegrationMethod()#"
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
        "AttentionName":"#arguments.requestBean.getShipToName()#",
        <cfif len(arguments.requestBean.getShipToCompany())>
    		  "Name":"#arguments.requestBean.getShipToCompany()#",
    		<cfelse>
    		  "Name":"#arguments.requestBean.getShipToName()#",
        </cfif>
        <cfif len(arguments.requestBean.getShipToPhoneNumber())>
	        "Phone":{
	    		"Number":"#arguments.requestBean.getShipToPhoneNumber()#"
	      	},
        </cfif>
        <cfif len(arguments.requestBean.getShipToEmailAddress())>
	    	"EmailAddress":"#arguments.requestBean.getShipToEmailAddress()#",
        </cfif>
        "Address":{
          <cfif NOT len(arguments.requestBean.getShipToStreet2Address())>
          "AddressLine":"#arguments.requestBean.getShipToStreetAddress()#",
          <cfelse>
          "AddressLine":["#arguments.requestBean.getShipToStreetAddress()#","#arguments.requestBean.getShipToStreet2Address()#"],
          </cfif>
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
        <cfif NOT isNull(arguments.requestBean.getThirdPartyShippingAccountIdentifier()) AND len(arguments.requestBean.getThirdPartyShippingAccountIdentifier())>
          "BillThirdParty":{
            "AccountNumber":"#arguments.requestBean.getThirdPartyShippingAccountIdentifier()#",
            "Address":{
            "AddressLine":"#arguments.requestBean.getShipToStreetAddress()#",
            "City":"#arguments.requestBean.getShipToCity()#",
            "StateProvinceCode":"#arguments.requestBean.getShipToStateCode()#",
            "PostalCode":"#arguments.requestBean.getShipToPostalCode()#",
            "CountryCode":"#arguments.requestBean.getShipToCountryCode()#",
            "ResidentialAddressIndicator":"1"
            }
          }
        <cfelse>
          "BillShipper":{
            "AccountNumber":"#setting('shipperNumber')#"
          }
        </cfif>
        }
      },
     <cfset local.totalWeight = arguments.requestBean.getTotalWeight( unitCode='lb' ) />
     <cfset local.packageCount = 0 />
     <cfif NOT isNull(arguments.requestBean.getContainers())>
      <cfset local.packageCount = arrayLen( arguments.requestBean.getContainers() ) />
     </cfif>
    		"Package":[
    		<cfif local.packageCount EQ 0 AND local.totalWeight gt 150 >
    			<cfset local.finalWeight = local.totalWeight MOD 150 />
    			<cfloop index="count" from="1" to="#round(abs(local.totalWeight / 150))#">
    				
    			  {
    			    "Packaging": { "Code": "02" },
    			    "PackageWeight": {
    			      "Weight": "150",
    			      "UnitOfMeasurement": { "Code": "LBS" }
    			    },
    			    "ReferenceNumber":[
                <cfif NOT isNull(arguments.requestBean.getReference1())>
                  {
                    "Code":"DP",
                    "Value":"#arguments.requestBean.getReference1()#"
                  },
                </cfif>
                {
                  "Code":"TN",
                  "Value":"#arguments.requestBean.getOrder().getOrderNumber()#"
                }
              ]
    			  }<cfif count LT round(abs(local.totalWeight / 150))>,</cfif>
    			</cfloop>
    			]
    		<cfelseif local.packageCount GT 0 >
    		  <cfset packageNumber = 0/>
    		  <cfloop array="#arguments.requestBean.getContainers()#" index="container">
    		    <cfset packageNumber++/>
    		    {
    			    "Packaging": { "Code": "02" },
    			    "PackageWeight": {
    			      "Weight": "#isNull(container.weight) ? local.totalWeight / local.packageCount : container.weight#",
    			      "UnitOfMeasurement": { "Code": "LBS" }
    			    },
    			    "ReferenceNumber":[
                <cfif NOT isNull(arguments.requestBean.getReference1())>
                  {
                    "Code":"DP",
                    "Value":"#arguments.requestBean.getReference1()#"
                  },
                </cfif>
                {
                  "Code":"TN",
                  "Value":"#arguments.requestBean.getOrder().getOrderNumber()#"
                }
              ]
    			  }<cfif packageNumber LT local.packageCount>
    			    ,
    			  <cfelse>
    			    ]
    			  </cfif>
    		  </cfloop>
    		<cfelse>
    			
    		  {
    		    "Packaging": { "Code": "02" },
      			"PackageWeight":{
      				<cfif arguments.requestBean.getTotalWeight( unitCode='lb' ) lt 1>
      					"Weight":"1",
      				<cfelse>
      					"Weight":"#arguments.requestBean.getTotalWeight( unitCode='lb' )#",	
      				</cfif>
      				"UnitOfMeasurement": { "Code": "LBS" }
      			  },
    			  "ReferenceNumber":[
              <cfif NOT isNull(arguments.requestBean.getReference1())>
                {
                  "Code":"DP",
                  "Value":"#arguments.requestBean.getReference1()#"
                },
              </cfif>
              {
                "Code":"TN",
                "Value":"#arguments.requestBean.getOrder().getOrderNumber()#"
              }
            ]
    		  }
    		]
    		</cfif>
    }
  }
  
}
</cfoutput>