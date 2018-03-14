<cfimport prefix="hb" taglib="../../../../../../org/Hibachi/HibachiTags"/>
<cfoutput>
<button class="btn btn-primary btn-block mb-4" type="button" data-toggle="collapse" data-target="##sidebarCollapse" aria-expanded="false" aria-controls="sidebarCollapse">
    Filter Options
</button>

<!---
<hb:HibachiFilterCountDisplay hibachiScope="#$.slatwall#" collectionList="#productCollectionList#">

    <hb:HibachiFilterCountDisplayItem propertyIdentifier="productName" template="../../../custom/tags/templates/hibachifiltercountdisplayitem.cfm">
    
</hb:HibachiFilterCountDisplay>
--->

<div class="collapse show" id="sidebarCollapse">
    <div id="accordion">
        <div class="card mb-4">
    		<div class="card-header" id="headingOne">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
    				Search
    				</button>
    			</h5>
    		</div>
    		<div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="##accordion">
    			<div class="card-body">
                    <input type="text" name="search" class="form-control form-control-sm">
                    <button type="submit" class="btn btn-sm btn-block btn-secondary mt-1">Search</button>
                </div>
    		</div>
    	</div>
        <div class="card mb-4">
    		<div class="card-header" id="headingOne">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
    				Product Type
    				</button>
    			</h5>
    		</div>
    		<div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="##accordion">
    			<div class="card-body">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="productType">
                      <label class="form-check-label" for="category">Product Type 1</label>
                      <span class="badge badge-secondary float-right mt-1">24</span>
                    </div>
                </div>
    		</div>
    	</div>
    	<div class="card mb-4">
    		<div class="card-header" id="headingOne">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0" data-toggle="collapse" data-target="##collapseOne" aria-expanded="true" aria-controls="collapseOne">
    				Categories
    				</button>
    			</h5>
    		</div>
    		<div id="collapseOne" class="collapse" aria-labelledby="headingOne" data-parent="##accordion">
    			<div class="card-body">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="category">
                      <label class="form-check-label" for="category">Category 1</label>
                      <span class="badge badge-secondary float-right mt-1">24</span>
                    </div>
                </div>
    		</div>
    	</div>
    	<div class="card mb-4">
    		<div class="card-header" id="headingTwo">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0 collapsed" data-toggle="collapse" data-target="##collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
    				Price
    				</button>
    			</h5>
    		</div>
    		<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="##accordion">
                <div class="card-body">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="price">
                      <label class="form-check-label" for="price">Price 1</label>
                      <span class="badge badge-secondary float-right mt-1">24</span>
                    </div>
                </div>
    		</div>
    	</div>
    	<div class="card mb-4">
    		<div class="card-header" id="headingThree">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0 collapsed" data-toggle="collapse" data-target="##collapseThree" aria-expanded="false" aria-controls="collapseThree">
    				Brand
    				</button>
    			</h5>
    		</div>
    		<div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="##accordion">
                <div class="card-body">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="brand">
                      <label class="form-check-label" for="type">Brand 1</label>
                      <span class="badge badge-secondary float-right mt-1">24</span>
                    </div>
                </div>
    		</div>
    	</div>
        <div class="card mb-4">
    		<div class="card-header" id="headingThree">
    			<h5 class="mb-0">
    				<button class="btn btn-link p-0 collapsed" data-toggle="collapse" data-target="##collapseThree" aria-expanded="false" aria-controls="collapseThree">
    				Options
    				</button>
    			</h5>
    		</div>
    		<div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="##accordion">
                <div class="card-body">
                    <div class="form-check">
                      <input class="form-check-input" type="checkbox" value="" id="options">
                      <label class="form-check-label" for="type">Option 1</label>
                      <span class="badge badge-secondary float-right mt-1">24</span>
                    </div>
                </div>
    		</div>
    	</div>
    </div>
</div>
</cfoutput>