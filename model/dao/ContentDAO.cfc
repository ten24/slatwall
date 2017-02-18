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
	
	<cffunction name="getContentByCMSContentIDAndCMSSiteID" access="public">
		<cfargument name="cmsContentID" type="string" required="true">
		<cfargument name="cmsSiteID" type="string" required="true">
		
		<cfset var contents = ormExecuteQuery(" FROM SlatwallContent c WHERE c.cmsContentID = ? AND c.site.cmsSiteID = ?", [ arguments.cmsContentID, arguments.cmsSiteID ] ) />
		
		<cfif arrayLen(contents)>
			<cfreturn contents[1] />
		</cfif>
		
		<cfreturn entityNew("SlatwallContent") />
	</cffunction>
	
	<cffunction name="getContentDescendants" access="public" >
		<cfargument name="content" type="any" required="true">
		<cfreturn ORMExecuteQuery(
			'Select contentID From #getApplicationKey()#Content 
			where site=:site 
			and urlTitlePath <> :urlTitlePath 
			and urlTitlePath like :urlTitlePathLike',
			{
				site=arguments.content.getSite(),
				urlTitlePath=arguments.content.getURLTitlePath(),
				urlTitlePathLike=arguments.content.getUrlTitlePath() & '%'
			}
		)>
	</cffunction>
	<!--- when deleting content make top level children attach to this categories parent and then delete the category --->
	<cffunction name="deleteCategoryByCmsCategoryID" access="public">
		<cfargument name="cmsCategoryID" type="string"/>
		<cfquery name="local.getSlatwallCategoryID" result="local.getSlatwallCategoryIDResult">
			SELECT categoryID, parentCategoryID FROM SwCategory where cmsCategoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.cmsCategoryID#" /> 
		</cfquery>		
		
		<cfif local.getSlatwallCategoryIDResult.recordCount>
			
			<cfquery name="local.getTopLevelChildCategories" result="local.getTopLevelChildCategoriesResult">
				SELECT categoryID FROM SwCategory where parentCategoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getSlatwallCategoryID.categoryID#" /> 
			</cfquery>
			
			<cfif local.getTopLevelChildCategoriesResult.recordCount>
				<cfloop query="local.getTopLevelChildCategories">
					<cfif len(local.getSlatwallCategoryID.parentCategoryID)>
						<cfquery name="local.updateTopLevelChildCategories">
							Update SwCategory 
							Set parentCategoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getSlatwallCategoryID.parentCategoryID#" />
							Where categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getTopLevelChildCategories.categoryID#" />
						</cfquery>
					<cfelse>
						<cfquery name="local.updateTopLevelChildCategories">
							Update SwCategory 
							Set parentCategoryID = null
							Where categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getTopLevelChildCategories.categoryID#" />
						</cfquery>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
		<cfquery name="local.removeCategoryFromContentAssociation">
			DELETE FROM SwContentCategory WHERE categoryID =<cfqueryparam  cfsqltype="cf_sql_varchar" value="#local.getSlatwallCategoryID.categoryID#" />
		</cfquery>
		<cfquery name="local.rs">
			DELETE FROM SwProductCategory WHERE categoryID = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#local.getSlatwallCategoryID.categoryID#" /> 
		</cfquery>
		<cfquery name="local.deleteCategory">
			DELETE FROM SwCategory where categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.getSlatwallCategoryID.categoryID#" />
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getContentBySiteIDAndUrlTitlePath" access="public">
		<cfargument name="siteID" type="string" required="true">
		<cfargument name="urlTitlePath" type="string" required="true">
		
		<cfreturn ormExecuteQuery(" FROM SlatwallContent c Where c.site.siteID = ? AND LOWER(c.urlTitlePath) = ?",[ arguments.siteID,lcase(arguments.urlTitlePath)],true)>
	</cffunction>
	
	<cffunction name="getCategoriesByCmsCategoryIDs" access="public">
		<cfargument name="CmsCategoryIDs" type="string" />
			
		<cfset var hql = " FROM SlatwallCategory sc
							WHERE sc.cmsCategoryID IN (:CmsCategoryIDs) " />
			
		<cfreturn ormExecuteQuery(hql, {CmsCategoryIDs=listToArray(arguments.CmsCategoryIDs)}) />
	</cffunction>
	
	<cffunction name="getDisplayTemplates" access="public">
		<cfargument name="templateType" type="string" />
		<cfargument name="siteID" type="string" />
		
		<cfif structKeyExists(arguments, "siteID")>
			<cfreturn ormExecuteQuery(" FROM SlatwallContent WHERE contentTemplateType.systemCode = ? AND site.siteID = ?", ["ctt#arguments.templateType#", arguments.siteID], false, {ignoreCase=true}) />
		</cfif>
		
		<cfreturn ormExecuteQuery(" FROM SlatwallContent WHERE contentTemplateType.systemCode = ?", ["ctt#arguments.templateType#"], false, {ignoreCase=true}) />
	</cffunction>
	
	<cffunction name="removeCategoryFromAssociation" access="public">
		<cfargument name="categoryIDPath" type="string" required="true" >
		
		<cfset var rs = "" />
		
		<cfquery name="local.getChildCategory">
			SELECT categoryID FROM SwCategory WHERE categoryIDPath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryIDPath#/%" /> order by LENGTH(categoryIDPath) desc 
		</cfquery>
		
		<cfloop query="local.getChildCategory">
			<cfquery name="local.removeCategoryFromContentAssociation">
				DELETE FROM SwContentCategory WHERE categoryID =<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getChildCategory.categoryID#" />
			</cfquery>
			<cfquery name="rs">
				DELETE FROM SwProductCategory WHERE categoryID = <cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getChildCategory.categoryID#" /> 
			</cfquery>
			
			<cfquery name="local.deleteparentcats">
				UPDATE SwCategory set parentCategoryID=NULL, siteID=NULL WHERE categoryID =<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getChildCategory.categoryID#" /> 
			</cfquery>
			<cfquery name="local.deletecat">
				DELETE FROM SwCategory WHERE categoryID = <cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getChildCategory.categoryID#" /> 
			</cfquery>
		</cfloop>
		
		<cfquery name="local.getCategory">
			SELECT categoryID FROM SwCategory WHERE categoryIDPath = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryIDPath#" /> 
		</cfquery>
		
		<cfquery name="local.removeCategoryFromContentAssociation">
			DELETE FROM SwContentCategory WHERE categoryID =<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getCategory.categoryID#" />
		</cfquery>
		<cfquery name="rs">
			DELETE FROM SwProductCategory WHERE categoryID = <cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getCategory.categoryID#" /> 
		</cfquery>
		
		<cfquery name="local.deleteparentcats">
			UPDATE SwCategory set parentCategoryID=NULL, siteID=NULL WHERE categoryID =<cfqueryparam list="true" cfsqltype="cf_sql_varchar" value="#local.getCategory.categoryID#" /> 
		</cfquery>
		
		
	</cffunction>
	
	<cffunction name="getDefaultContentBySite" access="public">
		<cfargument name="site" type="any" required="true">
		<cfreturn ORMExecuteQuery('FROM SlatwallContent Where site = :site AND parentContent IS NULL',{site=arguments.site},true)>
	</cffunction>
	
	<cffunction name="getContentByUrlTitlePathBySite" access="public">
		<cfargument name="site" type="any" required="true" />
		<cfargument name="urlTitlePath" type="any" />
		
		<cfif isNull(arguments.urlTitlePath)>
			<cfreturn ORMExecuteQuery("FROM SlatwallContent WHERE site = :site AND urlTitlePath IS Null",{site=arguments.site}, true) />
		<cfelse>
			<cfreturn ORMExecuteQuery("FROM SlatwallContent WHERE site = :site AND urlTitlePath = :urlTitlePath",{site=arguments.site,urlTitlePath=arguments.urlTitlePath}, true) />
		</cfif>
	</cffunction>
	
	<cffunction name="getMaxSortOrderByContent" access="public">
		<cfargument name="content" type="any" required="true" >
		<cfreturn ORMExecuteQuery(
			'SELECT DISTINCT COALESCE(max(sortOrder),0) as maxSortOrder FROM SlatwallContent 
			where site=:site 
			and parentContent=:parentContent
			and sortOrder is not null
			',
			{site=arguments.content.getSite(),parentContent=arguments.content.getParentContent()}
			,true
		)>
	</cffunction>
	
	<cffunction name="getContentBySortOrderMinAndMax">
		<cfargument name="content" type="any" required="true">
		<cfargument name="min" type="numeric" required="true">
		<cfargument name="max" type="numeric" required="true">
		<cfreturn ORMExecuteQuery(
			'FROM SlatwallContent 
			where site=:site 
			and parentContent=:parentContent
			and sortOrder Between #arguments.min# and #arguments.max#
			',
			{site=arguments.content.getSite(),parentContent=arguments.content.getParentContent()}
		)>
	</cffunction>
	
	<cffunction name="getChildContentsByDisplayInNavigation" type="array" access="public">
		<cfargument name="parentContent" type="any" required="true" />
		
		<cfreturn ORMExecuteQuery( 'FROM SlatwallContent 
									Where displayInNavigation = true 
									and activeFlag = true
									and parentContent = :parentContent
									order by sortOrder Asc'
									,{parentContent=arguments.parentContent}
								)/>
	</cffunction>
	<cfscript>
		public void function updateAllDescendantsUrlTitlePathByUrlTitle(required string contentIDs,required string previousURLTitlePath, required string newUrlTitlePath){
			arguments.contentIDs = listQualify(arguments.contentIDs,"'",",");
			ORMExecuteQuery("
				UPDATE SlatwallContent s
				SET urlTitlePath=REPLACE(s.urlTitlePath,'#arguments.previousURLTitlePath#','#arguments.newUrlTitlePath#') 
				Where s.contentID IN (#arguments.contentIDs#)"
			);
		}
		
		public void function updateAllDescendantsTitlePathByUrlTitle(required string contentIDs,required string previousTitlePath, required string newTitlePath){
			arguments.contentIDs = listQualify(arguments.contentIDs,"'",",");
			ORMExecuteQuery("UPDATE SlatwallContent s SET titlePath=REPLACE(s.titlePath,'#arguments.previousTitlePath#','#arguments.newTitlePath#') Where s.contentID IN (#arguments.contentIDs#) ");
		}
	</cfscript>
	
	<cffunction name="getCategoryByCMSCategoryIDAndCMSSiteID" access="public">
		<cfargument name="cmsCategoryID" type="string" required="true">
		<cfargument name="cmsSiteID" type="string" required="true">
		
		<cfset var contents = ormExecuteQuery(" FROM SlatwallCategory c WHERE c.cmsCategoryID = ? AND c.site.cmsSiteID = ?", [ arguments.cmsCategoryID, arguments.cmsSiteID ] ) />
		
		<cfif arrayLen(contents)>
			<cfreturn contents[1] />
		</cfif>
		
		<cfreturn entityNew("SlatwallCategory") />
	</cffunction>
	
</cfcomponent>
