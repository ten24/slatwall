(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[18],{527:function(e,t,a){"use strict";a.r(t);var c=a(2),r=a(23),s=a(6),i=a(1),n=a(26),o=a(0),d=function(e){var t=e.title,a=void 0===t?"":t,c=e.children;return Object(o.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(o.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(o.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(o.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:a})}),Object(o.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:c})]})})},l=a(66),u=a.n(l),p=a(32),j=function(e){var t=e.productID,a=e.skuID,r=e.imageFile,d=Object(p.g)(),l=Object(s.a)(d,2),j=l[0],b=l[1],m=Object(i.useState)({nav1:null,nav2:null}),O=Object(s.a)(m,2),h=O[0],f=O[1],g=Object(i.useRef)(),v=Object(i.useRef)();Object(i.useEffect)((function(){f({nav1:g.current,nav2:v.current}),j.isLoaded||j.isFetching||b(Object(c.a)(Object(c.a)({},j),{},{isFetching:!0,isLoaded:!1,params:{productID:t},makeRequest:!0}))}),[j,b,t]);var x=j.isLoaded?j.data.images.filter((function(e){var t=e.ASSIGNEDSKUIDLIST,c=void 0!==t&&t;return"skuDefaultImage"===e.TYPE||c&&c.includes(a)})):[];return 0===x.length&&(x=[{ORIGINALPATH:"",NAME:""}]),x.unshift(x.splice(x.findIndex((function(e){return e.ORIGINALFILENAME===r})),1)[0]),Object(o.jsxs)("div",{className:"col-lg-6 pr-lg-5 pt-0",children:[Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsxs)("div",{className:"cz-preview-item active",id:"first",children:[Object(o.jsx)("div",{children:Object(o.jsx)(u.a,{arrows:!1,asNavFor:h.nav2,ref:function(e){return g.current=e},children:j.isLoaded&&x.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.I,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"500px"}},a)}))})}),Object(o.jsx)("div",{className:"cz-image-zoom-pane"})]})})}),Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsx)("div",{className:"cz-preview-item active",id:"first",children:Object(o.jsx)("div",{children:x.length>1&&Object(o.jsx)(u.a,{arrows:!1,infinite:x.length>3,asNavFor:h.nav1,ref:function(e){return v.current=e},slidesToShow:3,swipeToSlide:!0,focusOnSelect:!0,children:j.isLoaded&&x.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.I,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"100px"}},a)}))})})})})})]})},b=a(30),m=a(8),O=a(39),h=["productID","productName","productCode","productFeaturedFlag","productDisplay"],f=function(e){var t=e.product,a=void 0===t?{}:t,r=e.attributeSets,s=void 0===r?[]:r,i=Object(b.a)().t,n=s.map((function(e){return Object(c.a)(Object(c.a)({},e),{},{attributes:e.attributes.filter((function(e){return e.attributeCode in a&&!h.includes(e.attributeCode)&&" "!==a[e.attributeCode]})).sort((function(e,t){return e.sortOrder-t.sortOrder}))})})).filter((function(e){return e.attributes.length}));return Object(o.jsxs)("div",{className:"accordion mb-4",id:"productPanels",children:[n.map((function(e){return Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{href:"#".concat(e.attributeSetCode),role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":e.attributeSetCode,children:[Object(o.jsx)("i",{className:"far fa-key font-size-lg align-middle mt-n1 mr-2"}),e.attributeSetName,Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse show",id:e.attributeSetCode,"data-parent":"#productPanels",children:Object(o.jsx)("div",{className:"card-body font-size-sm",children:e.attributes.map((function(e){var t=e.attributeName,c=e.attributeCode;return Object(o.jsxs)("div",{className:"font-size-sm row",children:[Object(o.jsx)("div",{className:"col-6",children:Object(o.jsx)("ul",{style:{margin:0,padding:0},children:t})}),Object(o.jsx)("div",{className:"col-6 text-muted",children:Object(o.jsx)("ul",{style:{margin:0,padding:0},children:Object(O.d)(a[c])?Object(O.a)(a[c]):a[c]})})]},c)}))})})]},e.attributeSetCode)})),Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{className:"collapsed",href:"#questions",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"questions",children:[Object(o.jsx)("i",{className:"far fa-question-circle font-size-lg align-middle mt-n1 mr-2"}),i("frontend.product.questions.heading"),Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse",id:"questions","data-parent":"#productPanels",children:Object(o.jsxs)("div",{className:"card-body",children:[Object(o.jsx)("p",{children:i("frontend.product.questions.detail")}),Object(o.jsx)(m.b,{to:"/contact",children:i("frontend.nav.contact")})]})})]})]})},g=a(17),v=a(3),x=a(22),N=a.n(x),I=a(12),D=function(e){e.productID;var t=e.skuOptionDetails,a=e.availableSkuOptions,n=e.sku,d=(e.skuID,Object(i.useState)({optionCode:"",optionGroupCode:""})),l=Object(s.a)(d,2),u=l[0],p=l[1],j=Object(v.d)((function(e){return e.cart})).isFetching,m=Object(I.h)(),h=Object(I.g)(),f=Object(b.a)().t,g=N.a.parse(m.search,{arrayFormat:"separator",arrayFormatSeparator:","});0===u.optionGroupCode.length&&Object.keys(g).length>0&&p({optionCode:Object.entries(g)[0][0],optionGroupCode:Object.entries(g)[0][1]});var x=function(){var e=t;return e.forEach((function(e){e.options=e.options.map((function(e){return e.active=!0,e}))})),u.optionGroupCode.length>0&&e.forEach((function(e){e.options=e.options.map((function(t){return t.active=e.optionGroupCode===u.optionGroupCode||a.includes(t.optionID),t}))})),e}();return Object(i.useEffect)((function(){var e={};if(x.forEach((function(t){var a=t.options.filter((function(e){return e.active}));1===a.length&&(e[t.optionGroupCode]=a[0].optionCode)})),Object.keys(e)&&JSON.stringify(Object(c.a)(Object(c.a)({},e),g)).length!==JSON.stringify(g).length&&!g.skuid&&(console.log("Redirect because of foreced Selection"),h.push({pathname:m.pathname,search:N.a.stringify(Object(c.a)(Object(c.a)({},e),g),{arrayFormat:"comma"})})),g.skuid&&n){console.log("Redirect to passed Sku",t);var a=Object(O.f)(n.selectedOptionIDList,t);h.push({pathname:m.pathname,search:N.a.stringify(Object.assign.apply(Object,Object(r.a)(a)),{arrayFormat:"comma"})})}}),[h,x,m,g,n,t]),Object(o.jsx)(o.Fragment,{children:x.length>0&&x.map((function(e){var t=e.optionGroupName,a=e.options,c=e.optionGroupID,r=e.optionGroupCode,s=g[r]||"select";return Object(o.jsxs)("div",{className:"form-group",children:[Object(o.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(o.jsx)("label",{className:"font-weight-medium",htmlFor:c,children:t})}),Object(o.jsxs)("select",{className:"custom-select",required:!0,disabled:j,value:s,id:c,onChange:function(e){var t=function(e,t,a){return e.filter((function(e){return t===e.optionGroupCode})).map((function(e){return e.options.filter((function(e){return a===e.optionCode}))})).flat().shift()}(x,r,e.target.value);!function(e,t,a){delete g.skuid,p({optionCode:t,optionGroupCode:e}),a||(g={}),g[e]=t,h.push({pathname:m.pathname,search:N.a.stringify(g,{arrayFormat:"comma"})})}(r,t.optionCode,t.active)},children:["select"===s&&Object(o.jsx)("option",{className:"option nonactive",value:"select",children:f("frontend.product.select")}),a&&a.map((function(e){return Object(o.jsxs)("option",{className:"option ".concat(e.active?"active":"nonactive"),value:e.optionCode,children:[e.active&&e.optionName,!e.active&&e.optionName+" - "+f("frontend.product.na")]},e.optionID)}))]})]},c)}))})},y=function(e){var t=e.product,a=e.attributeSets,c=e.skuID,d=e.sku,l=e.productOptions,u=void 0===l?[]:l,p=e.availableSkuOptions,m=void 0===p?"":p,O=(e.isFetching,Object(v.c)()),h=Object(b.a)().t,x=Object(v.d)((function(e){return e.cart})),N=Object(i.useState)(1),I=Object(s.a)(N,2),y=I[0],k=I[1];return Object(o.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5",children:Object(o.jsx)("div",{className:"px-lg-3",children:Object(o.jsxs)("div",{className:"row",children:[Object(o.jsx)(j,{productID:t.productID,skuID:c}),Object(o.jsx)("div",{className:"col-lg-6 pt-0",children:Object(o.jsxs)("div",{className:"product-details pb-3",children:[Object(o.jsxs)("div",{className:"d-flex justify-content-between align-items-center mb-2",children:[Object(o.jsxs)("span",{className:"d-inline-block font-size-sm align-middle px-2 bg-primary text-light",children:[" ",!0===t.productClearance&&" On Special"]}),c&&Object(o.jsx)(n.p,{skuID:c,className:"btn-wishlist mr-0"})]}),Object(o.jsx)("h2",{className:"h4 mb-2",children:t.productName}),Object(o.jsxs)("div",{className:"mb-2",children:[Object(o.jsx)("span",{className:"text-small text-muted",children:"SKU: "}),d&&Object(o.jsx)("span",{className:"font-weight-normal text-large text-accent mr-1",children:d.skuCode})]}),Object(o.jsx)("div",{className:"mb-3 font-weight-light font-size-small text-muted",dangerouslySetInnerHTML:{__html:t.productDescription}}),Object(o.jsxs)("form",{className:"mb-grid-gutter",onSubmit:function(e){return e.preventDefault()},children:[u.length>0&&Object(o.jsx)(D,{productID:t.productID,skuOptionDetails:u,availableSkuOptions:m,sku:d,skuID:c}),Object(o.jsx)("div",{className:"mb-3",children:d&&Object(o.jsx)(n.D,{salePrice:d.price,listPrice:d.listPrice})}),Object(o.jsxs)("div",{className:"form-group d-flex align-items-center",children:[Object(o.jsx)("select",{value:y,onChange:function(e){k(e.target.value)},className:"custom-select mr-3",style:{width:"5rem"},children:d&&d.calculatedQATS>0&&Object(r.a)(Array(d.calculatedQATS>20?20:d.calculatedQATS).keys()).map((function(e,t){return Object(o.jsx)("option",{value:t+1,children:t+1},t+1)}))}),Object(o.jsxs)(n.f,{disabled:x.isFetching||!c,isLoading:x.isFetching,className:"btn btn-primary btn-block",onClick:function(e){O(Object(g.l)(d.skuID,y)),window.scrollTo({top:0,behavior:"smooth"})},children:[Object(o.jsx)("i",{className:"far fa-shopping-cart font-size-lg mr-2"}),h("frontend.product.add_to_cart")]})]})]}),Object(o.jsx)(f,{product:t,attributeSets:a})]})})]})})})},k=a(4),S=a(85),L=function(e){var t=e.productID,a=Object(b.a)().t,r=Object(i.useState)({products:[],isLoaded:!1,err:"",productID:t}),n=Object(s.a)(r,2),d=n[0],l=n[1];return d.productID!==t&&l({products:[],isLoaded:!1,err:"",productID:t}),Object(i.useEffect)((function(){var e=!1;return d.isLoaded||k.a.products.getRelatedProducts({productID:t}).then((function(t){if(t.isSuccess()&&!e){var a=t.success().relatedProducts;Object(O.e)(a,"relatedProduct_",""),l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,products:a}))}else l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,err:"oops"}))})),function(){e=!0}}),[d,l,t]),Object(o.jsx)(S.a,{title:a("frontend.product.related"),sliderData:d.products})},C=a(145),F=a(46),w=function(e,t){var a=N.a.parse(e,{arrayFormat:"separator",arrayFormatSeparator:","});return Object.keys(a).map((function(e){return t.map((function(t){var c=t.options.filter((function(t){return t.optionCode===a[e]}))[0];return c?c.optionID:null})).filter((function(e){return e}))})).join()};t.default=function(e){var t=Object(I.h)(),a=t.pathname,l=t.search,u=Object(p.f)(),j=Object(s.a)(u,2),b=j[0],m=j[1],O=Object(p.d)(),h=Object(s.a)(O,2),f=h[0],g=h[1],x=Object(v.d)(F.c),D=Object(I.h)(),k=Object(I.g)(),S=Object(i.useState)(a),G=Object(s.a)(S,2),T=G[0],z=G[1],P=N.a.parse(l,{arrayFormat:"separator",arrayFormatSeparator:","}),A=Object(v.d)((function(e){return e.configuration.filtering.productTypeBase}));if(Object(i.useEffect)((function(){if(f.isLoaded&&!Object.keys(P).length){console.log("Redirect to Default Sku");var e=(t=f.data.defaultSelectedOptions,f.data.optionGroups.map((function(e){return e.options.filter((function(e){return t.includes(e.optionID)})).map((function(t){var a={};return a[e.optionGroupCode]=t.optionCode,a}))})).flat());k.push({pathname:D.pathname,search:N.a.stringify(Object.assign.apply(Object,Object(r.a)(e)),{arrayFormat:"comma"})})}var t;if(f.isLoaded&&!b.isFetching&&!b.isLoaded){var a=w(l,f.data.optionGroups);m(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data.productID,skuID:P.skuid,selectedOptionIDList:a.length?a:f.data.defaultSelectedOptions},makeRequest:!0}))}k.listen((function(e){if(!f.isFetching&&f.isLoaded){var t=w(e.search,f.data.optionGroups);m(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data.productID,selectedOptionIDList:t},makeRequest:!0}))}}))}),[k,m,b,P,l,D,f]),!f.isFetching&&f.isLoaded&&f.data&&0===Object.keys(f.data).length)return Object(o.jsx)(I.a,{to:"/404"});if(a!==T&&(console.log("Refresh all"),z(a)),!f.isFetching&&!f.isLoaded){var R=a.split("/").reverse();z(a),g(Object(c.a)(Object(c.a)({},f),{},{params:{urlTitle:R[0]},entity:"product",makeRequest:!0,isFetching:!0,isLoaded:!1}))}return Object(o.jsx)(n.t,{children:Object(o.jsxs)("div",{className:"bg-light p-0",children:[f.isLoaded&&Object(o.jsx)(d,{title:f.data.productSeries,children:Object(o.jsx)(n.e,{crumbs:f.data.breadcrumbs.map((function(e){return{title:e.productTypeName,urlTitle:"/".concat(x,"/").concat(e.urlTitle)}})).filter((function(e){return e.urlTitle!=="/".concat(x,"/").concat(A)}))})}),f.isLoaded&&Object(o.jsx)(C.a,{title:f.data.settings.productHTMLTitleString}),f.isLoaded&&f.data.productID&&Object(o.jsx)(y,{attributeSets:f.attributeSets,product:f.data,sku:b.data.sku[0],skuID:b.data.skuID,availableSkuOptions:b.data.availableSkuOptions,productOptions:f.data.optionGroups,isFetching:b.isFetching||f.isFetching}),f.isLoaded&&f.data.productID&&Object(o.jsx)(L,{productID:f.data.productID})]})})}}}]);
//# sourceMappingURL=18.3b25fddf.chunk.js.map