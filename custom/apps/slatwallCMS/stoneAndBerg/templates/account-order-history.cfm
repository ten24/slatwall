<cfinclude template="inc/header/header.cfm" />

<!--- This import allows for the custom tags required by this page to work --->
<cfimport prefix="sw" taglib="../tags" />

<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="/"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Account</a>
              </li>
              <li class="breadcrumb-item text-nowrap active" aria-current="page">Order History</li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">My Orders</h1>
        </div>
      </div>
    </div>
    
    <!-- Page Content-->
    <div class="container pb-5 mb-2 mb-md-3">
      <div class="row">
        <!-- Sidebar-->
        <aside class="col-lg-4 pt-4 pt-lg-0">
          <div class="cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0">
            <div class="px-4 mb-4">
              <div class="media align-items-center">
                <div class="media-body">
                  <h3 class="font-size-base mb-0">Susan Gardner</h3>
                  <a href="##" class="text-accent font-size-sm">Logout</a>
                </div>
              </div>
            </div>
            <div class="bg-secondary px-4 py-3">
              <h3 class="font-size-sm mb-0 text-muted">Overview</h3>
            </div>
            <ul class="list-unstyled mb-0">
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3 active" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-heart pr-2"></i> Favorties</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-map-marker-alt pr-2"></i> Addresses</a></li>
              <li class="mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-credit-card pr-2"></i> Payment Methods</a></li>
            </ul>
          </div>
        </aside>
        
        <!-- Content  -->
        <section class="col-lg-8">
          <!-- Toolbar-->
          <div class="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
            <div class="d-flex justify-content-between w-100">
              <div class="input-group-overlay d-lg-flex mr-3 w-50">
                <input class="form-control appended-form-control" type="text" placeholder="Search item ##, order ##, or PO">
                <div class="input-group-append-overlay">
                  <span class="input-group-text"><i class="far fa-search"></i></span>
                </div>
              </div>
              <a href="##" class="btn btn-outline-secondary"><i class="far fa-file-alt mr-2"></i> Request Statement</a>
            </div>
          </div>
          <!-- Orders list-->
          <div class="table-responsive font-size-md">
            <table class="table table-hover mb-0">
              <thead>
                <tr>
                  <th>Order ##</th>
                  <th>Date Purchased 
                    <a href="" class="s-sort-arrows">
                      <svg data-ng-show="swListingDisplay.showOrderBy" class="nc-icon outline" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 64 64">
                          <g transform="translate(0.5, 0.5)">
                              <polygon class="s-ascending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'DESC'}" fill="none" stroke="##cccccc" stroke-width="3" stroke-linecap="square" stroke-miterlimit="10" points="20,26 44,26 32,12 " stroke-linejoin="round"></polygon>
                              <polygon class="s-descending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'ASC'}" fill="none" stroke="##cccccc" stroke-width="3" stroke-linecap="square" stroke-miterlimit="10" points="44,38 20,38 32,52 " stroke-linejoin="round"></polygon>
                          </g>
                      </svg>
                    </a>
                  </th>
                  <th>Status
                    <a href="" class="s-sort-arrows">
                      <svg data-ng-show="swListingDisplay.showOrderBy" class="nc-icon outline" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="20px" height="20px" viewBox="0 0 64 64">
                          <g transform="translate(0.5, 0.5)">
                              <polygon class="s-ascending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'DESC'}" fill="none" stroke="##cccccc" stroke-width="3" stroke-linecap="square" stroke-miterlimit="10" points="20,26 44,26 32,12 " stroke-linejoin="round"></polygon>
                              <polygon class="s-descending" data-ng-class="{'s-active':swListingDisplay.columnOrderByIndex(column) == 'ASC'}" fill="none" stroke="##cccccc" stroke-width="3" stroke-linecap="square" stroke-miterlimit="10" points="44,38 20,38 32,52 " stroke-linejoin="round"></polygon>
                          </g>
                      </svg>
                    </a>
                  </th>
                  <th>Order Total</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="py-3">
                    <a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">34VB5540K83</a><br />
                    PO: 51705
                  </td>
                  <td class="py-3">May 21, 2019</td>
                  <td class="py-3"><span class="badge badge-info m-0">New</span></td>
                  <td class="py-3">$358.75</td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                  
                </tr>
                <tr>
                  <td class="py-3"><a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">78A643CD409</a></td>
                  <td class="py-3">December 09, 2018</td>
                  <td class="py-3"><span class="badge badge-danger m-0">Canceled</span></td>
                  <td class="py-3"><span>$760.50</span></td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                  
                </tr>
                <tr>
                  <td class="py-3"><a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">112P45A90V2</a></td>
                  <td class="py-3">October 15, 2018</td>
                  <td class="py-3"><span class="badge badge-warning m-0">Partially Shipped</span></td>
                  <td class="py-3">$1,264.00</td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="py-3"><a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">28BA67U0981</a></td>
                  <td class="py-3">July 19, 2018</td>
                  <td class="py-3"><span class="badge badge-success m-0">Complete</span></td>
                  <td class="py-3">$198.35</td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                  
                </tr>
                <tr>
                  <td class="py-3"><a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">502TR872W2</a></td>
                  <td class="py-3">April 04, 2018</td>
                  <td class="py-3"><span class="badge badge-success m-0">Complete</span></td>
                  <td class="py-3">$2,133.90</td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td class="py-3"><a class="nav-link-style font-weight-medium font-size-sm" href="##" data-toggle="modal">47H76G09F33</a></td>
                  <td class="py-3">March 30, 2018</td>
                  <td class="py-3"><span class="badge badge-success m-0">Complete</span></td>
                  <td class="py-3">$86.40</td>
                  <td class="py-3">
                    <div class="btn-group">
                      <button type="button" class="btn bg-white dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="far fa-shipping-fast"></i>
                      </button>
                      <div class="dropdown-menu dropdown-menu-right">
                        <span>Tracking Numbers:</span>
                        <a class="dropdown-item" href="##">573289573802</a>
                        <a class="dropdown-item" href="##">643068306672</a>
                      </div>
                    </div>
                  </td>
                </tr>
                
              </tbody>
            </table>
          </div>
          <hr class="pb-4">
          <!-- Pagination-->
          <nav class="d-flex justify-content-between pt-2" aria-label="Page navigation">
            <ul class="pagination">
              <li class="page-item"><a class="page-link" href="##"><i class="far fa-chevron-left mr-2"></i> Prev</a></li>
            </ul>
            <ul class="pagination">
              <li class="page-item d-sm-none"><span class="page-link page-link-static">1 / 5</span></li>
              <li class="page-item active d-none d-sm-block" aria-current="page"><span class="page-link">1<span class="sr-only">(current)</span></span></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">2</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">3</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">4</a></li>
              <li class="page-item d-none d-sm-block"><a class="page-link" href="##">5</a></li>
            </ul>
            <ul class="pagination">
              <li class="page-item"><a class="page-link" href="##" aria-label="Next">Next <i class="far fa-chevron-right ml-2"></i></a></li>
            </ul>
          </nav>
        </section>
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />