<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.property" type="string" default="" />
	<cfparam name="attributes.view" type="string" default="" />
	<cfparam name="attributes.text" type="string" default="" />
	<cfparam name="attributes.tabid" type="string" default="" />
	<cfparam name="attributes.tabcontent" type="string" default="" />
	<cfparam name="attributes.params" type="struct" default="#structNew()#" />
	<cfparam name="attributes.count" type="string" default="" />
	<cfparam name="attributes.lazyLoad" type="boolean" default="true"/>
	
	<cfassociate basetag="cf_HibachiTabGroup" datacollection="tabs">
</cfif>