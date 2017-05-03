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
<cfcomponent output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiUtilityService">

	<cfproperty name="settingService" type="any" />

	<cfscript>
		
		public any function formatValue_currency( required string value, struct formatDetails={} ) {
			if(structKeyExists(arguments.formatDetails, "currencyCode")) {
				var currency = getService("currencyService").getCurrency( arguments.formatDetails.currencyCode );
				if(!isNull(currency)){
					return currency.getCurrencySymbol() & LSNumberFormat(arguments.value, ',.__');
				}
			}

			// Otherwsie use the global currencyLocal
			return LSCurrencyFormat(arguments.value, getSettingService().getSettingValue("globalCurrencyType"), getSettingService().getSettingValue("globalCurrencyLocale"));
		}

		public any function formatValue_datetime( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, getSettingService().getSettingValue("globalDateFormat")) & " " & TimeFormat(value, getSettingService().getSettingValue("globalTimeFormat"));
		}

		public any function formatValue_date( required string value, struct formatDetails={} ) {
			return dateFormat(arguments.value, getSettingService().getSettingValue("globalDateFormat"));
		}

		public any function formatValue_time( required string value, struct formatDetails={} ) {
			return timeFormat(arguments.value, getSettingService().getSettingValue("globalTimeFormat"));
		}

		public any function formatValue_weight( required string value, struct formatDetails={} ) {
			return arguments.value & " " & getSettingService().getSettingValue("globalWeightUnitCode");
		}

		private string function getEncryptionKeyLocation() {
			var keyLocation = getSettingService().getSettingValue("globalEncryptionKeyLocation");
			if(len(keyLocation)) {
				if(right(keyLocation, 1) eq '/' or right(keyLocation, 1) eq '\') {
					return keyLocation;
				}

				return keyLocation & '/';
			}
			return expandPath('/#getApplicationValue('applicationKey')#/custom/config/');
		}

		public string function getLegacyEncryptionAlgorithm() {
			return getSettingService().getSettingValue("globalEncryptionAlgorithm");
		}

		public string function getLegacyEncryptionEncoding() {
			return getSettingService().getSettingValue("globalEncryptionEncoding");
		}

		public string function getLegacyEncryptionKeySize() {
			return getSettingService().getSettingValue("globalEncryptionKeySize");
		}

	</cfscript>
	<!---
	QueryTreeSort takes a query and efficiently (O(n)) resorts it hierarchically (parent-child), adding a Depth column that can then be used when displaying the data.

	@return Returns a query.
	@author Rick Osborne (deliver8r@gmail.com)
	@version 1, April 9, 2007
	@ http://cflib.org/udf/queryTreeSort
	@ modified by Tony Garcia September 27, 2007
	--->
	<cffunction name="queryTreeSort" access="public" output="false" returntype="query">
		<cfargument name="theQuery" type="query" required="true" hint="the query to sort" />
		<cfargument name="ParentID" type="string" default="ParentID" hint="the name of the column in the table containing the ID of the item's parent" />
		<cfargument name="ItemID" type="string" default="ItemID" hint="the name of the column in the table containing the item's ID (primary key)" />
		<cfargument name="rootID" type="string" default="0" hint="the ID of the item to use as the root, defaults to the tree root" />
		<cfargument name="levels" type="numeric" default="0" hint="how many levels to return, defaults to all levels when set to 0" />
		<cfargument name="BaseDepth" type="numeric" default="0" hint="the number to use as the base depth" />
		<cfargument name="PathColumn" type="string" default="" hint="the name of the column containing the values to use to build paths to the items in the tree" />
        <cfargument name="PathDelimiter" type="string" default="," />

		<cfset var RowFromID=StructNew() /> <!--- indexing structure that contains the query row for each ID key --->
		<cfset var ChildrenFromID=StructNew() /> <!--- indexing struct that contains an array of children ID for each ID key --->
		<cfset var RootItems=ArrayNew(1) /> <!--- an array of root items (items that don't have parents --->
		<cfset var Depth=ArrayNew(1) /> <!--- an array that keeps track of the depth of each sorted item --->
		<cfset var Order=ArrayNew(1) /> <!--- array that keeps track of the generated order of items within each parent when the tree is sorted (can be used to "clean" the order) --->
		<cfset var ThisID=0 />
		<cfset var ThisDepth=0 />
		<cfset var ThisOrder=0 />
		<cfset var RootOrder=1 /> <!--- keeps track of the order of the root items in the Order array, used to build the order array --->
		<cfset var RowID=0 />
		<cfset var ChildrenIDs="" />
        <cfset var NewRowFromID=StructNew() />
        <cfset var Lineages=StructNew() />
        <cfset var ThisLineage="" />
        <cfset var ThisParentRowID="" />
		<cfset var thisPath = "" />
		<cfset var thisIDPath = "" />
		<cfset var i ="" />
		<cfset var ColName="" /> <!--- loop index variable for building query --->
		<cfset var altRet="" /> <!--- variable for filtered query if number of levels is passed in --->
        <cfset var AddColumns="TreeDepth,NewOrder,Lineage,idPath" />
        <cfset var RetColList=ListAppend(arguments.theQuery.ColumnList,AddColumns) />
        <cfset var Ret="" />

		<cfif len(arguments.pathColumn)>
			<cfset retColList=ListAppend(retColList,"#arguments.pathColumn#Path") />
		</cfif>
		<!--- set up the return query --->
        <cfset Ret=QueryNew(RetColList) />

		<!--- Set up all of our indexing --->
		<cfloop query="arguments.theQuery">
			<!--- an index of ID to row in "raw" order (not sorted by parent) --->
			<cfset RowFromID[theQuery[arguments.itemID][theQuery.CurrentRow]]=CurrentRow />
			<cfif NOT StructKeyExists(ChildrenFromID, theQuery[arguments.parentID][theQuery.CurrentRow])>
				<!--- only create a new parentID array within the ChildrenFromID struct for every new ParentID --->
				<cfset ChildrenFromID[theQuery[arguments.parentID][theQuery.CurrentRow]]=ArrayNew(1) />
			</cfif>
			<!--- add the ItemID to it's ParentID array within the ChildrenFromID struct --->
			<cfset ArrayAppend(ChildrenFromID[theQuery[arguments.parentID][theQuery.CurrentRow]], theQuery[arguments.itemID][theQuery.CurrentRow]) />
		</cfloop>

		<!--- Find root items --->
		<cfif arguments.rootID eq "0"><!--- if a rootID wasn't specified, use the absolute root --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID does not exist in the rowfromID struct (parent ID isn't an ID of another item)  --->
				<cfif NOT StructKeyExists(RowFromID, theQuery[arguments.parentID][theQuery.CurrentRow])>
					<cfset ArrayAppend(RootItems, theQuery[arguments.itemID][theQuery.CurrentRow]) />
					<cfset ArrayAppend(Depth, arguments.baseDepth) />
					<cfset ArrayAppend(Order, RootOrder) />
					<cfset RootOrder++ />
				</cfif>
			</cfloop>
		<cfelse><!--- use the value of the rootID argument, if passed in, as the root of the tree --->
			<cfloop query="arguments.theQuery">
				<!--- root items are ones whose parent ID matches the rootID argument  --->
				<cfif theQuery[arguments.parentID][theQuery.CurrentRow] eq arguments.rootID>
					<cfset ArrayAppend(RootItems, theQuery[arguments.itemID][theQuery.CurrentRow]) />
					<cfset ArrayAppend(Depth, arguments.baseDepth) />
					<cfset ArrayAppend(Order, RootOrder) />
					<cfset RootOrder++ />
				</cfif>
			</cfloop>
		</cfif>

		<!--- Sort the Tree --->
		<cfloop condition="ArrayLen(RootItems) GT 0">
			<cfset ThisID=RootItems[1] />
			<cfset ArrayDeleteAt(RootItems, 1) />
			<cfset ThisDepth=Depth[1] />
			<cfset ArrayDeleteAt(Depth, 1) />
			<cfset ThisOrder=Order[1] />
			<cfset ArrayDeleteAt(Order, 1) />

			<cfif StructKeyExists(RowFromID, ThisID)><!--- If the current ID exists --->
				<!--- Add this row to the query we're building --->
				<cfset RowID=RowFromID[ThisID] /><!--- get appropriate query row --->
				<cfset QueryAddRow(Ret) />

                <cfset NewRowFromID[ThisID]=Ret.recordCount />
				<!--- Try to find the parent's lineage --->
                <cfif StructKeyExists(Lineages, theQuery[arguments.parentID][RowID])>
                    <cfset ThisLineage=Lineages[theQuery[arguments.parentID][RowID]] />
                <cfelse>
                    <cfset ThisLineage="" /><!--- no grandparents --->
                </cfif>
                <!--- Add the parent if there is one --->
                <cfif structKeyExists(NewRowFromID, theQuery[arguments.parentID][RowID])>
                    <cfset ThisLineage=ListAppend(ThisLineage, NewRowFromID[theQuery[arguments.parentID][RowID]]) />
                </cfif>
                <cfset Lineages[ThisID]=ThisLineage />

				<cfset QuerySetCell(Ret, "TreeDepth", ThisDepth) /> <!--- set depth info in column --->
				<cfset QuerySetCell(Ret, "NewOrder", ThisOrder) /> <!--- set order info in column --->
				<!--- set Tree lineage in cell --->
				<cfset QuerySetCell(Ret,"Lineage", ThisLineage)>
            	<!--- set up path to item to set in path cell --->
                <cfloop list="#thisLineage#" index="i">
					<cfif len(arguments.pathColumn)>
                		<cfset thisPath = listAppend(thisPath,Ret[arguments.pathColumn][i],arguments.pathDelimiter) />
					</cfif>
					<cfset thisIDPath = listAppend(thisIDPath,Ret[arguments.itemID][i],arguments.pathDelimiter) />
                </cfloop>
				<!--- add current item to path --->
				<cfif len(arguments.pathColumn)>
					<cfset thisPath = listAppend(thisPath,theQuery[arguments.pathColumn][RowID],arguments.pathDelimiter) />
					<cfset querySetCell(Ret,"#arguments.PathColumn#Path", thisPath) />
	                <cfset thispath = "" /> <!--- resets variable for the next item --->
				</cfif>
				<cfset thisIDPath = listAppend(thisIDPath,theQuery[arguments.itemID][RowID],arguments.pathDelimiter) />
				<cfset querySetCell(Ret,"idPath", thisIDPath) />
				<cfset thisIDPath = "" /> <!--- resets variable for the next item --->
				<cfloop list="#theQuery.ColumnList#" index="ColName"><!--- loop over the original querys columns to copy the data to our return query --->
					<cfif theQuery[ColName][RowID] neq "">
						<cfset QuerySetCell(Ret, ColName, theQuery[ColName][RowID]) />
					</cfif>
				</cfloop>
			</cfif>

			<cfif StructKeyExists(ChildrenFromID, ThisID)>
				<!--- Push children into the stack --->
				<cfset ChildrenIDs=ChildrenFromID[ThisID]>
				<cfloop from="#ArrayLen(ChildrenIDs)#" to="1" step="-1" index="i">
					<cfset ArrayPrepend(RootItems, ChildrenIDs[i])>
					<cfset ArrayPrepend(Depth, ThisDepth + 1)>
					<cfset ArrayPrepend(Order, i) />
				</cfloop>
			</cfif>

		</cfloop>
		<cfif not arguments.levels>
			<cfreturn Ret />
		<cfelse>
			<cfquery dbtype="query" name="altRet">
				SELECT *
				FROM Ret
				WHERE TreeDepth <= <cfqueryparam value="#(arguments.levels)#" cfsqltype="cf_sql_integer" />
			</cfquery>
			<cfreturn altRet />
		</cfif>
	</cffunction>

	<cffunction name="HTMLListFromQueryTree" access="public" output="false" returntype="string">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="displayColumn" type="string" default="title" />
		<cfargument name="linkColumn" type="string" default="" hint="query column containing text to be used as links" />
		<cfargument name="DepthPrefix" default="depth" type="String" required="false" />
		<cfargument name="innerTag" type="string" default="" />
        <cfargument name="linkPrefix" type="string" default="" />
        <cfargument name="linkSuffix" type="string" default="" />
		<cfargument name="activeItems" type="string" default="" />
		<cfargument name="homelink" type="string" default="" />
		<cfargument name="PathColumn" type="string" default="" hint="the name of the column containing the values to use to build paths to the items in the tree" />
		<cfargument name="activeClass" type="string" default="active" />
		<cfargument name="ListTag" default="ul" type="String" required="false" />
		<cfargument name="baseURL" type="string" default="/" />

		<cfset var Ret = "" />
		<cfset var MinDepth = 999 />
		<cfset var Q = arguments.theQuery />
		<cfset var LastDepth = 0 />
		<cfset var ThisDepth = 0 />
		<cfset var d = 0 />
		<cfset var itemTag = "" />
		<cfset var thislink = "" />
        <cfset var innerTagOpen = trim(arguments.innerTag) />
        <cfset var innerTagClose = "" />

        <cfif len(arguments.innerTag)>
        	<cfset innerTagClose = insert("/",arguments.innerTag,"1") />
        </cfif>

		<!--- Find the minimum depth of the tree --->
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth />
			<cfif ThisDepth LT MinDepth>
				<cfset MinDepth = ThisDepth>
			</cfif>
		</cfloop>
		<cfset LastDepth = MinDepth - 1>

		<!--- Main loop to  generate list --->
		<cfloop query="Q">
			<cfset ThisDepth = Q.TreeDepth /><!--- Get Depth of current item in the query --->
			<!--- If the depth of the  current item is greater than the previous one, open a new list --->
			<cfif LastDepth LT ThisDepth>
				<cfloop from="#IncrementValue(LastDepth)#" to="#ThisDepth#" index="d">
					<cfset Ret = Ret & '<#arguments.ListTag# class="#Arguments.DepthPrefix##d-MinDepth+1#">'><!--- add as many UL tags as depth of item --->
				</cfloop>
			<cfelse>
				<!--- if the last item was deeper, we need to close off the lists in between --->
				<cfif LastDepth GT ThisDepth>
					<cfset Ret = Ret & RepeatString("</li></#Arguments.ListTag#>",LastDepth-ThisDepth) />
				</cfif>
				<!--- either way (if the depths are the same or last item was deeper), just close off the current list item --->
				<cfset Ret = Ret & "</li>" />
			</cfif>
			<!--- set up li tag for whether it's active or not (a list of active items can be passed in)--->
			<cfif len(arguments.pathColumn) and listfindnocase(arguments.activeItems,Q[variables.pathColumn][Q.CurrentRow])>
				<cfset itemTag = '<li class="' & arguments.activeClass & '">' />
			<cfelse>
				<cfset itemTag = '<li>' />
			</cfif>
			<!--- associate list items with links if a linkcolumn was given --->
			<cfif len(arguments.linkColumn)>
				<!--- set if current link is the home page, set empty link (to go to site root) --->
                <cfif (Q[arguments.linkColumn][Q.CurrentRow] neq arguments.homelink)>
                    <cfset thislink = "/" & arguments.linkPrefix & hibachiHTMLEditFormat(Q[arguments.linkColumn][Q.CurrentRow]) & arguments.linkSuffix />
                <cfelse>
                    <cfset thislink = arguments.baseURL />
                </cfif>
				<cfset Ret = Ret & itemTag & '<a href="' &  thislink & '">' & innerTagOpen & hibachiHTMLEditFormat(Q[arguments.displayColumn][Q.CurrentRow]) & innerTagClose & '</a>' /><!--- item will be closed in later loop iteration --->
			<cfelse>
				<cfset Ret = Ret & itemTag & innerTagOpen & hibachiHTMLEditFormat(Q[arguments.displayColumn][Q.CurrentRow]) & innerTagClose /><!--- item will be closed in later loop iteration --->
			</cfif>
			<cfset LastDepth = ThisDepth />
		</cfloop>

		<!--- Close off all items at once (there must be at least one)--->
		<cfif Q.RecordCount GT 0>
			<cfset Ret = Ret & RepeatString("</li></#Arguments.ListTag#>",LastDepth-(MinDepth-1)) />
		</cfif>
		<cfreturn Ret>

	</cffunction>

	<cffunction name="structFromQueryTree" access="public" output="false" returntype="any">
		<cfargument name="theQuery" type="query" required="true" />
		<cfargument name="displayColumn" type="string" default="title" />
		<cfargument name="parentID" default="" />

		<cfset var Ret = [] />
		<cfset var Q = arguments.theQuery />

		<!--- Main loop to  generate struct --->
		<cfloop query="Q">
			<cfif Q.parentProductTypeID eq arguments.parentID>
				<cfset local.thisElement = {"title"="#Q[arguments.displayColumn][Q.CurrentRow]#"} />
				<cfif Q.childCount gt 0>
					<cfset local.thisElement["isFolder"] = "true" />
					<cfset local.thisElement["children"] = structFromQueryTree(argumentCollection=arguments,parentID=Q.productTypeID) />
				</cfif>
				<cfset arrayAppend(Ret,local.thisElement) />
			</cfif>
		</cfloop>

		<cfreturn Ret>

	</cffunction>

	<cfscript>
	/**
	 * Makes a row of a query into a structure.
	 *
	 * @param query 	 The query to work with.
	 * @param row 	 Row number to check. Defaults to row 1.
	 * @return Returns a structure.
	 * @author Nathan Dintenfass (nathan@changemedia.com)
	 * @version 1, December 11, 2001
	 * http://cflib.org/index.cfm?event=page.udfbyid&udfid=358
	 */
	function queryRowToStruct(query){
		//by default, do this to the first row of the query
		var row = 1;
		//a var for looping
		var ii = 1;
		//the cols to loop over
		var cols = listToArray(query.columnList);
		//the struct to return
		var stReturn = structnew();
		//if there is a second argument, use that for the row number
		if(arrayLen(arguments) GT 1)
			row = arguments[2];
		//loop over the cols and build the struct from the query row
		for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
			stReturn[cols[ii]] = query[cols[ii]][row];
		}
		//return the struct
		return stReturn;
	}
	
       /**
	* exports the given query/array to file.
	*
	* @param data      Data to export. (Required) (Currently only supports query).
	* @param columns      list of columns to export. (optional, default: all)
	* @param columnNames      list of column headers to export. (optional, default: none)
	* @param fileName      file name for export. (default: guid)
	* @param fileType      file type for export. (default: csv)
	* @param download      download the file. (default: true)
	* @return struct with file info.
	*/
	public struct function export(required any data, string columns, string columnNames, string fileName, string fileType = 'csv', boolean download = true ) {
		 return getService("HibachiService").export(data=data, columns=columns, columnNames=columnNames, fileName=fileName, fileType=fileType, downloadFile=download);
	}
	
	// @hint utility function to sort array of ojbects can be used to override getCollection() method to add sorting.
	// From Aaron Greenlee http://cookbooks.adobe.com/post_How_to_sort_an_array_of_objects_or_entities_with_C-17958.html
	public array function sortObjectArray(required array objects, required string orderByProperty, string sortType="text", string direction = "asc") {
		var sortedStruct = {};
		var sortedArray = [];
        for (var i=1; i <= arrayLen(arguments.objects); i++) {
                // Each key in the struct is in the format of
                // {VALUE}.{RAND NUMBER} This is important otherwise any objects
                // with the same value would be lost.
                var rn = randRange(1,100);
                var sortedStruct[ evaluate("arguments.objects[i].get#arguments.orderByProperty#() & '.' & rn") ] = objects[i];
		}
		var keyArray = structKeyArray(sortedStruct);
		arraySort(keyArray,arguments.sortType,arguments.direction);
		for(var i=1; i<=arrayLen(keyArray);i++) {
			arrayAppend(sortedArray, sortedStruct[keyArray[i]]);
		}
		return sortedArray;
	}

	/**
	* Sorts an array of structures based on a key in the structures.
	*/
	function structArraySort(arrayOfStructs,key,sortType="numeric", sortOrder="asc"){
	        var tempStruct = {};
	        var structArrayLength = arrayLen(arrayOfStructs);
	        for(var i=1; i<=structArrayLength; i++){
	        	tempStruct[i] = StructCopy(arrayOfStructs[i]);
	        }
	        var keys = StructSort(tempStruct, sortType, sortOrder, key);
	        var sortedArray = arrayNew(1);
	        for(var i=1; i<=structArrayLength; i++){
	        	arrayAppend(sortedArray, tempStruct[keys[i]]);
	        }
	        return sortedArray;
	}

	// remove primary key from cols listing 
	public struct function queryToStructOfStructures(required query theQuery, 
													required string primaryKey, boolean retainSort=false){
       var theStructure  = structnew();
       var indexToDelete = ListFindNoCase(arguments.theQuery.columnlist, arguments.primaryKey);
	   var newList = ListDeleteAt(arguments.theQuery.columnlist, indexToDelete);		
       var cols = ListToArray(newList);
       var row           = 1;
       var thisRow       = "";
       var col           = 1;
       
       if(!isNull(arguments.retainSort)){
               theStructure = CreateObject("java", "java.util.LinkedHashMap").init();
       }
       
       for(row = 1; row <= arguments.theQuery.recordcount; row = row + 1){
               thisRow = structnew();
               for(col = 1; col <= arraylen(cols); col = col + 1){
                       thisRow[cols[col]] = arguments.theQuery[cols[col]][row];
               }
              
               theStructure[arguments.theQuery[arguments.primaryKey][row]] = duplicate(thisRow);
       }
       return(theStructure);
	}

	// Helper method to combine xml documents
	public any function xmlImport(required xml parentDocument, required any nodes) {
		/*
			Check to see how the XML nodes were passed to us. If it
			was an array, import each node index as its own XML tree.
			If it was an XML tree, import recursively.
		*/
		if( isArray( arguments.nodes ) ) {
			var importedNodes = [] ;

			for(var node in arguments.nodes) {
				arrayAppend(importedNodes,xmlImport(arguments.parentDocument,node)) ;
			}

			return importedNodes;

		} else {
			/*
				We were passed an XML document or nodes or XML string.
				Either way, let's copy the top level node and then
				copy and append any children.

				NOTE: Add ( arguments.Nodes.XmlNsURI ) as second
				argument if you are dealing with name spaces.
			*/
			var newNode = XmlElemNew(arguments.parentDocument,arguments.Nodes.XmlName) ;

			structAppend(newNode.XmlAttributes,arguments.nodes.XmlAttributes) ;

			// Copy simple values.
			newNode.XmlText = arguments.nodes.XmlText ;
			newNode.XmlComment = arguments.nodes.XmlComment ;

			/*
				Loop over the child nodes and import them as well
				and then append them to the new node.
			*/
			for(var childNode in arguments.nodes.XmlChildren) {
				arrayAppend(newNode.XmlChildren,XmlImport(arguments.parentDocument,childNode)) ;
			}
			return newNode ;
		}
	}
	/** This is a helper method that allows one to check that a property exists and that it has a value in one
        go by passing in a single property name or a list of list of propertyNames */
    public boolean function hasPropertyWithDefinedValue(required struct data={}, any propertyName=""){
       //simple case
       if (structKeyExists(arguments, "data") && structKeyExists(arguments.data, "#arguments.propertyName#") && !isNull(arguments.data['#propertyName#']) && isStruct(arguments.data)) {
            return true;
       }
       return false;
    }

    /** This is a helper method that allows one to check that a list of properties exists and that they all have a value in one
        go by passing in a list of list of propertyNames  and the struct to check against */
    public boolean function hasPropertiesWithDefinedValues(required struct data={}, any propertyList=""){
       //simple case
       if (structKeyExists(arguments, "data") &&
             !isNull(arguments.data) &&
             structKeyExists(arguments, "propertyList") &&
             !isNull(arguments.propertyList) &&
             isStruct(arguments.data)){
           for (key in ListToArray(arguments.propertyList)){
               if (!structKeyExists(arguments.data, "#key#") || isNull(arguments.data['#key#'])) {
                    return false;
               }
           }
           return true;
       }
    }

    public string function replaceStringTemplate(required string template, required any object, boolean formatValues=false, boolean removeMissingKeys=false) {
		if(
			getHibachiScope().onSlatwallCMS()
		){
			arguments.removeMissingKeys = true;
		}
		return super.replaceStringTemplate(argumentCollection=arguments);
	}
	</cfscript>

</cfcomponent>

