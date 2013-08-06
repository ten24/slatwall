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
<cfcomponent extends="HibachiDAO">
	<cffunction name="getPhysicalDiscrepancyQuery">
		<cfargument name="physicalID" type="string" required="true">
		
		<cfset rs = "" />
		
		<cfquery name="rs">
			SELECT
				SlatwallStock.stockID,
				SlatwallSku.skuID,
				SlatwallSku.skuCode,
				SlatwallLocation.locationID,
				SlatwallLocation.locationName,
				SlatwallProduct.productName,
				SlatwallProduct.productID,
				(SELECT
					COALESCE(SUM(i.quantityIn),0) - COALESCE(SUM(i.quantityOut),0)
				FROM
				  	SlatwallStock as a
				  LEFT JOIN
				    SlatwallInventory i on a.stockID = i.stockID
				WHERE
				  	a.stockID = SlatwallStock.stockID
				) as 'Qoh',
				(SELECT
					(SELECT
						COALESCE(SUM(i.quantityIn),0) - COALESCE(SUM(i.quantityOut),0)
					FROM
				  		SlatwallStock as a
					  LEFT JOIN
					    SlatwallInventory i on a.stockID = i.stockID
					WHERE
					  	a.stockID = SlatwallStock.stockID
					  AND (
					  	  (max(pci.countPostDateTime) is not null and i.createdDateTime < max(pci.countPostDateTime)) 
						OR
						  (max(pci.countPostDateTime) is null and max(pc.countPostDateTime) is not null and i.createdDateTime < max(pc.countPostDateTime))
						OR
						  (max(pc.countPostDateTime) is null)
					  )
					) -
					COALESCE(SUM(pci.quantity),0)
				FROM
					SlatwallPhysicalCountItem pci
				  INNER JOIN
				  	SlatwallPhysicalCount pc on pci.physicalCountID = pc.physicalCountID
				WHERE
					pci.stockID = SlatwallStock.stockID
				  AND
				  	pc.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />
				) * -1 as 'discrepancy'
			FROM
				SlatwallStock
			  INNER JOIN
			  	SlatwallLocation on SlatwallStock.locationID = SlatwallLocation.locationID
			  INNER JOIN
				SlatwallSku on SlatwallStock.skuID = SlatwallSku.skuID
			  INNER JOIN
			  	SlatwallProduct on SlatwallSku.productID = SlatwallProduct.productID
			  INNER JOIN
			  	SlatwallProductType on SlatwallProduct.productTypeID = SlatwallProductType.productTypeID
			  LEFT JOIN
			  	SlatwallBrand on SlatwallProduct.brandID = SlatwallBrand.brandID
			WHERE
			  <!--- Only get Stock that is supposed to be counted --->
			  (
			  		EXISTS(SELECT SlatwallPhysicalLocation.locationID FROM SlatwallPhysicalLocation WHERE SlatwallPhysicalLocation.locationID = SlatwallLocation.locationID AND SlatwallPhysicalLocation.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" /> )
			  ) AND (
			    	EXISTS(SELECT SlatwallPhysicalSku.skuID FROM SlatwallPhysicalSku WHERE SlatwallPhysicalSku.skuID=SlatwallSku.skuID AND SlatwallPhysicalSku.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />)
				  OR
				  	EXISTS(SELECT SlatwallPhysicalProduct.productID FROM SlatwallPhysicalProduct WHERE SlatwallPhysicalProduct.productID=SlatwallProduct.productID AND SlatwallPhysicalProduct.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />)
				  OR
				  	EXISTS(SELECT SlatwallPhysicalProductType.productTypeID FROM SlatwallPhysicalProductType WHERE SlatwallProductType.productTypeIDPath LIKE <cfif getApplicationValue("databaseType") eq "MySQL">concat('%', SlatwallPhysicalProductType.productTypeID, '%')<cfelse>('%' + SlatwallPhysicalProductType.productTypeID + '%')</cfif> AND SlatwallPhysicalProductType.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />)
				  OR
				  	EXISTS(SELECT SlatwallPhysicalBrand.brandID FROM SlatwallPhysicalBrand WHERE SlatwallPhysicalBrand.brandID=SlatwallBrand.brandID AND SlatwallPhysicalBrand.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />)
			
			  <!--- Verify Discrepancy <> 0 --->		  
			  ) AND (SELECT
						(SELECT
							COALESCE(SUM(i.quantityIn),0) - COALESCE(SUM(i.quantityOut),0)
						FROM
					  		SlatwallStock as a
						  LEFT JOIN
						    SlatwallInventory i on a.stockID = i.stockID
						WHERE
						  	a.stockID = SlatwallStock.stockID
						  AND (
						  	  (max(pci.countPostDateTime) is not null and i.createdDateTime < max(pci.countPostDateTime)) 
							OR
							  (max(pci.countPostDateTime) is null and max(pc.countPostDateTime) is not null and i.createdDateTime < max(pc.countPostDateTime))
							OR
							  (max(pc.countPostDateTime) is null)
						  )
						) -
						COALESCE(SUM(pci.quantity),0)
					FROM
						SlatwallPhysicalCountItem pci
					  INNER JOIN
					  	SlatwallPhysicalCount pc on pci.physicalCountID = pc.physicalCountID
					WHERE
						pci.stockID = SlatwallStock.stockID
					  AND
					  	pc.physicalID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.physicalID#" />
					) <> 0
			ORDER BY
				SlatwallProductType.productTypeName,
				SlatwallProduct.productName,
				SlatwallSku.skuCode
		</cfquery>
		
		<cfreturn rs />
	</cffunction>
</cfcomponent>

