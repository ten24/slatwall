 <span ng-controller="create-bundle-controller">
		
	  <section class="col-xs-12" >
	
	    
	    <span 	ng-if="processObject.productBundleGroups.value"
	    		sw-product-bundle-groups
	    		data-product-bundle-groups="processObject.productBundleGroups.value"
	    >
	    </span>
	    <button class="btn btn-xs s-btn-grey s-create-bundle-btn"
	    		data-toggle="collapse" 
	    		ng-click="addProductBundleGroup()"
	    >
	    	<i class="fa fa-plus"></i> Bundle Group
	    </button>
	  </section>
</span>