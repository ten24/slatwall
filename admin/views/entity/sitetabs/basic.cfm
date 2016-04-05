<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.site" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<cfif !isNull(rc.site.getApp())>
				<hb:HibachiPropertyDisplay object="#rc.site#" property="app" edit="false">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.site#" property="siteName" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.site#" property="siteCode" edit="false">
			<cfif !isNull(rc.site.getApp()) && rc.site.getApp().getIntegration().getIntegrationPackage() eq 'slatwallcms'>
				<hb:HibachiPropertyDisplay object="#rc.site#" property="domainNames" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.site#" property="allowAdminAccessFlag" edit="#rc.edit#">
			</cfif>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
	
	<!---<cfset thisImagePath = #rc.$.slatwall.getResizedImage(imagePath="anywhere", width=250, height=250,siteID=rc.site.getSiteID())#>
	 
    <div class="col-xs-2 s-upload-image right">
        <div class="thumbnail">
            <div class="s-image">
                #rc.$.slatwall.getResizedImage(imagePath="anywhere", width=250, height=250, siteID=rc.site.getSiteID())#
            </div>
            <div class="s-title">
                <span>
                   #rc.$.slatwall.getResizedImagePath(imagePath="anywhere", width=250, height=250, siteID=rc.site.getSiteID())#
                </span>
                
            </div>
            
        </div>
    </div> --->
</cfoutput>