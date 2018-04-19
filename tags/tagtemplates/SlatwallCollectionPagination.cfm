<cfoutput>
	<cfif attributes.collection.getTotalPages() gt 1>
		<nav>
			
		    <ul class="pagination">
		    	<cfif currentPage gt 1>
			    	<!--- First --->
			    	<li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=1' )#" <cfif currentPage EQ 1>disabled="disabled" title="First Page" </cfif>>
			    		#attributes.first#
			    		</a></li>
			        
			        <!--- Previous --->
			        <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&previousPage )#" <cfif currentPage EQ 1>disabled="disabled" title="Previous Page #currentPage-1#" </cfif>>
			        	#attributes.previous#
			        	</a>
			        </li>
		        
			        <!--- Show previous pages if they exist --->
			        <cfif nextPage GT 2>
			            <cfloop index="page" from="1" to="#nextPage#">
			            	<cfif page LT currentPage>	
			                <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#page#' )#">#page#</a></li>
			            	</cfif>
			            </cfloop>
			        </cfif>
		        </cfif>
		        
		        <!--- Self --->
		        <li 
		        	class="active"
		        	><a href="##">#attributes.collection.getCurrentPageDeclaration()#</a>
		        </li>
		        
		        <cfif currentPage neq attributes.collection.getTotalPages()>
			        <!--- Show next 4 pages if they exist minus the ones shown before the current page. --->
			        <cfloop condition="nextPage LTE lastPage AND nextPage LTE currentPage+4">
			            <li><a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#nextPage#' )#">#nextPage#</a></li>
			            <cfset nextPage+=1>
			        </cfloop>
			        
			        <!--- Next --->
			        <li>
			        	<a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current=#currentPage+1#' )#" title="Next Page #currentPage+1#">
			        		#attributes.next#
			        	</a>
			        </li>
			        <!--- Last --->
			        <li>
			        	<a href="#attributes.slatwallScope.getService('hibachiCollectionService').buildURL( 'p:current='&lastPage )#" title="Last Page #lastPage#">
			        		#attributes.last#
			        	</a>
			        </li>
		        </cfif>
		    </ul>
		</nav>
	</cfif>
</cfoutput>

