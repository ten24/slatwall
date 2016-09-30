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
<cfsilent>
	<cfset local.pounds = 0 />
	<!--- minimum 2 ounce shipping weight required to ship --->
	<cfset local.ounces = max(round(arguments.requestBean.getTotalWeight( unitCode="oz" )),2)>
	<cfif local.ounces gt 16>
		<cfset local.pounds = round(local.ounces / 16) />
		<cfset local.ounces = local.ounces - (local.pounds * 16) />
	<cfelseif local.ounces lte 1>
		<cfset local.ounces = 0 />
	</cfif>
</cfsilent>
<cfoutput>
<IntlRateV2Request USERID="#setting('userID')#">
	<Revision>2</Revision>
	<Package ID="1">
		<Pounds>#local.pounds#</Pounds>
		<Ounces>#local.ounces#</Ounces>
		<Machinable>true</Machinable>
		<MailType>Package</MailType>
		<GXG>
			<POBoxFlag>N</POBoxFlag>
			<GiftFlag>N</GiftFlag>
		</GXG>
		<ValueOfContents>#arguments.requestBean.getTotalValue()#</ValueOfContents> 
		<Country>#arguments.requestBean.getShipToCountry()#</Country>
		<Container>RECTANGULAR</Container>
		<Size>LARGE</Size>
		<Width>20</Width>
		<Length>20</Length>
		<Height>20</Height>
		<Girth>80</Girth> 
		<OriginZip>#setting('shipFromPostalCode')#</OriginZip>
	</Package>
</IntlRateV2Request>
</cfoutput>

