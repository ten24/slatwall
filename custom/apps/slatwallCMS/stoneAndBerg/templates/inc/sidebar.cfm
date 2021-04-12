<cfoutput>
<div class="cz-sidebar rounded-lg box-shadow-lg" id="shop-sidebar">
  <div class="cz-sidebar-header box-shadow-sm">
    <button class="close ml-auto" type="button" data-dismiss="sidebar" aria-label="Close"><span class="d-inline-block font-size-xs font-weight-normal align-middle">Close sidebar</span><span class="d-inline-block align-middle ml-2" aria-hidden="true"><i class="far fa-times"></i></span></button>
  </div>
  <div class="cz-sidebar-body" data-simplebar data-simplebar-auto-hide="true">
    <!-- Categories-->
    <div class="widget widget-categories mb-3">
      <div class="row">
        <h3 class="widget-title col">Filters</h3>
        <span class="text-right col">287 Results</span>
      </div>
      <div class="input-group-overlay input-group-sm mb-2">
        <input class="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search by product title or SKU">
        <div class="input-group-append-overlay"><span class="input-group-text"><i class="fa fa-search"></i></span></div>
      </div>
      <div class="accordion mt-3 border-top" id="shop-categories">
        <!--- Product Type --->
        <div class="card border-bottom pt-1 pb-2 my-1">
          <div class="card-header">
            <h3 class="accordion-heading"><a class="collapsed" href="##productType" role="button" data-toggle="collapse" aria-expanded="false" aria-controls="productType">Product Type<span class="accordion-indicator"></span></a></h3>
          </div>
          <div class="collapse" id="productType" data-parent="##shop-categories" style="">
            <div class="card-body">
              <div class="widget widget-links cz-filter">
                <div class="input-group-overlay input-group-sm mb-2">
                  <input class="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search">
                  <div class="input-group-append-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
                </div>
                <ul class="widget-list cz-filter-list pt-1" style="height: 12rem;" data-simplebar data-simplebar-auto-hide="false">
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">View all</span><span class="font-size-xs text-muted ml-3">1,953</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Pumps &amp; High Heels</span><span class="font-size-xs text-muted ml-3">247</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ballerinas &amp; Flats</span><span class="font-size-xs text-muted ml-3">156</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sandals</span><span class="font-size-xs text-muted ml-3">310</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sneakers</span><span class="font-size-xs text-muted ml-3">402</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Boots</span><span class="font-size-xs text-muted ml-3">393</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ankle Boots</span><span class="font-size-xs text-muted ml-3">50</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Loafers</span><span class="font-size-xs text-muted ml-3">93</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Slip-on</span><span class="font-size-xs text-muted ml-3">122</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Flip Flops</span><span class="font-size-xs text-muted ml-3">116</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Clogs &amp; Mules</span><span class="font-size-xs text-muted ml-3">24</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Athletic Shoes</span><span class="font-size-xs text-muted ml-3">31</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Oxfords</span><span class="font-size-xs text-muted ml-3">9</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Smart Shoes</span><span class="font-size-xs text-muted ml-3">18</span></a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <!--- Brand --->
        <div class="card border-bottom pt-1 pb-2 my-1">
          <div class="card-header">
            <h3 class="accordion-heading"><a href="##brand" role="button" data-toggle="collapse" aria-expanded="false" aria-controls="brand" class="collapsed">Brand<span class="accordion-indicator"></span></a></h3>
          </div>
          <div class="collapse" id="brand" data-parent="##shop-categories" style="">
            <div class="card-body">
              <div class="widget widget-links cz-filter">
                <div class="input-group-overlay input-group-sm mb-2">
                  <input class="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search">
                  <div class="input-group-append-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
                </div>
                <ul class="widget-list cz-filter-list pt-1" style="height: 12rem;" data-simplebar data-simplebar-auto-hide="false">
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">View all</span><span class="font-size-xs text-muted ml-3">1,953</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Pumps &amp; High Heels</span><span class="font-size-xs text-muted ml-3">247</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ballerinas &amp; Flats</span><span class="font-size-xs text-muted ml-3">156</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sandals</span><span class="font-size-xs text-muted ml-3">310</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sneakers</span><span class="font-size-xs text-muted ml-3">402</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Boots</span><span class="font-size-xs text-muted ml-3">393</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ankle Boots</span><span class="font-size-xs text-muted ml-3">50</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Loafers</span><span class="font-size-xs text-muted ml-3">93</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Slip-on</span><span class="font-size-xs text-muted ml-3">122</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Flip Flops</span><span class="font-size-xs text-muted ml-3">116</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Clogs &amp; Mules</span><span class="font-size-xs text-muted ml-3">24</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Athletic Shoes</span><span class="font-size-xs text-muted ml-3">31</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Oxfords</span><span class="font-size-xs text-muted ml-3">9</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Smart Shoes</span><span class="font-size-xs text-muted ml-3">18</span></a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <!--- Style --->
        <div class="card border-bottom pt-1 pb-2 my-1">
          <div class="card-header">
            <h3 class="accordion-heading"><a class="" href="##style" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="style">Style<span class="accordion-indicator"></span></a></h3>
          </div>
          <div class="collapse show" id="style" data-parent="##shop-categories" style="">
            <div class="card-body">
              <div class="widget widget-links cz-filter">
                <div class="input-group-overlay input-group-sm mb-2">
                  <input class="cz-filter-search form-control form-control-sm appended-form-control" type="text" placeholder="Search">
                  <div class="input-group-append-overlay"><span class="input-group-text"><i class="far fa-search"></i></span></div>
                </div>
                <ul class="widget-list cz-filter-list pt-1" style="height: 12rem;" data-simplebar data-simplebar-auto-hide="false">
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">View all</span><span class="font-size-xs text-muted ml-3">1,953</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Pumps &amp; High Heels</span><span class="font-size-xs text-muted ml-3">247</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ballerinas &amp; Flats</span><span class="font-size-xs text-muted ml-3">156</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sandals</span><span class="font-size-xs text-muted ml-3">310</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Sneakers</span><span class="font-size-xs text-muted ml-3">402</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Boots</span><span class="font-size-xs text-muted ml-3">393</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Ankle Boots</span><span class="font-size-xs text-muted ml-3">50</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Loafers</span><span class="font-size-xs text-muted ml-3">93</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Slip-on</span><span class="font-size-xs text-muted ml-3">122</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Flip Flops</span><span class="font-size-xs text-muted ml-3">116</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Clogs &amp; Mules</span><span class="font-size-xs text-muted ml-3">24</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Athletic Shoes</span><span class="font-size-xs text-muted ml-3">31</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Oxfords</span><span class="font-size-xs text-muted ml-3">9</span></a></li>
                  <li class="widget-list-item cz-filter-item"><a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">Smart Shoes</span><span class="font-size-xs text-muted ml-3">18</span></a></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <!-- Finish -->
        <div class="card border-bottom pt-1 pb-2 my-1">
          <div class="card-header">
            <h3 class="accordion-heading"><a class="" href="##finish" role="button" data-toggle="collapse" aria-expanded="true" aria-controls="style">Finish<span class="accordion-indicator"></span></a></h3>
          </div>
          <div class="collapse show" id="finish" data-parent="##shop-categories" style="">
            <div class="card-body">
              <div class="widget widget-links cz-filter">
                <ul class="widget-list cz-filter-list pt-1">
                  <li class="widget-list-item cz-filter-item">
                    <a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">
                      <div class="custom-control custom-checkbox">
                        <input class="custom-control-input" type="checkbox" id="finish505">
                        <label class="custom-control-label" for="finish505">Lifetime Brass <span class="font-size-xs text-muted">505</span></label>
                      </div>
                    </a>
                  </li>
                  <li class="widget-list-item cz-filter-item">
                    <a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">
                      <div class="custom-control custom-checkbox">
                        <input class="custom-control-input" type="checkbox" checked="" id="finish605">
                        <label class="custom-control-label" for="finish605">Bright Brass <span class="font-size-xs text-muted">605 | US3</span></label>
                      </div>
                    </a>
                  </li>
                  <li class="widget-list-item cz-filter-item">
                    <a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">
                      <div class="custom-control custom-checkbox">
                        <input class="custom-control-input" type="checkbox" id="finish606">
                        <label class="custom-control-label" for="finish606">Satin Brass <span class="font-size-xs text-muted">606 | US4</span></label>
                      </div>
                    </a>
                  </li>
                  <li class="widget-list-item cz-filter-item">
                    <a class="widget-list-link d-flex justify-content-between align-items-center" href="##"><span class="cz-filter-item-text">
                      <div class="custom-control custom-checkbox">
                        <input class="custom-control-input" type="checkbox" id="finish609">
                        <label class="custom-control-label" for="finish609">Antique Brass <span class="font-size-xs text-muted">609 | US5</span></label>
                      </div>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div><!--- end .widget-categoires --->
    
  </div><!--- end .cz-sidebar-body --->
</div>
</cfoutput>