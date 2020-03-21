<cfcomponent extends="Slatwall.model.dao.AccountDAO">

	<cffunction name="removeStalePaymentProviderTokens" returntype="void" access="public">
		<cfargument name="providerTokens" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			UPDATE 
				swAccountPaymentMethod
			SET 
				providerToken = CONCAT('DELETED-', providerToken), 
				activeFlag = 0
			WHERE 
				providerToken IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokens#" list="true" /> )
		</cfquery>
		
		<cfquery name="rs">
			UPDATE 
				swOrderPayment
			SET 
				providerToken = CONCAT('DELETED-', providerToken)
			WHERE 
				providerToken IN ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.providerTokens#" list="true" /> )
		</cfquery>
		
	</cffunction>
	
	
	<cffunction name="getEligibleMarketPartner" access="public">
		<cfargument name="zipcode" /> 
		<cfargument name="maxRadius" default = "500" /> 
		<cfargument name="step" default = "50" /> 
		
		<cfquery name="local.coordenatesByZipcode" maxrows="1">
			SELECT LAT, LNG FROM zipusa WHERE ZIP_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Left(arguments.zipcode,5)#" />
		</cfquery>

		<cfif local.coordenatesByZipcode.recordCount EQ 0>
			<cfreturn '' />
		</cfif>
		
		<cfloop index="local.currentRadius" from="#arguments.step#" to="#arguments.maxRadius#" step="#arguments.step#">
			<cfquery name="local.Zipcodes" maxrows="1">
				SELECT GROUP_CONCAT(zips.ZIP_CODE) zipcodeList FROM (
					SELECT 
						ZIP_CODE, ( 
							3959 * 
							acos( cos( radians(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.coordenatesByZipcode.LAT#" />) ) * 
							cos( radians( LAT ) ) * 
							cos( radians( LNG ) - 
							radians(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.coordenatesByZipcode.LNG#" />) ) + 
							sin( radians(<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.coordenatesByZipcode.LAT#" />) ) * 
							sin( radians( LAT ) ) ) 
						) distance
					FROM zipusa
					
					HAVING distance > <cfqueryparam cfsqltype="cf_sql_integer" value="#local.currentRadius - arguments.step#" />  AND distance <= <cfqueryparam cfsqltype="cf_sql_integer" value="#local.currentRadius#" />
					ORDER BY distance ASC
				) zips;
			</cfquery>
			
			<cfif local.Zipcodes.recordCount EQ 1>
			
				<cfquery name="local.marketPartnerByDistance" maxrows="1">
					SELECT 
						acc.accountID,
						count(al.accountID) leads 
					FROM 
						swAccount acc
					INNER JOIN swAccountAddress aa ON acc.primaryAddressID = aa.accountAddressID
					INNER JOIN swAddress a ON a.addressID = aa.addressID
					LEFT JOIN swAccountLead al ON acc.accountID = al.accountID
					WHERE 
						acc.accountType = 'marketPartner' AND
						acc.activeFlag = 1 AND
						acc.accountStatusTypeID = '2c9180836dacb117016dad11ebf2000e' AND
						acc.rank >= 7 AND 
						a.postalCode IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#local.Zipcodes.zipcodeList#" list="true" />)
					GROUP BY 
						acc.accountID
					ORDER BY 
						leads ASC
					LIMIT 1
				</cfquery>
				
				<cfif local.marketPartnerByDistance.recordCount GT 0>
					<cfreturn local.marketPartnerByDistance.accountID />
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn '' />
		
	</cffunction>
	
	
	
</cfcomponent>