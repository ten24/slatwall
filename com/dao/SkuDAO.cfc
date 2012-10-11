<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="BaseDAO">
	
	<cfproperty name="nextOptionGroupSortOrder" type="numeric" />
	
	<cfscript>	
	// returns product skus which matches ALL options (list of optionIDs) that are passed in
	public any function getSkusBySelectedOptions(required string selectedOptions, string productID) {
		var params = [];
		var hql = "select distinct sku from SlatwallSku as sku 
					inner join sku.options as opt 
					where 
					0 = 0 ";
		for(var i=1; i<=listLen(arguments.selectedOptions); i++) {
			var thisOptionID = listGetat(arguments.selectedOptions,i);
			hql &= "and exists (
						from SlatwallOption o
						join o.skus s where s.id = sku.id
						and o.optionID = ?
					) ";
			arrayAppend(params,thisOptionID);
		}
		// if product ID is passed in, limit query to the product
		if(structKeyExists(arguments,"productID")) {
			hql &= "and sku.product.id = ?";
			arrayAppend(params,arguments.productID);	
		}
		return ormExecuteQuery(hql,params);
	}
	
	public any function searchSkusByProductType(string term,string productTypeID) {
		var q = new Query();
		var sql = "select skuID,skuCode from SlatwallSku where skuCode like :code";
		q.addParam(name="code",value="%#arguments.term#%",cfsqltype="cf_sql_varchar");
		if(structKeyExists(arguments,"productTypeID") && trim(arguments.productTypeID) != "") {
			sql &= " and productID in (select productID from SlatwallProduct where productTypeID in (:productTypeIDs))";
			q.addParam(name="productTypeIDs", value="#arguments.productTypeID#", cfsqltype="cf_sql_varchar", list="true");
		}
		q.setSQL(sql);
		var records = q.execute().getResult();
		var result = [];
		for(var i=1;i<=records.recordCount;i++) {
			result[i] = {
				"id" = records.skuID[i],
				"value" = records.skuCode[i]
			};
		}
		return result;
	}
	
	public array function getProductSkus(required any product, required any fetchOptions) {
		
		var hql = "SELECT sku FROM SlatwallSku sku ";
		if(fetchOptions) {
			hql &= "INNER JOIN FETCH sku.options option ";	
		}
		var hql &= "WHERE sku.product.productID = :productID ";
		/*
		if(fetchOptions) {
			hql &= "ORDER BY option.optionGroup.sortOrder ";	
		}
		*/
		
		var skus = ORMExecuteQuery(hql,	{productID = arguments.product.getProductID()});
		
		return skus;
	}
	
	</cfscript>

	<cffunction name="getSortedProductSkusID">
		<cfargument name="productID" type="string" required="true" />
		
		<cfset var sorted = "" />
		
		<!--- TODO: test to see if this query works with DB's other than MSSQL and MySQL --->
		<cfquery name="sorted" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getUsername()#" password="#application.configBean.getPassword()#">
			SELECT
				SlatwallSku.skuID
			FROM
				SlatwallSku
			  INNER JOIN
				SlatwallSkuOption on SlatwallSku.skuID = SlatwallSkuOption.skuID
			  INNER JOIN
				SlatwallOption on SlatwallSkuOption.optionID = SlatwallOption.optionID
			  INNER JOIN
				SlatwallOptionGroup on SlatwallOption.optionGroupID = SlatwallOptionGroup.optionGroupID
			WHERE
				SlatwallSku.productID = <cfqueryparam value="#arguments.productID#" cfsqltype="cf_sql_varchar" />
			GROUP BY
				SlatwallSku.skuID
			ORDER BY
				<cfif application.configBean.getDBType() eq "mssql">
					SUM(SlatwallOption.sortOrder * POWER(CAST(10 as bigint), CAST((#getNextOptionGroupSortOrder()# - SlatwallOptionGroup.sortOrder) as bigint))) ASC
				<cfelse>
					SUM(SlatwallOption.sortOrder * POWER(10, #getNextOptionGroupSortOrder()# - SlatwallOptionGroup.sortOrder)) ASC
				</cfif>
		</cfquery>
		
		<cfreturn sorted />
	</cffunction>
	
	<cffunction name="getNextOptionGroupSortOrder" returntype="numeric" access="private">
		<cfif not structKeyExists(variables, "nextOptionGroupSortOrder")>
			<cfset variables.nextOptionGroupSortOrder = 1 />
			
			<cfset var rs = "" />
			
			<cfquery name="rs">
				SELECT max(SlatwallOptionGroup.sortOrder) as 'max' FROM SlatwallOptionGroup
			</cfquery>
			<cfif rs.recordCount>
				<cfset variables.nextOptionGroupSortOrder = rs.max + 1 />
			</cfif>
			
		</cfif>
		
		<cfreturn variables.nextOptionGroupSortOrder />
	</cffunction>
	
	<cffunction name="clearNextOptionGroupSortOrder" returntype="void" access="public">
		<cfif not structKeyExists(variables, "nextOptionGroupSortOrder")>
			<cfset structDelete(variables, "nextOptionGroupSortOrder") />
		</cfif>
	</cffunction>
	
</cfcomponent>