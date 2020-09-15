<cfimport prefix="swc" taglib="../tags" />
<cfinclude template="inc/header.cfm" />

<cfoutput>
  
  <!--- Page Content--->
  <!--- Hero slider--->
  <section class="cz-carousel cz-controls-lg">
    <div class="cz-carousel-inner" data-carousel-options="{&quot;mode&quot;: &quot;gallery&quot;, &quot;responsive&quot;: {&quot;0&quot;:{&quot;nav&quot;:true, &quot;controls&quot;: false},&quot;992&quot;:{&quot;nav&quot;:false, &quot;controls&quot;: true}}}">
      <!--- Item--->
      <div class="px-lg-5" style="background-color: ##3aafd2;">
        <div class="d-lg-flex justify-content-between align-items-center pl-lg-4"><img class="d-block order-lg-2 mr-lg-n5 flex-shrink-0" src="img/home/hero-slider/01.jpg" alt="Summer Collection">
          <div class="position-relative mx-auto mr-lg-n5 py-5 px-4 mb-lg-5 order-lg-1" style="max-width: 42rem; z-index: 10;">
            <div class="pb-lg-5 mb-lg-5 text-center text-lg-left text-lg-nowrap">
              <h2 class="text-light font-weight-light pb-1 from-left">Has just arrived!</h2>
              <h1 class="text-light display-4 from-left delay-1">Huge Summer Collection</h1>
              <p class="font-size-lg text-light pb-3 from-left delay-2">Swimwear, Tops, Shorts, Sunglasses &amp; much more...</p><a class="btn btn-primary scale-up delay-4" href="shop-grid-ls.html">Shop Now<i class="czi-arrow-right ml-2 mr-n1"></i></a>
            </div>
          </div>
        </div>
      </div>
      <!--- Item--->
      <div class="px-lg-5" style="background-color: ##f5b1b0;">
        <div class="d-lg-flex justify-content-between align-items-center pl-lg-4"><img class="d-block order-lg-2 mr-lg-n5 flex-shrink-0" src="img/home/hero-slider/02.jpg" alt="Women Sportswear">
          <div class="position-relative mx-auto mr-lg-n5 py-5 px-4 mb-lg-5 order-lg-1" style="max-width: 42rem; z-index: 10;">
            <div class="pb-lg-5 mb-lg-5 text-center text-lg-left text-lg-nowrap">
              <h2 class="text-light font-weight-light pb-1 from-bottom">Hurry up! Limited time offer.</h2>
              <h1 class="text-light display-4 from-bottom delay-1">Women Sportswear Sale</h1>
              <p class="font-size-lg text-light pb-3 from-bottom delay-2">Sneakers, Keds, Sweatshirts, Hoodies &amp; much more...</p><a class="btn btn-primary scale-up delay-4" href="shop-grid-ls.html">Shop Now<i class="czi-arrow-right ml-2 mr-n1"></i></a>
            </div>
          </div>
        </div>
      </div>
      <!--- Item--->
      <div class="px-lg-5" style="background-color: ##eba170;">
        <div class="d-lg-flex justify-content-between align-items-center pl-lg-4"><img class="d-block order-lg-2 mr-lg-n5 flex-shrink-0" src="img/home/hero-slider/03.jpg" alt="Men Accessories">
          <div class="position-relative mx-auto mr-lg-n5 py-5 px-4 mb-lg-5 order-lg-1" style="max-width: 42rem; z-index: 10;">
            <div class="pb-lg-5 mb-lg-5 text-center text-lg-left text-lg-nowrap">
              <h2 class="text-light font-weight-light pb-1 from-top">Complete your look with</h2>
              <h1 class="text-light display-4 from-top delay-1">New Men's Accessories</h1>
              <p class="font-size-lg text-light pb-3 from-top delay-2">Hats &amp; Caps, Sunglasses, Bags &amp; much more...</p><a class="btn btn-primary scale-up delay-4" href="shop-grid-ls.html">Shop Now<i class="czi-arrow-right ml-2 mr-n1"></i></a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!--- Popular categories--->
  <section class="container position-relative pt-3 pt-lg-0 pb-5 mt-lg-n10" style="z-index: 10;">
    <div class="row">
      <div class="col-xl-8 col-lg-9">
        <div class="card border-0 box-shadow-lg">
          <div class="card-body px-3 pt-grid-gutter pb-0">
            <div class="row no-gutters pl-1">
              <div class="col-sm-4 px-2 mb-grid-gutter"><a class="d-block text-center text-decoration-none mr-1" href="shop-grid-ls.html"><img class="d-block rounded mb-3" src="img/home/categories/cat-sm01.jpg" alt="Men">
                  <h3 class="font-size-base pt-1 mb-0">Men</h3></a></div>
              <div class="col-sm-4 px-2 mb-grid-gutter"><a class="d-block text-center text-decoration-none mr-1" href="shop-grid-ls.html"><img class="d-block rounded mb-3" src="img/home/categories/cat-sm02.jpg" alt="Women">
                  <h3 class="font-size-base pt-1 mb-0">Women</h3></a></div>
              <div class="col-sm-4 px-2 mb-grid-gutter"><a class="d-block text-center text-decoration-none mr-1" href="shop-grid-ls.html"><img class="d-block rounded mb-3" src="img/home/categories/cat-sm03.jpg" alt="Kids">
                  <h3 class="font-size-base pt-1 mb-0">Kids</h3></a></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!--- Products grid (Trending products)--->
  <section class="container pt-md-3 pb-5 mb-md-3">
    <h2 class="h3 text-center">Trending products</h2>
    <div class="row pt-4 mx-n2">
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/01.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Sneakers &amp; Keds</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Women Colorblock Sneakers</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$154.<small>00</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size1" id="s-75">
                <label class="custom-option-label" for="s-75">7.5</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size1" id="s-80" checked>
                <label class="custom-option-label" for="s-80">8</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size1" id="s-85">
                <label class="custom-option-label" for="s-85">8.5</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size1" id="s-90">
                <label class="custom-option-label" for="s-90">9</label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card"><span class="badge badge-danger badge-shadow">Sale</span>
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/02.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Women’s T-shirt</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Cotton Lace Blouse</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$28.<small>50</small></span>
                <del class="font-size-sm text-muted">$38.<small>50</small></del>
              </div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color1" id="white" checked>
                <label class="custom-option-label rounded-circle" for="white"><span class="custom-option-color rounded-circle" style="background-color: ##eaeaeb;"></span></label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color1" id="blue">
                <label class="custom-option-label rounded-circle" for="blue"><span class="custom-option-color rounded-circle" style="background-color: ##d1dceb;"></span></label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color1" id="yellow">
                <label class="custom-option-label rounded-circle" for="yellow"><span class="custom-option-color rounded-circle" style="background-color: ##f4e6a2;"></span></label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color1" id="pink">
                <label class="custom-option-label rounded-circle" for="pink"><span class="custom-option-color rounded-circle" style="background-color: ##f3dcff;"></span></label>
              </div>
            </div>
            <div class="d-flex mb-2">
              <select class="custom-select custom-select-sm mr-2">
                <option>XS</option>
                <option>S</option>
                <option>M</option>
                <option>L</option>
                <option>XL</option>
              </select>
              <button class="btn btn-primary btn-sm" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            </div>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/03.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Women’s Shorts</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Mom High Waist Shorts</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$39.<small>50</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size2" id="xs">
                <label class="custom-option-label" for="xs">XS</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size2" id="s" checked>
                <label class="custom-option-label" for="s">S</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size2" id="m">
                <label class="custom-option-label" for="m">M</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size2" id="l">
                <label class="custom-option-label" for="l">L</label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/07.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Women's Swimwear</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Two-Piece Bikini in Print</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$18.<small>99</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size4" id="xs3" checked>
                <label class="custom-option-label" for="xs3">XS</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size4" id="s3">
                <label class="custom-option-label" for="s3">S</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size4" id="m3">
                <label class="custom-option-label" for="m3">M</label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/04.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Sportswear</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Women Sports Jacket</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$68.<small>40</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size3" id="xs2" checked>
                <label class="custom-option-label" for="xs2">XS</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size3" id="s2">
                <label class="custom-option-label" for="s2">S</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size3" id="m2">
                <label class="custom-option-label" for="m2">M</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size3" id="l2">
                <label class="custom-option-label" for="l2">L</label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/05.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Men’s Sunglasses</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Polarized Sunglasses</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-muted font-size-sm">Out of stock</span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden"><a class="btn btn-secondary btn-sm btn-block mb-2" href="shop-single-v1.html">View details</a>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/06.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Backpacks</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">TH Jeans City Backpack</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$79.<small>50</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color2" id="khaki" checked>
                <label class="custom-option-label rounded-circle" for="khaki"><span class="custom-option-color rounded-circle" style="background-color: ##97947c;"></span></label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color2" id="jeans">
                <label class="custom-option-label rounded-circle" for="jeans"><span class="custom-option-color rounded-circle" style="background-color: ##99a8be;"></span></label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="color2" id="white2">
                <label class="custom-option-label rounded-circle" for="white2"><span class="custom-option-color rounded-circle" style="background-color: ##eaeaeb;"></span></label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="#cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="#quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
      <!--- Product--->
      <div class="col-lg-3 col-md-4 col-sm-6 px-2 mb-4">
        <div class="card product-card">
          <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/25.jpg" alt="Product"></a>
          <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Women's Sneakers</a>
            <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Leather High-Top Sneakers</a></h3>
            <div class="d-flex justify-content-between">
              <div class="product-price"><span class="text-accent">$215.<small>00</small></span></div>
              <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
              </div>
            </div>
          </div>
          <div class="card-body card-body-hidden">
            <div class="text-center pb-2">
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size5" id="s4-80">
                <label class="custom-option-label" for="s4-80">8</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size5" id="s4-85" checked>
                <label class="custom-option-label" for="s4-85">8.5</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size5" id="s4-90">
                <label class="custom-option-label" for="s4-90">9</label>
              </div>
              <div class="custom-control custom-option custom-control-inline mb-2">
                <input class="custom-control-input" type="radio" name="size5" id="s4-95">
                <label class="custom-option-label" for="s4-95">9.5</label>
              </div>
            </div>
            <button class="btn btn-primary btn-sm btn-block mb-2" type="button" data-toggle="toast" data-target="##cart-toast"><i class="czi-cart font-size-sm mr-1"></i>Add to Cart</button>
            <div class="text-center"><a class="nav-link-style font-size-ms" href="##quick-view" data-toggle="modal"><i class="czi-eye align-middle mr-1"></i>Quick view</a></div>
          </div>
        </div>
        <hr class="d-sm-none">
      </div>
    </div>
    <div class="text-center pt-3"><a class="btn btn-outline-accent" href="shop-grid-ls.html">More products<i class="czi-arrow-right ml-1"></i></a></div>
  </section>
  <!--- Banners--->
  <section class="container pb-4 mb-md-3">
    <div class="row">
      <div class="col-md-8 mb-4">
        <div class="d-sm-flex justify-content-between align-items-center bg-secondary overflow-hidden rounded-lg">
          <div class="py-4 my-2 my-md-0 py-md-5 px-4 ml-md-3 text-center text-sm-left">
            <h4 class="font-size-lg font-weight-light mb-2">Hurry up! Limited time offer</h4>
            <h3 class="mb-4">Converse All Star on Sale</h3><a class="btn btn-primary btn-shadow btn-sm" href="##">Shop Now</a>
          </div><img class="d-block ml-auto" src="img/shop/catalog/banner.jpg" alt="Shop Converse">
        </div>
      </div>
      <div class="col-md-4 mb-4">
        <div class="d-flex flex-column h-100 justify-content-center bg-size-cover bg-position-center rounded-lg" style="background-image: url(img/blog/banner-bg.jpg);">
          <div class="py-4 my-2 px-4 text-center">
            <div class="py-1">
              <h5 class="mb-2">Your Add Banner Here</h5>
              <p class="font-size-sm text-muted">Hurry up to reserve your spot</p><a class="btn btn-primary btn-shadow btn-sm" href="##">Contact us</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!--- Featured category (Hoodie)--->
  <section class="container mb-4 pb-3 pb-sm-0 mb-sm-5">
    <div class="row">
      <!--- Banner with controls--->
      <div class="col-md-5">
        <div class="d-flex flex-column h-100 overflow-hidden rounded-lg" style="background-color: ##e2e9ef;">
          <div class="d-flex justify-content-between px-grid-gutter py-grid-gutter">
            <div>
              <h3 class="mb-1">Hoodie day</h3><a class="font-size-md" href="shop-grid-ls.html">Shop hoodies<i class="czi-arrow-right font-size-xs align-middle ml-1"></i></a>
            </div>
            <div class="cz-custom-controls" id="hoodie-day">
              <button type="button"><i class="czi-arrow-left"></i></button>
              <button type="button"><i class="czi-arrow-right"></i></button>
            </div>
          </div><a class="d-none d-md-block mt-auto" href="shop-grid-ls.html"><img class="d-block w-100" src="img/home/categories/cat-lg04.jpg" alt="For Women"></a>
        </div>
      </div>
      <!--- Product grid (carousel)--->
      <div class="col-md-7 pt-4 pt-md-0">
        <div class="cz-carousel">
          <div class="cz-carousel-inner" data-carousel-options="{&quot;nav&quot;: false, &quot;controlsContainer&quot;: &quot;##hoodie-day&quot;}">
            <!--- Carousel item--->
            <div>
              <div class="row mx-n2">
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/20.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$24.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/21.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$26.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static"><span class="badge badge-danger badge-shadow">Sale</span>
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/23.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$17.<small>99</small></span>
                          <del class="font-size-sm text-muted">24.<small>99</small></del>
                        </div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/51.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Mono Color Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$21.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4 d-none d-lg-block">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/24.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$24.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4 d-none d-lg-block">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/54.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Mono Color Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$21.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!--- Carousel item--->
            <div>
              <div class="row mx-n2">
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4 d-none d-lg-block">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/53.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Mono Color Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$21.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4 d-none d-lg-block">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/52.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Printed Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$25.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/22.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$24.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/56.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Printed Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$25.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/55.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$24.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-lg-4 col-6 px-0 px-sm-2 mb-sm-4">
                  <div class="card product-card card-static">
                    <button class="btn-wishlist btn-sm" type="button" data-toggle="tooltip" data-placement="left" title="Add to wishlist"><i class="czi-heart"></i></button><a class="card-img-top d-block overflow-hidden" href="shop-single-v1.html"><img src="img/shop/catalog/57.jpg" alt="Product"></a>
                    <div class="card-body py-2"><a class="product-meta d-block font-size-xs pb-1" href="##">Hoodies &amp; Sweatshirts</a>
                      <h3 class="product-title font-size-sm"><a href="shop-single-v1.html">Block-colored Hooded Top</a></h3>
                      <div class="d-flex justify-content-between">
                        <div class="product-price"><span class="text-accent">$23.<small>99</small></span></div>
                        <div class="star-rating"><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star-filled active"></i><i class="sr-star czi-star"></i><i class="sr-star czi-star"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!--- Shop by brand--->
  <section class="container py-lg-4 mb-4">
    <h2 class="h3 text-center pb-4">Shop by brand</h2>
    <div class="row">
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/01.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/02.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/03.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/04.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/05.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/06.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/07.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/08.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/09.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/10.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/11.png" style="width: 150px;" alt="Brand"></a></div>
      <div class="col-md-3 col-sm-4 col-6"><a class="d-block bg-white box-shadow-sm rounded-lg py-3 py-sm-4 mb-grid-gutter" href="##"><img class="d-block mx-auto" src="img/shop/brands/12.png" style="width: 150px;" alt="Brand"></a></div>
    </div>
  </section>

</cfoutput>

<cfinclude template="inc/footer.cfm" />
