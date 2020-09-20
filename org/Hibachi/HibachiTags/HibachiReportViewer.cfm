<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />
<cfif thisTag.executionMode is "start">
	<cfparam name="attributes.report" type="any" />
	<cfparam name="attributes.collectionList" type="any" />
	<cfparam name="attributes.enableAveragesAndSums" type="boolean" default="true"/> 
	<cfparam name="attributes.hibachiScope" type="any" default="#request.context.fw.getHibachiScope()#" />
	
	<cfoutput>
		<script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/Chart.bundle.min.js"></script>

		<div id="hibachi-report" data-reportname="#attributes.report.getClassName()#">
			<!--- Configure --->
			<div id="hibachi-report-configure-bar">
				#attributes.report.getReportConfigureBar()#
			</div>
		    <div class="Mcard-wrapper col-md-12">
		        <div class="col-md-3">
					<div class="Mcard card-shadow">
					    <div class="Mcard-body ">
					       <div>
					           <h1 id="sales-revenue-this-period"></h1>
					        </div>
					       <div>
					           <img src="/assets/images/piggy-bank-1.png" alt="Piggy Bank">
					       </div>
					    </div>
					    <div class="Mcard-footer Mcard-footer1">
					        <div>
					            <p>Sales <span class="time-period"></span></p>
					        </div>
					    </div>
					</div>
		        </div>
		
		         <div class="col-md-3">
					<div class="Mcard card-shadow">
					    <div class="Mcard-body ">
					       <div>
					           <h1 id="order-count-this-period"></h1>
					        </div>
					       <div>
					           <img src="/assets/images/shopping-bag-gray.png" alt="Shopping Bags">
					       </div>
					    </div>
					    <div class="Mcard-footer Mcard-footer2">
					        <div>
					            <p>Order Count <span class="time-period"></span></p>
					        </div>
					    </div>
					</div>
		        </div>
		
		        <div class="col-md-3">
					<div class="Mcard card-shadow">
					    <div class="Mcard-body ">
					       <div>
					           <h1 id="average-order-total-this-period"></h1>
					        </div>
					       <div>
					           <img src="/assets/images/dollar-symbol-gray.png" alt="Dollar Symbol Badge">
					       </div>
					    </div>
					    <div class="Mcard-footer Mcard-footer4">
					        <div>
					            <p>Average Order Value <span class="time-period"></span></p>
					        </div>
					    </div>
					</div>
		        </div>
		        
		    	<div class="col-md-3">
		    		<!---<sw-stat-widget 
						title="Accounts Created" 
						metric="accounts-created-this-period"
						img-src="/assets/images/user-2.png"
						img-alt="User Icon"
						footer-class="Mcard-footer3"
					>
					</sw-stat-widget>--->
					<div class="Mcard card-shadow">
					    <div class="Mcard-body ">
					       <div>
					           <h1 id="accounts-created-this-period"></h1>
					        </div>
					       <div>
					           <img src="/assets/images/user-2.png" alt="User Icon">
					       </div>
					    </div>
					    <div class="Mcard-footer Mcard-footer3">
					        <div>
					            <p>Accounts Created <span class="time-period"></span></p>
					        </div>
					    </div>
					</div>
		        </div>
		        
			</div>
			<!--- Chart --->
			<div class="hibachi-report-chart-container col-md-12">
				<h3 class="hibachi-report-chart-title">#attributes.report.getReportEntity().getReportTitle()#</h3>
				<div id="hibachi-report-chart-wrapper">
					<canvas id="hibachi-report-chart" width="1800" height="600"></canvas>
				</div>
			</div>
			
				<cfset scopeVariableID = '#attributes.collectionlist.getCollectionObject()##rereplace(createUUID(),'-','','all')#'/>
				<cfset entityMetaData = getMetaData(attributes.collectionList.getCollectionEntityObject())/>
	
				<cfset attributes.collectionList.getCollectionConfigStruct()["enableAveragesAndSums"] = attributes.enableAveragesAndSums />
				<cfset JSON = serializeJson(attributes.collectionList.getCollectionConfigStruct())/>

				<!---escape apostrophes--->
				<cfset JSON = rereplace(JSON,"'","\'",'all')/>
				<!---convert double quotes to single--->
				<cfset JSON = rereplace(JSON,'"',"'",'all')/>
				<span ng-init="
					#scopeVariableID#=$root.hibachiScope.$injector.get('collectionConfigService').newCollectionConfig().loadJson(#JSON#);
				"></span>
				
				<cfif !attributes.collectionList.getNewFlag() && !structKeyExists(attributes.collectionList.getCollectionConfigStruct(),'periodInterval') >
					<span ng-controller="collections"
						data-table-id="#scopeVariableID#"
						data-collection-id="#attributes.collectionList.getCollectionID()#"
					>
					</span>
				</cfif>
				
				<cfset personalCollectionKey = hash(serializeJson(attributes.collectionList.getCollectionConfigStruct()))/>

				<sw-report-menu
					data-collection-config="#scopeVariableID#"
				>
				</sw-report-menu>

			<script type="text/javascript">
				jQuery(document).ready(function(){
					addLoadingDiv( 'hibachi-report' );
					updateReport();
				});
			</script>
		</div>
	</cfoutput>
</cfif>

