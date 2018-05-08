<cfoutput>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>#$.slatwall.getCurrentRequestSite().getSiteName()#</title>
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/js/jquery-ui.min.js"></script>

    <!--- This creates a client side object for Slatwall so that $.slatwall API works from the client side --->
    #$.slatwall.renderJSObject( subsystem="public" )#
    <style>
      [ng\:cloak],
      [ng-cloak],
      [data-ng-cloak],
      [x-ng-cloak],
      .ng-cloak,
      .x-ng-cloak {
        display: none !important;
      }
    </style>
    <script>
      var hibachiConfig = {
        action: 'slatAction',
        basePartialsPath: '/org/Hibachi/client/src/',
        customPartialsPath: '/custom/apps/#$.slatwall.getSite().getApp().getAppName()#/#$.slatwall.getSite().getSiteName()#/templates/partials/'
      };
    </script>
    <link href="#request.slatwallScope.getBaseURL()#/org/Hibachi/HibachiAssets/css/jquery-ui.min.css" rel="stylesheet">
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <style media="screen">
      @media (min-width: 768px) {
        .card .collapse {
          display: block;
        }
      }
    </style>

  </head>

  <body ng-cloak>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container">
      <a class="navbar-brand" href="##">#$.slatwall.getCurrentRequestSite().getSiteName()#</a>
        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item active">
              <a class="nav-link" href="##">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="##">Features</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="##">Pricing</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="##"><span ng-show="slatwall.cart.orderItems.length">Cart {{slatwall.cart.orderItems.length}}</span></a>

              <article class="cart-sec miniCart" ng-cloak style="display: block;background-color:white;position:absolute;border:thin solid ##333;z-index: 1">
                <div class="top">
                  <h3>Your Cart<span><a href="/shopping-cart">VIEW</a></span></h3>
                </div>
                <div class="mid">
                  <ul>
                    <li ng-repeat="orderItem in slatwall.cart.orderItems" swf-cart-items order-item="orderItem" class="ng-scope">
                      <i ng-class="{'fa fa-refresh fa-spin fa-fw': swfCartItems.removeOrderItemIsLoading || swfCartItems.updateOrderItemQuantityIsLoading || slatwall.getRequestByAction('getCart').loading}"></i>
                      <div class="image" ng-if="orderItem.sku.imagePath">
                        <a ng-href="/sp/{{orderItem.sku.product.productName}}"><img ng-alt="orderItem.sku.product.productName" ng-src="orderItem.sku.imagePath"></a>
                      </div>

                      <div class="text">
                        <h4>
                          <a ng-href="/sp/{{orderItem.sku.product.productName}}" class="ng-scope">
										        <span ng-bind="orderItem.sku.product.productName"></span>
									        </a>
                        </h4>
                        <div class="price-box">
                          <div class="col1">
                            <aside>
                              <span class="price" ng-bind="orderItem.price | currency"></span>
                            </aside>
                          </div>

                          <div class="col2">
                            <aside>
                              <input type="number" class="form-control" min="1" ng-value="orderItem.quantity" ng-model="newQuantity" ng-change="swfCartItems.updateOrderItemQuantity(newQuantity)">
                            </aside>
                          </div>
                        </div>

                        <a href="##" ng-click="swfCartItems.removeOrderItem()" class="delete-btn">
										    Remove Item
										</a>
                      </div>
                    </li>
                  </ul>

                </div>
                <div class="bottom">

                  <div class="price">
                    <span>ORDER Total
										<small ng-bind="slatwall.cart.orderItems.length"></small>
								</span>

                    <span ng-bind="slatwall.cart.calculatedTotal | currency" class="ng-binding"></span>
                  </div>

                  <a href="/checkout" class="black-btn">CONTINUE TO Checkout</a>
                  <div class="text-center">
                    <a href="/shopping-cart" class="view-cart">VIEW Cart</a>
                  </div>
                  <div ng-show="slatwall.successfulActions.includes('public:cart.removeOrderItem')" class="alert alert-success">Item removed from cart</div>
                  <div ng-show="slatwall.failureActions.includes('public:cart.removeOrderItem')" class="alert alert-danger">Item removed failure</div>
                  <div ng-show="slatwall.successfulActions.includes('public:cart.updateOrderItem')" class="alert alert-success">Quantity updated</div>
                  <div ng-show="slatwall.failureActions.includes('public:cart.updateOrderItem')" class="alert alert-danger">Quantity update failure</div>
                  <a href="javascript:void(0)" class="cart-close-btn">Close</a>
              </article>
            </li>
          </ul>
          </div>
        </div>
    </nav>
</cfoutput>
