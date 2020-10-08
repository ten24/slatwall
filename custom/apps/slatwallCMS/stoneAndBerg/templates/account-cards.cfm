<cfinclude template="inc/header/header.cfm" />

<cfoutput>
	
	<div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-2 mb-3 mb-lg-0 pt-lg-2">
          <nav aria-label="breadcrumb">
            <ol class="breadcrumb breadcrumb-dark flex-lg-nowrap justify-content-center justify-content-lg-start">
              <li class="breadcrumb-item"><a class="text-nowrap" href="/"><i class="far fa-home"></i>Home</a></li>
              <li class="breadcrumb-item text-nowrap"><a href="##">Account</a></li>
              <li class="breadcrumb-item text-nowrap active"><a href="##">Payment Methods</a></li>
            </ol>
          </nav>
        </div>
        <div class="order-lg-1 pr-lg-4 text-center text-lg-left">
          <h1 class="h3 mb-0">Payment Methods</h1>
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
              <h3 class="font-size-sm mb-0 text-muted"><a href="/my-account" class="nav-link-style">Overview</a></h3>
            </div>
            <ul class="list-unstyled mb-0">
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-shopping-bag pr-2"></i> Order History</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-user pr-2"></i> Profile Info</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-heart pr-2"></i> Favorties</a></li>
              <li class="border-bottom mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3" href="##"><i class="far fa-map-marker-alt pr-2"></i> Addresses</a></li>
              <li class="mb-0"><a class="nav-link-style d-flex align-items-center px-4 py-3 active" href="##"><i class="far fa-credit-card pr-2"></i> Payment Methods</a></li>
            </ul>
          </div>
        </aside>
        
        <!-- Content  -->
        <section class="col-lg-8">
          <!-- Toolbar-->
          <div class="d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3">
            <div class="d-flex justify-content-between w-100">
              <h6 class="h6">Primary payment method is used by default</h6>
            </div>
          </div>
          
          <div class="table-responsive font-size-md">
            <table class="table table-hover mb-0">
              <thead>
                <tr>
                  <th>Your credit / debit cards</th>
                  <th>Name on card</th>
                  <th>Expires on</th>
                  <th></th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td class="py-3 align-middle">
                    <div class="media align-items-center">
                      <div class="media-body"><span class="font-weight-medium text-heading mr-1">Visa</span>ending in 4999<span class="align-middle badge badge-info ml-2">Primary</span></div>
                    </div>
                  </td>
                  <td class="py-3 align-middle">Susan Gardner</td>
                  <td class="py-3 align-middle">08 / 2019</td>
                  <td class="py-3 align-middle"><a class="nav-link-style mr-2" href="##" data-toggle="tooltip" title="" data-original-title="Edit"><i class="far fa-edit"></i></a><a class="nav-link-style text-primary" href="##" data-toggle="tooltip" title="" data-original-title="Remove">
                      <i class="far fa-trash-alt"></i></a></td>
                </tr>
                <tr>
                  <td class="py-3 align-middle">
                    <div class="media align-items-center">
                      <div class="media-body"><span class="font-weight-medium text-heading mr-1">MasterCard</span>ending in 0015</div>
                    </div>
                  </td>
                  <td class="py-3 align-middle">Susan Gardner</td>
                  <td class="py-3 align-middle">11 / 2021</td>
                  <td class="py-3 align-middle"><a class="nav-link-style mr-2" href="##" data-toggle="tooltip" title="" data-original-title="Edit"><i class="far fa-edit"></i></a><a class="nav-link-style text-primary" href="##" data-toggle="tooltip" title="" data-original-title="Remove">
                      <i class="far fa-trash-alt"></i></a></td>
                </tr>
                <tr>
                  <td class="py-3 align-middle">
                    <div class="media align-items-center">
                      <div class="media-body"><span class="font-weight-medium text-heading mr-1">Visa</span>ending in 6073</div>
                    </div>
                  </td>
                  <td class="py-3 align-middle">Susan Gardner</td>
                  <td class="py-3 align-middle">09 / 2021</td>
                  <td class="py-3 align-middle"><a class="nav-link-style mr-2" href="##" data-toggle="tooltip" title="" data-original-title="Edit"><i class="far fa-edit"></i></a><a class="nav-link-style text-primary" href="##" data-toggle="tooltip" title="" data-original-title="Remove">
                      <i class="far fa-trash-alt"></i></a></td>
                </tr>
                <tr>
                  <td class="py-3 align-middle">
                    <div class="media align-items-center">
                      <div class="media-body"><span class="font-weight-medium text-heading mr-1">Visa</span>ending in 9791</div>
                    </div>
                  </td>
                  <td class="py-3 align-middle">Susan Gardner</td>
                  <td class="py-3 align-middle">05 / 2021</td>
                  <td class="py-3 align-middle"><a class="nav-link-style mr-2" href="##" data-toggle="tooltip" title="" data-original-title="Edit"><i class="far fa-edit"></i></a><a class="nav-link-style text-primary" href="##" data-toggle="tooltip" title="" data-original-title="Remove">
                      <i class="far fa-trash-alt"></i></a></td>
                </tr>
              </tbody>
            </table>
          </div>
          <hr class="pb-4">
          <div class="text-sm-right"><a class="btn btn-primary" href="##add-address" data-toggle="modal">Add new address</a></div>
        </section>
      </div>
    </div>
    
</cfoutput>
<cfinclude template="inc/footer.cfm" />
