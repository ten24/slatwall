(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[19],{418:function(e,t,a){"use strict";a.r(t);var c=a(2),r=a(16),s=a(5),i=a(1),n=a(21),o=a(0),d=function(e){var t=e.title,a=void 0===t?"":t;return Object(o.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(o.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(o.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(o.jsx)(n.c,{})}),Object(o.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(o.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:a})})]})})},l=a(62),u=a.n(l),j=a(26),p=function(e){var t=e.productID,a=e.skuID,r=e.imageFile,d=Object(j.e)(),l=Object(s.a)(d,2),p=l[0],b=l[1],h=Object(i.useState)({nav1:null,nav2:null}),m=Object(s.a)(h,2),O=m[0],f=m[1],x=Object(i.useRef)(),g=Object(i.useRef)();Object(i.useEffect)((function(){f({nav1:x.current,nav2:g.current}),p.isLoaded||p.isFetching||b(Object(c.a)(Object(c.a)({},p),{},{isFetching:!0,isLoaded:!1,params:{productID:t},makeRequest:!0}))}),[p,b,t]);var v=p.isLoaded?p.data.images.filter((function(e){var t=e.ASSIGNEDSKUIDLIST,c=void 0!==t&&t;return"skuDefaultImage"===e.TYPE||c&&c.includes(a)})):[];return 0===v.length&&(v=[{ORIGINALPATH:"",NAME:""}]),v.unshift(v.splice(v.findIndex((function(e){return e.ORIGINALFILENAME===r})),1)[0]),Object(o.jsxs)("div",{className:"col-lg-6 pr-lg-5 pt-0",children:[Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsxs)("div",{className:"cz-preview-item active",id:"first",children:[Object(o.jsx)("div",{children:Object(o.jsx)(u.a,{arrows:!1,asNavFor:O.nav2,ref:function(e){return x.current=e},children:p.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"500px"}},a)}))})}),Object(o.jsx)("div",{className:"cz-image-zoom-pane"})]})})}),Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsx)("div",{className:"cz-preview-item active",id:"first",children:Object(o.jsx)("div",{children:v.length>1&&Object(o.jsx)(u.a,{arrows:!1,infinite:v.length>3,asNavFor:O.nav1,ref:function(e){return g.current=e},slidesToShow:3,swipeToSlide:!0,focusOnSelect:!0,children:p.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"100px"}},a)}))})})})})})]})},b=a(25),h=a(7),m=a(48),O=["productID","productName","productCode","productFeatured","productDisplay"],f=function(e){var t=e.product,a=void 0===t?{}:t,r=e.attributeSets,s=void 0===r?[]:r,i=Object(b.a)().t,n=s.map((function(e){return Object(c.a)(Object(c.a)({},e),{},{attributes:e.attributes.filter((function(e){return e.attributeCode in a&&!O.includes(e.attributeCode)&&" "!==a[e.attributeCode]})).sort((function(e,t){return e.sortOrder-t.sortOrder}))})})).filter((function(e){return e.attributes.length}));return Object(o.jsxs)("div",{className:"accordion mb-4",id:"productPanels",children:[n.map((function(e){return Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{href:"#".concat(e.attributeSetCode),role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":e.attributeSetCode,children:[Object(o.jsx)("i",{className:"far fa-key font-size-lg align-middle mt-n1 mr-2"}),e.attributeSetName,Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse show",id:e.attributeSetCode,"data-parent":"#productPanels",children:Object(o.jsx)("div",{className:"card-body font-size-sm",children:e.attributes.map((function(e){var t=e.attributeName,c=e.attributeCode;return Object(o.jsxs)("div",{className:"font-size-sm row",children:[Object(o.jsx)("div",{className:"col-6",children:Object(o.jsx)("ul",{style:{margin:0,padding:0},children:t})}),Object(o.jsx)("div",{className:"col-6 text-muted",children:Object(o.jsx)("ul",{style:{margin:0,padding:0},children:Object(m.c)(a[c])?Object(m.a)(a[c]):a[c]})})]})}))})})]})})),Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{className:"collapsed",href:"#questions",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"questions",children:[Object(o.jsx)("i",{className:"far fa-question-circle font-size-lg align-middle mt-n1 mr-2"}),i("frontend.product.questions.heading"),Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse",id:"questions","data-parent":"#productPanels",children:Object(o.jsxs)("div",{className:"card-body",children:[Object(o.jsx)("p",{children:i("frontend.product.questions.detail")}),Object(o.jsx)(h.b,{to:"/contact",children:i("frontend.nav.contact")})]})})]})]})},x=a(23),g=a(4),v=a(19),N=a.n(v),y=a(11),I=a(61),D=function(e){return Object(o.jsxs)(I.a,Object(c.a)(Object(c.a)({speed:2,width:400,height:150,viewBox:"0 0 400 200",backgroundColor:"#f3f3f3",foregroundColor:"#ecebeb"},e),{},{children:[Object(o.jsx)("rect",{x:"25",y:"15",rx:"5",ry:"5",width:"350",height:"20"}),Object(o.jsx)("rect",{x:"25",y:"45",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"25",y:"60",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"26",y:"75",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"27",y:"107",rx:"5",ry:"5",width:"350",height:"20"}),Object(o.jsx)("rect",{x:"26",y:"135",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"26",y:"150",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"27",y:"165",rx:"5",ry:"5",width:"350",height:"10"})]}))},k=function(e){e.productID;var t=e.skuOptionDetails,a=e.availableSkuOptions,n=e.sku,d=(e.skuID,Object(i.useState)({optionCode:"",optionGroupCode:""})),l=Object(s.a)(d,2),u=l[0],j=l[1],p=Object(y.h)(),h=Object(y.g)(),O=Object(b.a)().t,f=N.a.parse(p.search,{arrayFormat:"separator",arrayFormatSeparator:","});0===u.optionGroupCode.length&&Object.keys(f).length>0&&j({optionCode:Object.entries(f)[0][0],optionGroupCode:Object.entries(f)[0][1]});var x=function(){var e=t;return e.forEach((function(e){e.options=e.options.map((function(e){return e.active=!0,e}))})),u.optionGroupCode.length>0&&e.forEach((function(e){e.options=e.options.map((function(t){return t.active=e.optionGroupCode===u.optionGroupCode||a.includes(t.optionID),t}))})),e}();return Object(i.useEffect)((function(){var e={};if(x.forEach((function(t){var a=t.options.filter((function(e){return e.active}));1===a.length&&(e[t.optionGroupCode]=a[0].optionCode)})),Object.keys(e)&&JSON.stringify(Object(c.a)(Object(c.a)({},e),f)).length!==JSON.stringify(f).length&&!f.skuid&&(console.log("Redirect because of foreced Selection"),h.push({pathname:p.pathname,search:N.a.stringify(Object(c.a)(Object(c.a)({},e),f),{arrayFormat:"comma"})})),f.skuid&&n){console.log("Redirect to passed Sku",t);var a=Object(m.e)(n.selectedOptionIDList,t);h.push({pathname:p.pathname,search:N.a.stringify(Object.assign.apply(Object,Object(r.a)(a)),{arrayFormat:"comma"})})}}),[h,x,p,f,n,t]),Object(o.jsx)(o.Fragment,{children:x.length>0&&x.map((function(e){var t=e.optionGroupName,a=e.options,c=e.optionGroupID,r=e.optionGroupCode,s=f[r]||"select";return Object(o.jsxs)("div",{className:"form-group",children:[Object(o.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(o.jsx)("label",{className:"font-weight-medium",htmlFor:c,children:t})}),Object(o.jsxs)("select",{className:"custom-select",required:!0,value:s,id:c,onChange:function(e){var t=function(e,t,a){return e.filter((function(e){return t===e.optionGroupCode})).map((function(e){return e.options.filter((function(e){return a===e.optionCode}))})).flat().shift()}(x,r,e.target.value);!function(e,t,a){delete f.skuid,j({optionCode:t,optionGroupCode:e}),a||(f={}),f[e]=t,h.push({pathname:p.pathname,search:N.a.stringify(f,{arrayFormat:"comma"})})}(r,t.optionCode,t.active)},children:["select"===s&&Object(o.jsx)("option",{className:"option nonactive",value:"select",children:O("frontend.product.select")}),a&&a.map((function(e){return Object(o.jsxs)("option",{className:"option ".concat(e.active?"active":"nonactive"),value:e.optionCode,children:[e.active&&e.optionName,!e.active&&e.optionName+" - "+O("frontend.product.na")]},e.optionID)}))]})]},c)}))})},S=function(e){var t=e.product,a=e.attributeSets,c=e.skuID,d=e.sku,l=e.productOptions,u=void 0===l?[]:l,j=e.availableSkuOptions,h=void 0===j?"":j,m=e.isFetching,O=void 0!==m&&m,v=Object(g.c)(),N=Object(b.a)().t,y=Object(g.d)((function(e){return e.cart})),I=Object(i.useState)(1),S=Object(s.a)(I,2),w=S[0],C=S[1];return Object(o.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5",children:Object(o.jsx)("div",{className:"px-lg-3",children:Object(o.jsxs)("div",{className:"row",children:[Object(o.jsx)(p,{productID:t.productID,skuID:c}),Object(o.jsx)("div",{className:"col-lg-6 pt-0",children:Object(o.jsxs)("div",{className:"product-details pb-3",children:[Object(o.jsxs)("div",{className:"d-flex justify-content-between align-items-center mb-2",children:[Object(o.jsxs)("span",{className:"d-inline-block font-size-sm align-middle px-2 bg-primary text-light",children:[" ",!0===t.productClearance&&" On Special"]}),c&&Object(o.jsx)(n.k,{skuID:c,className:"btn-wishlist mr-0 mr-lg-n3"})]}),Object(o.jsx)("h2",{className:"h4 mb-2",children:t.productName}),Object(o.jsxs)("div",{className:"mb-2",children:[Object(o.jsx)("span",{className:"text-small text-muted",children:"SKU: "}),d&&Object(o.jsx)("span",{className:"h4 font-weight-normal text-large text-accent mr-1",children:d.skuCode})]}),Object(o.jsx)("div",{className:"mb-3 font-weight-light font-size-small text-muted",dangerouslySetInnerHTML:{__html:t.productDescription}}),Object(o.jsxs)("form",{className:"mb-grid-gutter",onSubmit:function(e){e.preventDefault(),v(Object(x.l)(d.skuID,w)),window.scrollTo({top:0,behavior:"smooth"})},children:[u.length>0&&!O&&Object(o.jsx)(k,{productID:t.productID,skuOptionDetails:u,availableSkuOptions:h,sku:d,skuID:c}),O&&Object(o.jsx)(D,{}),Object(o.jsx)("div",{className:"mb-3",children:d&&Object(o.jsx)(n.u,{salePrice:d.price,listPrice:d.listPrice})}),Object(o.jsxs)("div",{className:"form-group d-flex align-items-center",children:[Object(o.jsx)("select",{value:w,onChange:function(e){C(e.target.value)},className:"custom-select mr-3",style:{width:"5rem"},children:d&&d.calculatedQATS>0&&Object(r.a)(Array(d.calculatedQATS>20?20:d.calculatedQATS).keys()).map((function(e,t){return Object(o.jsx)("option",{value:t+1,children:t+1},t+1)}))}),Object(o.jsxs)("button",{disabled:y.isFetching||!c,className:"btn btn-primary btn-block",type:"submit",children:[Object(o.jsx)("i",{className:"far fa-shopping-cart font-size-lg mr-2"}),N("frontend.product.add_to_cart")]})]})]}),Object(o.jsx)(f,{product:t,attributeSets:a})]})})]})})})},w=a(6),C=a(77),F=function(e){var t=e.productID,a=Object(b.a)().t,r=Object(i.useState)({products:[],isLoaded:!1,err:"",productID:t}),n=Object(s.a)(r,2),d=n[0],l=n[1];return d.productID!==t&&l({products:[],isLoaded:!1,err:"",productID:t}),Object(i.useEffect)((function(){var e=!1;return d.isLoaded||w.a.products.getRelatedProducts({productID:t}).then((function(t){if(t.isSuccess()&&!e){var a=t.success().relatedProducts;Object(m.d)(a,"relatedProduct_",""),l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,products:a}))}else l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,err:"oops"}))})),function(){e=!0}}),[d,l,t]),Object(o.jsx)(C.a,{title:a("frontend.product.related"),sliderData:d.products})},L=a(121),G=function(e,t){var a=N.a.parse(e,{arrayFormat:"separator",arrayFormatSeparator:","});return Object.keys(a).map((function(e){return t.map((function(t){var c=t.options.filter((function(t){return t.optionCode===a[e]}))[0];return c?c.optionID:null})).filter((function(e){return e}))})).join()};t.default=function(e){var t=Object(y.h)(),a=t.pathname,l=t.search,u=Object(j.d)(),p=Object(s.a)(u,2),b=p[0],h=p[1],m=Object(j.b)(),O=Object(s.a)(m,2),f=O[0],x=O[1],g=Object(y.h)(),v=Object(y.g)(),I=Object(i.useState)(a),D=Object(s.a)(I,2),k=D[0],w=D[1],C=N.a.parse(l,{arrayFormat:"separator",arrayFormatSeparator:","});if(Object(i.useEffect)((function(){if(f.isLoaded&&!Object.keys(C).length){console.log("Redirect to Default Sku");var e=(t=f.data[0].defaultSelectedOptions,f.data[0].optionGroups.map((function(e){return e.options.filter((function(e){return t.includes(e.optionID)})).map((function(t){var a={};return a[e.optionGroupCode]=t.optionCode,a}))})).flat());v.push({pathname:g.pathname,search:N.a.stringify(Object.assign.apply(Object,Object(r.a)(e)),{arrayFormat:"comma"})})}var t;if(f.isLoaded&&!b.isFetching&&!b.isLoaded){var a=G(l,f.data[0].optionGroups);h(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data[0].productID,skuID:C.skuid,selectedOptionIDList:a.length?a:f.data[0].defaultSelectedOptions},makeRequest:!0}))}v.listen((function(e){if(!f.isFetching&&f.isLoaded){var t=G(e.search,f.data[0].optionGroups);h(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data[0].productID,selectedOptionIDList:t},makeRequest:!0}))}}))}),[v,h,b,C,l,g,f]),!f.isFetching&&f.isLoaded&&f.data[0]&&0===Object.keys(f.data[0]).length)return Object(o.jsx)(y.a,{to:"/404"});if(a!==k){console.log("Refresh all");N.a.parse(g.search,{arrayFormat:"separator",arrayFormatSeparator:","});w(a)}if(!f.isFetching&&!f.isLoaded){var z=a.split("/").reverse();w(a),x(Object(c.a)(Object(c.a)({},f),{},{params:{"f:urlTitle":z[0]},entity:"product",makeRequest:!0,isFetching:!0,isLoaded:!1}))}return Object(o.jsx)(n.o,{children:Object(o.jsxs)("div",{className:"bg-light p-0",children:[f.isLoaded&&Object(o.jsx)(d,{title:f.data[0].productSeries}),f.isLoaded&&Object(o.jsx)(L.a,{title:f.data[0].calculatedTitle}),f.isLoaded&&f.data[0].productID&&Object(o.jsx)(S,{attributeSets:f.attributeSets,product:f.data[0],sku:b.data.sku[0],skuID:b.data.skuID,availableSkuOptions:b.data.availableSkuOptions,productOptions:f.data[0].optionGroups,isFetching:b.isFetching||f.isFetching}),f.isLoaded&&f.data[0].productID&&Object(o.jsx)(F,{productID:f.data[0].productID})]})})}}}]);
//# sourceMappingURL=19.9fc04c11.chunk.js.map