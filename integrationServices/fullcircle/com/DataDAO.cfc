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
<cfcomponent output="false" extends="Slatwall.model.dao.HibachiDAO">
	
	<cffunction name="updateProducts">
		
		<cfset var pickupDirectoryList = "" />
		<cfset var productFilename = "" />
		<cfset var productFileContents = "" />
		<cfset var productFile = "" />
		<cfset var rs = "" />
		<cfset var rs2 = "" />
		
		<cfset var integration = getService("integrationService").getIntegrationByIntegrationPackage("fullcircle") />
		
		<cfftp action="listdir" name="pickupDirectoryList" server="#integration.setting('fcFTPAddress')#" username="#integration.setting('fcFTPUsername')#" password="#integration.setting('fcFTPPassword')#" port="#integration.setting('fcFTPPort')#" directory="#integration.setting('fcFTPDirecotry')#/s/">
		
		<cfloop query="pickupDirectoryList">
			<cfif not pickupDirectoryList.isDirectory and left(pickupDirectoryList.name, len(integration.setting('companyCode')) + 1) eq "#integration.setting('companyCode')#_" and right(pickupDirectoryList.name, 12) eq "_product.txt">
				<cfset productFilename = pickupDirectoryList.name />
			</cfif>
		</cfloop>
		
		<!--- If A Product File was found --->
		<cfif len(productFilename)>
			
			<cfif not directoryExists(integration.setting('localTransferDirctory'))>
				<cfset directoryCreate(integration.setting('localTransferDirctory'))>
			</cfif>
			
			<cfftp action="getFile" server="#integration.setting('fcFTPAddress')#" username="#integration.setting('fcFTPUsername')#" password="#integration.setting('fcFTPPassword')#" port="#integration.setting('fcFTPPort')#" remotefile="#integration.setting('fcFTPDirecotry')#/s/#productFilename#" localfile="#integration.setting('localTransferDirctory')#/#productFilename#" failIfExists="no">
			
			<cfhttp method="get"
					url="#integration.setting('localTransferDirctory')#/#productFilename#"
					columns="CompanyNumber,UPCCode,ProductCode,Description,DivisionCode,DivisionDescription,ColorCode,ColorDesc,SizeType,Size,Price,Weight,LongDesc,TechnicalDesc,MiscOne"
					delimiter="#chr(9)#"
					firstrowasheaders="false"
					name="productData"
					username="#integration.setting('localTransferURLUsername')#"
					password="#integration.setting('localTransferURLPassword')#">
			
			<!--- Verify Size Option Groups Exist --->
			<cfset var sizeOptionGroupID = createSlatwallUUID() />
			
			<cfquery name="rs">
				SELECT optionGroupID FROM SwOptionGroup WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="S">
			</cfquery>
			<cfif rs.recordCount>
				<cfset sizeOptionGroupID = rs.optionGroupID />
			<cfelse>
				<cfquery name="rs">
					INSERT INTO SwOptionGroup (
						optionGroupID,
						optionGroupName,
						optionGroupCode,
						imageGroupFlag,
						remoteID
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#sizeOptionGroupID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Size">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Size">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="S">
					)
				</cfquery>
			</cfif>
			
			<!--- Verify Color Option Groups Exist --->
			<cfset var colorOptionGroupID = createSlatwallUUID() />
			<cfquery name="rs">
				SELECT optionGroupID FROM SwOptionGroup WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="C">
			</cfquery>
			<cfif rs.recordCount>
				<cfset colorOptionGroupID = rs.optionGroupID />
			<cfelse>
				<cfquery name="rs">
					INSERT INTO SwOptionGroup (
						optionGroupID,
						optionGroupName,
						optionGroupCode,
						imageGroupFlag,
						remoteID
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#colorOptionGroupID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Color">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="Color">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="C">
					)
				</cfquery>
			</cfif>
				
			<cfset var brandMappings = structNew() />
			<cfset var colorMappings = structNew() />
			<cfset var sizeMappings = structNew() />
			
			<cfloop query="productData">
				
				<cfquery name="rs" result="local.rsResult">
					UPDATE
						SwSku
					SET
						price = <cfqueryparam cfsqltype="cf_sql_money" value="#productData.Price#">,
						listPrice = <cfqueryparam cfsqltype="cf_sql_money" value="#productData.Price#">
					WHERE
						remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.UPCCode#">
				</cfquery>
				
				<!--- Sku Didn't Exist --->
				<cfif not rsResult.recordCount>
					
					<cfset var skuID = createSlatwallUUID() />
					
					<!--- Check if Product Exist --->
					<cfquery name="rs">
						SELECT productID FROM SwProduct WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ProductCode#">
					</cfquery>
					<!--- It Does --->
					<cfif rs.recordCount>
						<cfset var productID = rs.productID />
						
					<!--- It Doesn't --->
					<cfelse>
						<cfset var productID = createSlatwallUUID() />
						
						<!--- Get the brandID --->
						<cfif not structKeyExists(brandMappings, productData.DivisionCode)>
					
							<cfquery name="rs">
								SELECT brandID FROM SwBrand WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.DivisionCode#">
							</cfquery>
							
							<cfif rs.recordCount>
								<cfset brandMappings[ productData.DivisionCode ] = rs.brandID />
								
							<cfelse>
								<cfset brandMappings[ productData.DivisionCode ] = createSlatwallUUID() />
								
								<cfquery name="rs">
									INSERT INTO SwBrand (
										brandID,
										activeFlag,
										brandName,
										remoteID
									) VALUES (
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#brandMappings[ productData.DivisionCode ]#">,
										<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.DivisionDescription#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.DivisionCode#">
									)
								</cfquery>
								
							</cfif>
							
						</cfif>
						
						<!--- Insert Product --->
						<cfquery name="rs">
							INSERT INTO SwProduct (
								productID,
								activeFlag,
								brandID,
								productTypeID,
								productCode,
								productName,
								remoteID
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#brandMappings[ productData.DivisionCode ]#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="444df2f7ea9c87e60051f3cd87b435a1">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ProductCode#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.Description#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ProductCode#">
							)
						</cfquery>
								
					</cfif>
					
					<!--- Insert Sku --->
					<cfquery name="rs">
						INSERT INTO SwSku (
							skuID,
							skuCode,
							activeFlag,
							productID,
							price,
							listPrice,
							imageFile,
							remoteID
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#skuID#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.UPCCode#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#productData.Price#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#productData.Price#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ProductCode#_#productData.ColorCode#.jpg">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.UPCCode#">
						)
					</cfquery>
					
					<!--- Check for SizeID --->
					<cfif not structKeyExists(sizeMappings, productData.Size)>
					
						<cfquery name="rs">
							SELECT optionID FROM SwOption WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="S_#productData.Size#">
						</cfquery>
						
						<cfif rs.recordCount>
							<cfset sizeMappings[ productData.Size ] = rs.optionID />
							
						<cfelse>
							<cfset sizeMappings[ productData.Size ] = createSlatwallUUID() />
							
							<cfquery name="rs">
								INSERT INTO SwOption (
									optionID,
									optionGroupID,
									optionName,
									optionCode,
									remoteID
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#sizeMappings[ productData.Size ]#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#sizeOptionGroupID#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.Size#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.Size#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="S_#productData.Size#">
								)
							</cfquery>
							
						</cfif>
						
					</cfif>
					
					<!--- Check for ColorID --->
					<cfif not structKeyExists(colorMappings, productData.ColorCode)>
					
						<cfquery name="rs">
							SELECT optionID FROM SwOption WHERE remoteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="C_#productData.ColorCode#">
						</cfquery>
						
						<cfif rs.recordCount>
							<cfset colorMappings[ productData.ColorCode ] = rs.optionID />
							
						<cfelse>
							<cfset colorMappings[ productData.ColorCode ] = createSlatwallUUID() />
							
							<cfquery name="rs">
								INSERT INTO SwOption (
									optionID,
									optionGroupID,
									optionName,
									optionCode,
									remoteID
								) VALUES (
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#colorMappings[ productData.ColorCode ]#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#colorOptionGroupID#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ColorDesc#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#productData.ColorCode#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="C_#productData.ColorCode#">
								)
							</cfquery>
							
						</cfif>
						
					</cfif>
					
					<!--- Insert Sku Size --->
					<cfquery name="rs">
						INSERT INTO SwSkuOption (skuID, optionID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#skuID#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#sizeMappings[ productData.Size ]#">)
					</cfquery>
					<!--- Insert Sku Color --->
					<cfquery name="rs">
						INSERT INTO SwSkuOption (skuID, optionID) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#skuID#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#colorMappings[ productData.ColorCode ]#">)
					</cfquery>
					
					<!--- Update Products where defaultSkuID is null and productID is this productID --->
					<cfquery name="rs">
						UPDATE SwProduct SET defaultSkuID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#skuID#"> WHERE productID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#"> AND defaultSkuID IS NULL
					</cfquery>
					
				</cfif>
					
			</cfloop>
				
		</cfif>
		
	</cffunction>
</cfcomponent>
