<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	<cfparam name="attributes.entityName" default=""/>
	<cfparam name="attributes.propertyIdentifier" default=""/>
	<cfparam name="attributes.collectionlist" default=""/>
	<cfparam name="attributes.filterType" default="f"/>
	<cfparam name="attributes.filterValues" default=""/>
	
	<cfassociate basetag="cf_HibachiFilterCountDisplay" datacollection="filterCountGroups">
</cfif>