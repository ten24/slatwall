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
	<cfparam name="attributes.fieldAttributes" type="string" default="" />
	<cfparam name="attributes.showEmptySelectBox" type="boolean" default="true" /> 		<!--- If set to false, will hide select box if no options are available --->
	
	<cfparam name="attributes.methodIdentifier" type="string" default="" />
	
	<cfassociate basetag="cf_HibachiListingDisplay" datacollection="columns">
</cfif>