<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfset algoliaClient = $.slatwall.getService('algoliaService').getAlgoliaClient()/>

<cfset indexData = algoliaClient.listIndexes()/>

<cfset indexes = indexData.data.items/>

<cfoutput>
    <cfif arraylen(indexes)>
        <cfset headers = listToArray(structKeyList(indexes[1]))/>
        <table class="table table-bordered s-detail-content-table">
            <thead>
                <tr>
                    <cfloop array="#headers#" index="header">
                        <th class="data">#header#</th>
                    </cfloop>
                    <th></th>
                </tr>    
                
            </thead>
            <tbody>
                <cfloop array="#indexes#" index="indexValue">
                    
                    <tr>
                        <cfloop array="#headers#" index="header">
                            
                            <th>
                                <cfif structKeyExists(indexValue,header) and isSimpleValue(indexValue[header])>
                                    #indexValue[header]#
                                </cfif>
                            </th>
                        </cfloop>
                        <td>
                            
                            <a href="/?slatAction=algolia:main.manageindex&indexname=#indexValue['name']#">
                                <i class="glyphicon glyphicon-pencil"></i>
                            </a>
                        </td>
                    </tr>    
                </cfloop>
                
            </tbody>
        </table>
    </cfif>
</cfoutput>