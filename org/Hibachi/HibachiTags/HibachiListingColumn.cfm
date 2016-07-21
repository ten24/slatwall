<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<!--- Core Attributes --->
	<cfparam name="attributes.propertyIdentifier" type="string" default="" />
	<cfparam name="attributes.processObjectProperty" type="string" default="" />
	
	<!--- Additional Attributes --->
	<cfparam name="attributes.title" type="string" default="" />
	<cfparam name="attributes.tdclass" type="string" default="" />
	<cfparam name="attributes.search" type="any" default="" />
	<cfparam name="attributes.sort" type="any" default="" />
	<cfparam name="attributes.filter" type="any" default="" />
	<cfparam name="attributes.range" type="any" default="" />
	<cfparam name="attributes.editable" type="boolean" default="false" />
	<cfparam name="attributes.buttonGroup" type="any" default="" />
	
	<cfassociate basetag="cf_HibachiListingDisplay" datacollection="columns">
</cfif>