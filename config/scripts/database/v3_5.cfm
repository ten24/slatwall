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

<cfset local.scriptHasErrors = false />

<!--- Update SwAttribute to move attributeTypeID to attributeType --->
<cftry>
	
	<cfdbinfo type="Columns" name="local.attributeColumns" table="SwAttribute" datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			*
		FROM
			attributeColumns
		WHERE
			LOWER(COLUMN_NAME) = 'attributetypeid'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'checkbox' WHERE attributeTypeID = '444df2aaed92cb33d16a83d2bde93e72'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'checkBoxGroup' WHERE attributeTypeID = '444df2d2bd86e1f290c2cce99d5ca2d8'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'date' WHERE attributeTypeID = '444df2d3c0420d6b13d2baf2a0c7e1f2'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'dateTime' WHERE attributeTypeID = '444df2d4cad3af5f4465a21f7d1b5f6c'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'multiselect' WHERE attributeTypeID = '444df2d5973447a85033d6c6735e002a'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'password' WHERE attributeTypeID = '444df2d6ff67aedc177f35d1e672dd82'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'radioGroup' WHERE attributeTypeID = '444df2a9fe732d3ec9d8b495ab1dddf7'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'relatedObjectSelect' WHERE attributeTypeID = '8fac11726ecc439f99e41452a12813f9'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'relatedObjectMultiselect' WHERE attributeTypeID = '3abffdd9710f4643bf9f527807851c45'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'select' WHERE attributeTypeID = '444df2a8bfb73ecb3a777c8599950d5f'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'text' WHERE attributeTypeID = '444df2a5a9088e72342c0b5eaf731c64'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'textArea' WHERE attributeTypeID = '444df2a60dbf45cfad1b1b96baa44c47'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'time' WHERE attributeTypeID = '444df2d7dddd6c7549632a58d2887bd0'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'wysiwyg' WHERE attributeTypeID = '444df2a7a2c39796d2b15516840344ea'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttribute SET attributeInputType = 'yesNo' WHERE attributeTypeID = '444df2d8eb236c42dbbef7ea66200f1b'
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update attribute to move attributeTypeID to attributeInputType">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
	
</cftry>


<!--- Update SwAttributeSet to move attributeSetTypeID to attributeSetType --->
<cftry>
	
	<cfdbinfo type="Columns" name="local.attributeSetColumns" table="SwAttributeSet" datasource="#getApplicationValue("datasource")#" username="#getApplicationValue("datasourceUsername")#" password="#getApplicationValue("datasourcePassword")#" />
	
	<cfquery name="local.hasColumn" dbtype="query">
		SELECT
			*
		FROM
			attributeSetColumns
		WHERE
			LOWER(COLUMN_NAME) = 'attributesettypeid'
	</cfquery>
	
	<cfif local.hasColumn.recordCount>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Account' WHERE attributeSetTypeID = '444df2a3ebb07d6280c339a09c0d90d3'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'AccountPayment' WHERE attributeSetTypeID = '444df32b9730e4a50af0c0ecb9d77f3b'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Brand' WHERE attributeSetTypeID = '444df325adea07a73014e74b449eb315'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Image' WHERE attributeSetTypeID = 'c546d8f4f4a7cecacce568e94f04a30f'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'File' WHERE attributeSetTypeID = '2de85a7daab45eaa8ccd31a2c32ac370'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Location' WHERE attributeSetTypeID = '5accbfaceca4d70a228b27cc61b0986a'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'LocationConfiguration' WHERE attributeSetTypeID = '5accbfb1e1a2a2dfd8dc4136631d68f0'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Order' WHERE attributeSetTypeID = '444df327c72a5bd51bb2f691aac17008'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'OrderItem' WHERE attributeSetTypeID = '444df292eea355ddad72f5614726bc75'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'OrderPayment' WHERE attributeSetTypeID = '444df32ac631b198a0f0319dd64e0e00'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'OrderFulfillment' WHERE attributeSetTypeID = 'e7387e124cc04bf9bb93fdb27000b4c2'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'OrderDelivery' WHERE attributeSetTypeID = 'ccee02635c2e443d8ff4f3f33702e4a3'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Product' WHERE attributeSetTypeID = '444df293fcc530434949d63e408cac2b'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'ProductType' WHERE attributeSetTypeID = '5accbf52063a5b4e2a73f19f4151cc40'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'ProductReview' WHERE attributeSetTypeID = '8787a242042db3b43f08144fa3100668'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Sku' WHERE attributeSetTypeID = '444df328fa718364a389a4495f386a27'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'SubscriptionBenefit' WHERE attributeSetTypeID = '5accbf5a08b1fc0f12fa654ea0c0b683'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'Vendor' WHERE attributeSetTypeID = '444df326c87e098e420297b5a1691e69'
		</cfquery>
		<cfquery name="local.updateData">
			UPDATE SwAttributeSet SET attributeSetObject = 'VendorOrder' WHERE attributeSetTypeID = '444df329d293eeec641b805b68cca95f'
		</cfquery>
	</cfif>
	
	<cfcatch>
		<cflog file="Slatwall" text="ERROR UPDATE SCRIPT - Update attributeSet to move attributeSetTypeID to attributeSetObject">
		<cfset local.scriptHasErrors = true />
	</cfcatch>
	
</cftry>

<cfif local.scriptHasErrors>
	<cflog file="Slatwall" text="General Log - Part of Script v3_5 had errors when running">
	<cfthrow detail="Part of Script v3_5 had errors when running">
<cfelse>
	<cflog file="Slatwall" text="General Log - Script v3_5 has run with no errors">
</cfif>