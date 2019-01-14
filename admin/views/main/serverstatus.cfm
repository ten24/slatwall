<cfparam name="rc.top" default="25" />
<cfoutput>
<div class="row s-body-nav">
    <nav class="navbar navbar-default" role="navigation">
      <div class="col-md-6 s-header-info">
    	<h1 class="actionbar-title">Server Status Info</h1>
    	</div>
    
    	<div class="col-md-6">
    		<div class="btn-toolbar">
				<div class="btn-group btn-group-sm">
				    <a title="Run GC" class="btn btn-primary" target="_self" href="?slatAction=admin:main.runJvmGc"><i class="glyphicon glyphicon-plus icon-white"></i> Run GC</a>
				</div>
    		</div>
    	</div>
    </nav>
</div>

<cfscript>
    statusInfo = getHibachiScope().getService('hibachiUtilityService').getServerStatusInfo();
    cacheHitStack = getHibachiScope().getService('hibachiCacheService').getCacheHitStack();
    cacheShowAllKeys = false;
    cacheTopMRUKeys = [];
    cacheTopLRUKeys = [];
    if (statusInfo.cacheHitStackElementTotal >= rc.top * 2) {
        cacheTopMRUKeys = arraySlice(cacheHitStack, 1, rc.top);
        cacheTopLRUKeys = arraySlice(cacheHitStack, arrayLen(cacheHitStack) - rc.top, rc.top);
    } else {
        cacheShowAllKeys = true;
    }
</cfscript>
<p>
    <table>
        <thead>
            <tr>
                <th>Metric</th>
                <th>Detail</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>Cache Type:</td>
                <td>#statusInfo.cacheType#</td>
            </tr>
            <tr>
                <td>Cache Element Total:</td>
                <td>#statusInfo.cacheElementTotal#</td>
            </tr>
            <tr>
                <td>Cache Element Hit Stack Total:</td>
                <td>#statusInfo.cacheHitStackElementTotal#</td>
            </tr>
            <tr>
                <td>Cache Sweeps Executed Total:</td>
                <td>#statusInfo.cacheSweepTotal#</td>
            </tr>
            <tr>
                <td>Cache Max Elements Limit:</td>
                <td>#statusInfo.cacheMaxElementsLimit#</td>
            </tr>
            <tr>
                <td>Cache Validation Interval</td>
                <td>#statusInfo.cacheValidationIntervalSeconds# seconds</td>
            </tr>
            <tr>
                <td>Cache LRU Element Age:</td>
                <td>#statusInfo.cacheElementLRUAgeSeconds# seconds</td>
            </tr>
            <tr>
                <td>Cache Was Last Validated:</td>
                <td>#statusInfo.cacheLastValidationSeconds# seconds ago</td>
            </tr>
            <tr>
                <td>Cache Next Validation (for sweep):</td>
                <cfif statusInfo.cacheNextValidationSeconds gt 0>
                    <td>after #statusInfo.cacheNextValidationSeconds# more seconds</td>
                <cfelse>
                    <td>Next request</td>
                </cfif>
            </tr>
            <tr>
                <td>Processors Available:</td>
                <td>#statusInfo.systemProcessorsAvailable#</td>
            </tr>
            <tr>
                <td>Memory Total Available:</td>
                <td>#numberFormat(statusInfo.systemMemoryTotalAvailableMb, ',')# MB</td>
            </tr>
            <tr>
                <td>Memory Free:</td>
                <td>#numberFormat(statusInfo.systemMemoryFreeMb, ',')# MB</td>
            </tr>
            <tr>
                <td>Memory Used:</td>
                <td>#numberFormat(statusInfo.systemMemoryUsedMb, ',')# MB</td>
            </tr>
        </tbody>
    </table>
</p>
<p>
    <h5>Cache Keys</h5>
        <table>
            <thead>
                <tr>
                    <th>MRU Rank</th>
                    <th></th>
                    <th>LRU Rank</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <cfif not cacheShowAllKeys>
                <cfloop from="1" to="#rc.top#" index="r">
                    <tr>
                        <td>#r#.</td>
                        <td>#cacheTopMRUKeys[r]#</td>
                        <td>#r#.</td>
                        <td>#cacheTopLRUKeys[(rc.top + 1) - r]#</td>
                    </tr>
                </cfloop>
            <cfelse>
                <cfloop from="1" to="#ceiling(statusInfo.cacheHitStackElementTotal / 2)#" index="r">
                    <cfset r2 = ceiling(statusInfo.cacheHitStackElementTotal / 2) + r />
                    <tr>
                        <td>#r#.</td>
                        <td>#cacheHitStack[r]#</td>
                        <cfif r2 lte statusInfo.cacheHitStackElementTotal>
                            <td>#ceiling(statusInfo.cacheHitStackElementTotal / 2) + r#.</td>
                            <td>#cacheHitStack[(statusInfo.cacheHitStackElementTotal + 1) - r]#</td>
                        </cfif>
                    </tr>
                </cfloop>
            </cfif>
            </tbody>
        </table>
</p>
</cfoutput>