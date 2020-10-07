<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header/header.cfm" />

<cfoutput>
  <div class="bg-light p-0">

    <!---- start template copy ---->
    <div class="page-title-overlap bg-lightgray pt-4">
      <div class="container d-lg-flex justify-content-between py-2 py-lg-3">
        <div class="order-lg-1 pr-lg-4 text-center">
          <h1 class="h3 text-dark mb-0 font-accent">${title}</h1>
        </div>
      </div>
    </div>
    <!-- Page Content-->
    <div class="container bg-light box-shadow-lg rounded-lg p-5">
      ${customBody}
    </div>

  </div>
</cfoutput>

<cfinclude template="inc/footer.cfm" />
