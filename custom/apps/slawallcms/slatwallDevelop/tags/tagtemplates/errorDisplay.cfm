<cfoutput>
    <!--client side validation-->
    <div  ng-repeat="(key, value) in #attributes.formController#.form['#attributes.propertyIdentifier#'].$error"
    		ng-show="#attributes.formController#.form.$submitted"
    >
    	<div ng-show="key === 'swvalidationrequired'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.required'"></div><br ng-show="key === 'swvalidationrequired'">
    	<div ng-show="key === 'swvalidationemail'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.emailrequired'"></div><br ng-show="key === 'swvalidationemail'">
    	<div ng-show="key === 'swvalidationunique'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.unique'"></div><br ng-show="key === 'swvalidationunique'">
    	<div ng-show="key === 'swvalidationuniqueornull'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.uniqueornull'"></div><br ng-show="key === 'swvalidationuniqueornull'">
    	<div ng-show="key === 'swvalidationnumeric'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.numeric'"></div><br ng-show="key === 'swvalidationnumeric'">
    	<div ng-show="key === 'swvalidationregex'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.regex'"></div><br ng-show="key === 'swvalidationregex'">
    	<div ng-show="key === 'swvalidationgte'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.gte'"></div><br ng-show="key === 'swvalidationgte'">
    	<div ng-show="key === 'swvalidationlte'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.lte'"></div><br ng-show="key === 'swvalidationlte'">
    	<div ng-show="key === 'swvalidationeq'" class="px-2 mt-1 bg-danger text-white" sw-Rbkey="'validation.define.neq'"></div><br ng-show="key === 'swvalidationeq'">
    	<div ng-show="key === 'swvalidationminvalue'" class="px-2 mt-1 bg-danger text-white">The value entered is incorrect</div><br ng-show="key === 'swvalidationminvalue'">
    	<div ng-show="key === 'swvalidatiomaxvalue'" class="px-2 mt-1 bg-danger text-white">The value entered is incorrect</div><br ng-show="key === 'swvalidationmaxvalue'">
    	<div ng-show="key === 'swvalidationminlength'" class="px-2 mt-1 bg-danger text-white">The value entered is incorrect</div><br ng-show="key === 'swvalidationminlength'">
    	<div ng-show="key === 'swvalidationmaxlength'" class="px-2 mt-1 bg-danger text-white">The value entered is incorrect</div><br ng-show="key === 'swvalidationmaxlength'">
        <div ng-show="key === 'swvalidationeqproperty'" class="px-2 mt-1 bg-danger text-white">The values entered do not match.</div><br ng-show="key === 'swvalidationeqproperty'">
    </div>
    <!--server side validation-->
    <div class="px-2 mt-1 bg-danger text-white" ng-show="slatwall.requests[#attributes.formController#.method].errors.#attributes.propertyIdentifier#" ng-repeat="error in slatwall.requests[#attributes.formController#.method].errors.#listLast(attributes.propertyIdentifier,'.')#" ng-bind="error">
        
    </div>
</cfoutput>