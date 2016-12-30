<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.property" type="string" default="" />
	<cfparam name="attributes.view" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="" />
	<cfparam name="attributes.tabid" type="string" default="" />
	<cfparam name="attributes.tabcontent" type="string" default="" />
	<cfparam name="attributes.params" type="struct" default="#structNew()#" />
	<cfparam name="attributes.count" type="string" default="" />
	<cfparam name="attributes.open" type="boolean" default="false" />
	<cfparam name="attributes.showOnCreateFlag" type="boolean" default="false" />
	
	<cfassociate basetag="cf_HibachiEntityDetailGroup" datacollection="tabs">
</cfif>