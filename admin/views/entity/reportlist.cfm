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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />

<cfparam name="rc['#rc.entityActionDetails.itemEntityName#SmartList']" type="any" />

<cfif structKeyExists(rc,'collectionID')>
    <cfset rc['#rc.entityActionDetails.itemEntityName#CollectionList'] = getHibachiScope().getService('HibachiCollectionService').getCollection(rc.collectionID)/>
    <cfset rc.pageTitle &= ' - #rc['#rc.entityActionDetails.itemEntityName#CollectionList'].getCollectionName()#'/>
    <cfset rc.collection = getHibachiScope().getService('hibachiCollectionService').getCollection(rc.collectionID)/>
<cfelse>
    <cfset rc['#rc.entityActionDetails.itemEntityName#CollectionList'] = getHibachiScope().getService('HibachiCollectionService').getCollectionReportList('#rc.entityActionDetails.itemEntityName#')/>
    <cfset rc['#rc.entityActionDetails.itemEntityName#CollectionList'].setReportFlag(1)/>
    <cfset rc['#rc.entityActionDetails.itemEntityName#CollectionList'].setDistinct(1)/>
    <cfset rc.collection = getHibachiScope().getService('hibachiCollectionService').newCollection()/>
</cfif>    
<hb:HibachiEntityDetailForm object="#rc.collection#" edit="true">
    <hb:HibachiEntityActionBar type="reportlisting" object="#rc['#rc.entityActionDetails.itemEntityName#SmartList']#" collectionEntity="#rc.collection#" 
        deleteAction="entity.deleteCollection" deleteQueryString="sRedirectAction=entity.reportlist#lcase(rc.collection.getCollectionObject())#"
    >
    	<!--- Create ---> 
    	    <cfif structKeyExists(rc,'collection')>
    	        <cfif !rc.collection.isNew()>
        		    <hb:HibachiProcessCaller action="admin:entity.processcollection" entity="#rc.collection#" processContext="clearCache"  type="list" />
        		    <hb:HibachiProcessCaller action="admin:entity.preprocesscollection" entity="#rc.collection#" processContext="clone" type="list" />
        		    <hb:HibachiProcessCaller action="admin:entity.preprocesscollection" entity="#rc.collection#" processContext="rename" type="list" modal="true" />
        	    </cfif>
    	    </cfif>
    </hb:HibachiEntityActionBar>
</hb:HibachiEntityDetailForm>
<hb:HibachiListingDisplay 
	collectionList="#rc['#rc.entityActionDetails.itemEntityName#CollectionList']#"
	usingPersonalCollection="false"
	reportAction="admin:entity.reportlist#lcase(rc['#rc.entityActionDetails.itemEntityName#CollectionList'].getCollectionObject())#"
	showReport="true"
>
</hb:HibachiListingDisplay>
<!---
<hb:HibachiListingDisplay smartList="#rc.workflowSmartList#"
						   recordDetailAction="admin:entity.detailworkflow"
						   recordEditAction="admin:entity.editworkflow"
						   recordDeleteAction="admin:entity.deleteworkflow">
	
	<hb:HibachiListingColumn propertyIdentifier="workflowName" />
	<hb:HibachiListingColumn propertyIdentifier="activeFlag" />
	<hb:HibachiListingColumn propertyIdentifier="workflowObject" />
</hb:HibachiListingDisplay>
  --->