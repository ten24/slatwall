<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.processObject" type="any" />
<cfparam name="rc.integration" type="any" />
<cfparam name="rc.edit" type="boolean" />

<hb:HibachiEntityProcessForm entity="#rc.integration#" edit="#rc.edit#">
    <hb:HibachiEntityActionBar type="preprocess" object="#rc.integration#">
    </hb:HibachiEntityActionBar>
    
        <hb:HibachiPropertyRow>
            <hb:HibachiPropertyList>
                <hb:HibachiPropertyDisplay object="#rc.processObject#" property="tracker" edit="#rc.edit#" />
                <hb:HibachiPropertyDisplay object="#rc.processObject#" property="dateTimeSince" edit="#rc.edit#" />
                <cfif structKeyExists(rc, 'result')>
                    <cfdump var="#rc.result#" />
                </cfif>
            </hb:HibachiPropertyList>
        </hb:HibachiPropertyRow>
        
</hb:HibachiEntityProcessForm>