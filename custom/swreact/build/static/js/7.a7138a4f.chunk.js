(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7,18],{420:function(e,t,a){"use strict";a.r(t);var c=a(2),s=a(16),r=a(5),i=a(1),n=a(21),o=a(0),d=function(e){var t=e.title,a=void 0===t?"":t;return Object(o.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(o.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(o.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(o.jsx)(n.c,{})}),Object(o.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(o.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:a})})]})})},l=a(63),u=a.n(l),j=a(26),p=function(e){var t=e.productID,a=e.skuID,s=Object(j.e)(),d=Object(r.a)(s,2),l=d[0],p=d[1],b=Object(i.useState)({nav1:null,nav2:null}),h=Object(r.a)(b,2),m=h[0],O=h[1],f=Object(i.useRef)(),x=Object(i.useRef)();Object(i.useEffect)((function(){O({nav1:f.current,nav2:x.current}),l.isLoaded||l.isFetching||p(Object(c.a)(Object(c.a)({},l),{},{isFetching:!0,isLoaded:!1,params:{productID:t},makeRequest:!0}))}),[l,p,t]);var v=l.isLoaded?l.data.images.filter((function(e){var t=e.ASSIGNEDSKUIDLIST,c=void 0!==t&&t;return"skuDefaultImage"===e.TYPE||c&&c.includes(a)})):[];return 0===v.length&&(v=[{ORIGINALPATH:"",NAME:""}]),Object(o.jsxs)("div",{className:"col-lg-6 pr-lg-5 pt-0",children:[Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsxs)("div",{className:"cz-preview-item active",id:"first",children:[Object(o.jsx)("div",{children:Object(o.jsx)(u.a,{arrows:!1,asNavFor:m.nav2,ref:function(e){return f.current=e},children:l.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"500px"}},a)}))})}),Object(o.jsx)("div",{className:"cz-image-zoom-pane"})]})})}),Object(o.jsx)("div",{className:"cz-product-gallery",children:Object(o.jsx)("div",{className:"cz-preview order-sm-2",children:Object(o.jsx)("div",{className:"cz-preview-item active",id:"first",children:Object(o.jsx)("div",{children:v.length>1&&Object(o.jsx)(u.a,{arrows:!1,infinite:v.length>3,asNavFor:m.nav1,ref:function(e){return x.current=e},slidesToShow:3,swipeToSlide:!0,focusOnSelect:!0,children:l.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(o.jsx)(n.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"100px"}},a)}))})})})})})]})},b=a(48),h=["productID","productName","productCode"],m=function(e){var t=e.product,a=void 0===t?{}:t,c=[];return c=Object.keys(a).filter((function(e){return e.startsWith("product")&&!h.includes(e)})).map((function(e){return{key:e.replace("product",""),value:Object(b.d)(a[e])?Object(b.a)(a[e]):a[e]}})).filter((function(e){e.key;var t=e.value;return Object(b.e)(t)&&t.trim().length>0})),Object(o.jsxs)("div",{className:"accordion mb-4",id:"productPanels",children:[Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{href:"#productInfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"productInfo",children:[Object(o.jsx)("i",{className:"far fa-key font-size-lg align-middle mt-n1 mr-2"}),"Product info",Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse show",id:"productInfo","data-parent":"#productPanels",children:Object(o.jsx)("div",{className:"card-body",children:Object(o.jsxs)("div",{className:"font-size-sm row",children:[Object(o.jsx)("div",{className:"col-6",children:Object(o.jsx)("ul",{children:c.map((function(e){var t=e.key;return Object(o.jsxs)("li",{children:[t,":"]},t)}))})}),Object(o.jsx)("div",{className:"col-6 text-muted",children:Object(o.jsx)("ul",{children:c.map((function(e){var t=e.key,a=e.value;return Object(o.jsx)("li",{children:Object(b.b)(a)?Object(o.jsx)("div",{dangerouslySetInnerHTML:{__html:a}}):a},t)}))})})]})})})]}),Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{className:"collapsed",href:"#technicalinfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"technicalinfo",children:[Object(o.jsx)("i",{className:"far fa-drafting-compass align-middle mt-n1 mr-2"}),"Technical Info",Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse",id:"technicalinfo","data-parent":"#productPanels",children:Object(o.jsxs)("div",{className:"card-body font-size-sm",children:[Object(o.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(o.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(o.jsx)("a",{href:"?=doc",children:"Download"})]}),Object(o.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(o.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(o.jsx)("a",{href:"?=doc",children:"Download"})]})]})})]}),Object(o.jsxs)("div",{className:"card",children:[Object(o.jsx)("div",{className:"card-header",children:Object(o.jsx)("h3",{className:"accordion-heading",children:Object(o.jsxs)("a",{className:"collapsed",href:"#questions",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"questions",children:[Object(o.jsx)("i",{className:"far fa-question-circle font-size-lg align-middle mt-n1 mr-2"}),"Questions?",Object(o.jsx)("span",{className:"accordion-indicator"})]})})}),Object(o.jsx)("div",{className:"collapse",id:"questions","data-parent":"#productPanels",children:Object(o.jsxs)("div",{className:"card-body",children:[Object(o.jsx)("p",{children:"Have questions about this product?"}),Object(o.jsx)("a",{href:"/contact",children:"Contact Us"})]})})]})]})},O=a(24),f=a(4),x=a(25),v=a(19),g=a.n(v),N=a(11),y=a(62),k=function(e){return Object(o.jsxs)(y.a,Object(c.a)(Object(c.a)({speed:2,width:400,height:150,viewBox:"0 0 400 200",backgroundColor:"#f3f3f3",foregroundColor:"#ecebeb"},e),{},{children:[Object(o.jsx)("rect",{x:"25",y:"15",rx:"5",ry:"5",width:"350",height:"20"}),Object(o.jsx)("rect",{x:"25",y:"45",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"25",y:"60",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"26",y:"75",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"27",y:"107",rx:"5",ry:"5",width:"350",height:"20"}),Object(o.jsx)("rect",{x:"26",y:"135",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"26",y:"150",rx:"5",ry:"5",width:"350",height:"10"}),Object(o.jsx)("rect",{x:"27",y:"165",rx:"5",ry:"5",width:"350",height:"10"})]}))},I=function(e){e.productID;var t=e.skuOptionDetails,a=e.availableSkuOptions,n=e.sku,d=(e.skuID,Object(i.useState)({optionCode:"",optionGroupCode:""})),l=Object(r.a)(d,2),u=l[0],j=l[1],p=Object(N.h)(),h=Object(N.g)(),m=Object(x.a)().t,O=g.a.parse(p.search,{arrayFormat:"separator",arrayFormatSeparator:","});0===u.optionGroupCode.length&&Object.keys(O).length>0&&j({optionCode:Object.entries(O)[0][0],optionGroupCode:Object.entries(O)[0][1]});var f=function(){var e=t;return e.forEach((function(e){e.options=e.options.map((function(e){return e.active=!0,e}))})),u.optionGroupCode.length>0&&e.forEach((function(e){e.options=e.options.map((function(t){return t.active=e.optionGroupCode===u.optionGroupCode||a.includes(t.optionID),t}))})),e}();return Object(i.useEffect)((function(){var e={};if(f.forEach((function(t){var a=t.options.filter((function(e){return e.active}));1===a.length&&(e[t.optionGroupCode]=a[0].optionCode)})),Object.keys(e)&&JSON.stringify(Object(c.a)(Object(c.a)({},e),O)).length!==JSON.stringify(O).length&&!O.skuid&&(console.log("Redirect because of foreced Selection"),h.push({pathname:p.pathname,search:g.a.stringify(Object(c.a)(Object(c.a)({},e),O),{arrayFormat:"comma"})})),O.skuid&&n){console.log("Redirect to passed Sku",t);var a=Object(b.g)(n.selectedOptionIDList,t);h.push({pathname:p.pathname,search:g.a.stringify(Object.assign.apply(Object,Object(s.a)(a)),{arrayFormat:"comma"})})}}),[h,f,p,O,n,t]),Object(o.jsx)(o.Fragment,{children:f.length>0&&f.map((function(e){var t=e.optionGroupName,a=e.options,c=e.optionGroupID,s=e.optionGroupCode,r=O[s]||"select";return Object(o.jsxs)("div",{className:"form-group",children:[Object(o.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(o.jsx)("label",{className:"font-weight-medium",htmlFor:c,children:t})}),Object(o.jsxs)("select",{className:"custom-select",required:!0,value:r,id:c,onChange:function(e){var t=function(e,t,a){return e.filter((function(e){return t===e.optionGroupCode})).map((function(e){return e.options.filter((function(e){return a===e.optionCode}))})).flat().shift()}(f,s,e.target.value);!function(e,t,a){delete O.skuid,j({optionCode:t,optionGroupCode:e}),a||(O={}),O[e]=t,h.push({pathname:p.pathname,search:g.a.stringify(O,{arrayFormat:"comma"})})}(s,t.optionCode,t.active)},children:["select"===r&&Object(o.jsx)("option",{className:"option nonactive",value:"select",children:m("frontend.product.select")}),a&&a.map((function(e){return Object(o.jsxs)("option",{className:"option ".concat(e.active?"active":"nonactive"),value:e.optionCode,children:[e.active&&e.optionName,!e.active&&e.optionName+" - "+m("frontend.product.na")]},e.optionID)}))]})]},c)}))})},D=function(e){var t=e.product,a=e.skuID,c=e.sku,d=e.productOptions,l=void 0===d?[]:d,u=e.availableSkuOptions,j=void 0===u?"":u,b=e.isFetching,h=void 0!==b&&b,v=Object(f.c)(),g=Object(x.a)().t,N=Object(f.d)((function(e){return e.cart})),y=Object(i.useState)(1),D=Object(r.a)(y,2),w=D[0],S=D[1];return Object(o.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5",children:Object(o.jsx)("div",{className:"px-lg-3",children:Object(o.jsxs)("div",{className:"row",children:[Object(o.jsx)(p,{productID:t.productID,skuID:a}),Object(o.jsx)("div",{className:"col-lg-6 pt-0",children:Object(o.jsxs)("div",{className:"product-details pb-3",children:[Object(o.jsxs)("div",{className:"d-flex justify-content-between align-items-center mb-2",children:[Object(o.jsxs)("span",{className:"d-inline-block font-size-sm align-middle px-2 bg-primary text-light",children:[" ",!0===t.productClearance&&" On Special"]}),a&&Object(o.jsx)(n.k,{skuID:a,className:"btn-wishlist mr-0 mr-lg-n3"})]}),Object(o.jsx)("h2",{className:"h4 mb-2",children:t.productName}),Object(o.jsxs)("div",{className:"mb-2",children:[Object(o.jsx)("span",{className:"text-small text-muted",children:"SKU: "}),c&&Object(o.jsx)("span",{className:"h4 font-weight-normal text-large text-accent mr-1",children:c.skuCode})]}),Object(o.jsx)("div",{className:"mb-3 font-weight-light font-size-small text-muted",dangerouslySetInnerHTML:{__html:t.productDescription}}),Object(o.jsxs)("form",{className:"mb-grid-gutter",onSubmit:function(e){e.preventDefault(),v(Object(O.k)(c.skuID,w)),window.scrollTo({top:0,behavior:"smooth"})},children:[l.length>0&&!h&&Object(o.jsx)(I,{productID:t.productID,skuOptionDetails:l,availableSkuOptions:j,sku:c,skuID:a}),h&&Object(o.jsx)(k,{}),Object(o.jsx)("div",{className:"mb-3",children:c&&Object(o.jsx)(n.u,{salePrice:c.price,listPrice:c.listPrice})}),Object(o.jsxs)("div",{className:"form-group d-flex align-items-center",children:[Object(o.jsx)("select",{value:w,onChange:function(e){S(e.target.value)},className:"custom-select mr-3",style:{width:"5rem"},children:c&&c.calculatedQATS>0&&Object(s.a)(Array(c.calculatedQATS>20?20:c.calculatedQATS).keys()).map((function(e,t){return Object(o.jsx)("option",{value:t+1,children:t+1},t+1)}))}),Object(o.jsxs)("button",{disabled:N.isFetching||!a,className:"btn btn-primary btn-block",type:"submit",children:[Object(o.jsx)("i",{className:"far fa-shopping-cart font-size-lg mr-2"}),g("frontend.product.add_to_cart")]})]})]}),Object(o.jsx)(m,{product:t})]})})]})})})},w=a(6),S=a(78),L=function(e){var t=e.productID,a=Object(x.a)().t,s=Object(i.useState)({products:[],isLoaded:!1,err:"",productID:t}),n=Object(r.a)(s,2),d=n[0],l=n[1];return d.productID!==t&&l({products:[],isLoaded:!1,err:"",productID:t}),Object(i.useEffect)((function(){var e=!1;return d.isLoaded||w.a.products.getRelatedProducts({productID:t}).then((function(t){if(t.isSuccess()&&!e){var a=t.success().relatedProducts;Object(b.f)(a,"relatedProduct_",""),l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,products:a}))}else l(Object(c.a)(Object(c.a)({},d),{},{isLoaded:!0,err:"oops"}))})),function(){e=!0}}),[d,l,t]),Object(o.jsx)(S.a,{title:a("frontend.product.related"),sliderData:d.products})},F=a(122),C=function(e,t){var a=g.a.parse(e,{arrayFormat:"separator",arrayFormatSeparator:","});return Object.keys(a).map((function(e){return t.map((function(t){var c=t.options.filter((function(t){return t.optionCode===a[e]}))[0];return c?c.optionID:null})).filter((function(e){return e}))})).join()};t.default=function(e){var t=Object(N.h)(),a=t.pathname,l=t.search,u=Object(j.d)(),p=Object(r.a)(u,2),b=p[0],h=p[1],m=Object(j.b)(),O=Object(r.a)(m,2),f=O[0],x=O[1],v=Object(N.h)(),y=Object(N.g)(),k=Object(i.useState)(a),I=Object(r.a)(k,2),w=I[0],S=I[1],G=g.a.parse(l,{arrayFormat:"separator",arrayFormatSeparator:","});if(Object(i.useEffect)((function(){if(f.isLoaded&&!Object.keys(G).length){console.log("Redirect to Default Sku");var e=(t=f.data[0].defaultSelectedOptions,f.data[0].optionGroups.map((function(e){return e.options.filter((function(e){return t.includes(e.optionID)})).map((function(t){var a={};return a[e.optionGroupCode]=t.optionCode,a}))})).flat());y.push({pathname:v.pathname,search:g.a.stringify(Object.assign.apply(Object,Object(s.a)(e)),{arrayFormat:"comma"})})}var t;if(f.isLoaded&&!b.isFetching&&!b.isLoaded){var a=C(l,f.data[0].optionGroups);h(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data[0].productID,skuID:G.skuid,selectedOptionIDList:a.length?a:f.data[0].defaultSelectedOptions},makeRequest:!0}))}y.listen((function(e){if(!f.isFetching&&f.isLoaded){var t=C(e.search,f.data[0].optionGroups);h(Object(c.a)(Object(c.a)({},b),{},{isFetching:!0,isLoaded:!1,params:{productID:f.data[0].productID,selectedOptionIDList:t},makeRequest:!0}))}}))}),[y,h,b,G,l,v,f]),!f.isFetching&&f.isLoaded&&f.data[0]&&0===Object.keys(f.data[0]).length)return Object(o.jsx)(N.a,{to:"/404"});if(a!==w){console.log("Refresh all");g.a.parse(v.search,{arrayFormat:"separator",arrayFormatSeparator:","});S(a)}if(!f.isFetching&&!f.isLoaded){var z=a.split("/").reverse();S(a),x(Object(c.a)(Object(c.a)({},f),{},{params:{"f:urlTitle":z[0]},entity:"product",makeRequest:!0,isFetching:!0,isLoaded:!1}))}return Object(o.jsx)(n.o,{children:Object(o.jsxs)("div",{className:"bg-light p-0",children:[f.isLoaded&&Object(o.jsx)(d,{title:f.data[0].productSeries}),f.isLoaded&&Object(o.jsx)(F.a,{title:f.data[0].calculatedTitle}),f.isLoaded&&f.data[0].productID&&Object(o.jsx)(D,{product:f.data[0],sku:b.data.sku[0],skuID:b.data.skuID,availableSkuOptions:b.data.availableSkuOptions,productOptions:f.data[0].optionGroups,isFetching:b.isFetching||f.isFetching}),f.isLoaded&&f.data[0].productID&&Object(o.jsx)(L,{productID:f.data[0].productID})]})})}},513:function(e,t,a){"use strict";a.r(t);var c=a(420),s=a(11),r=a(0);t.default=function(){var e=Object(s.h)();return Object(r.jsx)(c.default,{forwardState:e})}}}]);
//# sourceMappingURL=7.a7138a4f.chunk.js.map