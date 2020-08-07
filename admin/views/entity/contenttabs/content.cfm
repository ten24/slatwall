<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.content" type="any" />
<cfparam name="rc.edit" type="boolean" default="false"/>

<cfoutput>
	<hb:HibachiPropertyDisplay object="#rc.content#" edit="#rc.edit#" property="contentBody" displaytype="plain" fieldAttributes="siteCode='#rc.content.getSite().getSiteCode()#' appCode='#rc.content.getSite().getApp().getAppCode()#'"
		ignoreHTMLEditFormat="true" 
	/>
</cfoutput>