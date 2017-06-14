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
<cfcomponent extends="HibachiDAO" output="false">
	
	<cffunction name="getRelatedCommentsForEntity" returntype="Array" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		<cfargument name="publicFlag" type="boolean" required="false" />

		<cftry>
			<cfset var hqlParams = [arguments.primaryIDValue] />
			
			<cfset var hql="SELECT NEW MAP(
				scr.commentRelationshipID as commentRelationshipID,
				scr.referencedRelationshipFlag as referencedRelationshipFlag,
				scr.referencedExpressionStart as referencedExpressionStart,
				scr.referencedExpressionEnd as referencedExpressionEnd,
				scr.referencedExpressionEntity as referencedExpressionEntity,
				scr.referencedExpressionProperty as referencedExpressionProperty,
				scr.referencedExpressionValue as referencedExpressionValue,
				c as comment
			)
			FROM
				SlatwallCommentRelationship scr 
			INNER JOIN 
				scr.comment c
			WHERE 
				scr.#left(arguments.primaryIDPropertyName,len(arguments.primaryIDPropertyName)-2)#.#arguments.primaryIDPropertyName# = ?">

			<cfif structKeyExists(arguments, "publicFlag")>
				<cfset hql =hql & " and c.publicFlag=?">
				<cfset arrayAppend(hqlParams, arguments.publicFlag) />
			</cfif>
			
			<cfset hql=hql & " ORDER BY c.createdDateTime ASC" >

			<cfset var results = ormExecuteQuery(hql, hqlParams) />
			<cfcatch>
				<cfthrow message="You have tried to get comments for an entity that does not have a comment relationship setup.  The primaryID column for the entity requesting is #arguments.primaryIDPropertyName# and you may just need to add a Many-To-One property for this entity to CommentRelationship.cfc" />
			</cfcatch>
		</cftry>
		
		<cfreturn results /> 
	</cffunction>
	
	
	<cffunction name="deleteAllRelatedComments" returntype="boolean" access="public">
		<cfargument name="primaryIDPropertyName" type="string" required="true" />
		<cfargument name="primaryIDValue" type="string" required="true" />
		
		<cfset var relatedComments = getRelatedCommentsForEntity(argumentcollection=arguments) />
		<cfset var relatedComment = "" />
		
		<cfloop array="#relatedComments#" index="local.relatedComment" >
			<cfset var results = ormExecuteQuery("DELETE SlatwallCommentRelationship WHERE commentRelationshipID = ?", [relatedComment["commentRelationshipID"]]) />
			
			<cfif not relatedComment["referencedRelationshipFlag"]>
				<cfset var results = ormExecuteQuery("DELETE SlatwallComment WHERE commentID = ?", [relatedComment["comment"].getCommentID()]) />
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>
