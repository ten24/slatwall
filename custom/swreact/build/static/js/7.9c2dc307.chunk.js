(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[7],{493:function(e,t,a){"use strict";var c=a(25);a.d(t,"a",(function(){return c.b})),a.d(t,"b",(function(){return c.c}));a(32),a(68),a(55)},535:function(e,t,a){"use strict";a.r(t);var c=a(2),s=a(5),i=a(1),r=a.n(i),d=a(21),n=a(0),o=function(e){var t=e.title,a=void 0===t?"":t;return Object(n.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(n.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(n.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(n.jsx)(d.c,{})}),Object(n.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(n.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:a})})]})})},l=a(16),j=a(74),u=a.n(j),b=a(25),m=function(e){var t=e.productID,a=e.skuID,r=Object(b.g)(),o=Object(s.a)(r,2),l=o[0],j=o[1],m=Object(i.useState)({nav1:null,nav2:null}),O=Object(s.a)(m,2),h=O[0],p=O[1],f=Object(i.useRef)(),x=Object(i.useRef)();Object(i.useEffect)((function(){p({nav1:f.current,nav2:x.current}),l.isLoaded||l.isFetching||j(Object(c.a)(Object(c.a)({},l),{},{isFetching:!0,isLoaded:!1,params:{productID:t},makeRequest:!0}))}),[l,j,t]);var v=l.isLoaded?l.data.images.filter((function(e){var t=e.ASSIGNEDSKUIDLIST,c=void 0!==t&&t;return"skuDefaultImage"===e.TYPE||c&&c.includes(a)})):[];return 0===v.length&&(v=[{ORIGINALPATH:"",NAME:""}]),Object(n.jsxs)("div",{className:"col-lg-6 pr-lg-5 pt-0",children:[Object(n.jsx)("div",{className:"cz-product-gallery",children:Object(n.jsx)("div",{className:"cz-preview order-sm-2",children:Object(n.jsxs)("div",{className:"cz-preview-item active",id:"first",children:[Object(n.jsx)("div",{children:Object(n.jsx)(u.a,{arrows:!1,asNavFor:h.nav2,ref:function(e){return f.current=e},children:l.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(n.jsx)(d.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"500px"}},a)}))})}),Object(n.jsx)("div",{className:"cz-image-zoom-pane"})]})})}),Object(n.jsx)("div",{className:"cz-product-gallery",children:Object(n.jsx)("div",{className:"cz-preview order-sm-2",children:Object(n.jsx)("div",{className:"cz-preview-item active",id:"first",children:Object(n.jsx)("div",{children:v.length>1&&Object(n.jsx)(u.a,{arrows:!1,infinite:v.length>3,asNavFor:h.nav1,ref:function(e){return x.current=e},slidesToShow:3,swipeToSlide:!0,focusOnSelect:!0,children:l.isLoaded&&v.map((function(e){var t=e.ORIGINALPATH,a=e.NAME;return Object(n.jsx)(d.x,{customPath:"/",src:t,className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"100px"}},a)}))})})})})})]})},O=a(493),h=["productID","productName","productCode"],p=function(e){var t=e.productID,a=Object(O.b)(),r=Object(s.a)(a,2),d=r[0],o=r[1],l=[];return Object(i.useEffect)((function(){var e=!1;return d.isFetching||d.isLoaded||e||o(Object(c.a)(Object(c.a)({},d),{},{isFetching:!0,isLoaded:!1,entity:"product",params:{entityID:t},makeRequest:!0})),function(){e=!0}}),[d,o,t]),d.isLoaded&&(l=Object.keys(d.data).filter((function(e){return e.startsWith("product")&&!h.includes(e)&&d.data[e]&&d.data[e].trim().length>0})).map((function(e){return{key:e.replace("product",""),value:d.data[e]}}))),Object(n.jsxs)("div",{className:"accordion mb-4",id:"productPanels",children:[Object(n.jsxs)("div",{className:"card",children:[Object(n.jsx)("div",{className:"card-header",children:Object(n.jsx)("h3",{className:"accordion-heading",children:Object(n.jsxs)("a",{href:"#productInfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"productInfo",children:[Object(n.jsx)("i",{className:"far fa-key font-size-lg align-middle mt-n1 mr-2"}),"Product info",Object(n.jsx)("span",{className:"accordion-indicator"})]})})}),Object(n.jsx)("div",{className:"collapse show",id:"productInfo","data-parent":"#productPanels",children:Object(n.jsx)("div",{className:"card-body",children:Object(n.jsxs)("div",{className:"font-size-sm row",children:[Object(n.jsx)("div",{className:"col-6",children:Object(n.jsx)("ul",{children:d.isLoaded&&l.map((function(e){var t=e.key;return Object(n.jsxs)("li",{children:[t,":"]},t)}))})}),Object(n.jsx)("div",{className:"col-6 text-muted",children:Object(n.jsx)("ul",{children:d.isLoaded&&l.map((function(e){var t=e.key,a=e.value;return Object(n.jsx)("li",{children:a},t)}))})})]})})})]}),Object(n.jsxs)("div",{className:"card",children:[Object(n.jsx)("div",{className:"card-header",children:Object(n.jsx)("h3",{className:"accordion-heading",children:Object(n.jsxs)("a",{className:"collapsed",href:"#technicalinfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"technicalinfo",children:[Object(n.jsx)("i",{className:"far fa-drafting-compass align-middle mt-n1 mr-2"}),"Technical Info",Object(n.jsx)("span",{className:"accordion-indicator"})]})})}),Object(n.jsx)("div",{className:"collapse",id:"technicalinfo","data-parent":"#productPanels",children:Object(n.jsxs)("div",{className:"card-body font-size-sm",children:[Object(n.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(n.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(n.jsx)("a",{href:"?=doc",children:"Download"})]}),Object(n.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(n.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(n.jsx)("a",{href:"?=doc",children:"Download"})]})]})})]}),Object(n.jsxs)("div",{className:"card",children:[Object(n.jsx)("div",{className:"card-header",children:Object(n.jsx)("h3",{className:"accordion-heading",children:Object(n.jsxs)("a",{className:"collapsed",href:"#questions",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"questions",children:[Object(n.jsx)("i",{className:"far fa-question-circle font-size-lg align-middle mt-n1 mr-2"}),"Questions?",Object(n.jsx)("span",{className:"accordion-indicator"})]})})}),Object(n.jsx)("div",{className:"collapse",id:"questions","data-parent":"#productPanels",children:Object(n.jsxs)("div",{className:"card-body",children:[Object(n.jsx)("p",{children:"Have questions about this product?"}),Object(n.jsx)("a",{href:"/contact",children:"Contact Us"})]})})]})]})},f=a(24),x=a(4),v=a(28),g=a(11),N=a(55),I=function(e){var t=e.productID,a=e.productName,o=e.productClearance,j=(e.productCode,e.productDescription),u=e.skuID,O=Object(x.c)(),h=Object(v.a)().t,I=Object(g.h)(),D=Object(b.l)(),k=Object(s.a)(D,2),L=k[0],y=k[1],w=Object(b.j)(),R=Object(s.a)(w,2),F=R[0],S=R[1],z=Object(b.e)(),P=Object(s.a)(z,2),T=P[0],q=P[1],A=Object(b.i)(),E=Object(s.a)(A,2),C=E[0],G=E[1],H=Object(i.useState)(""),_=Object(s.a)(H,2),M=_[0],Q=_[1],U=Object(N.b)({location:I.pathname}),W=Object(s.a)(U,2),J=W[0],K=W[1],Y=Object(i.useState)(1),B=Object(s.a)(Y,2),V=B[0],X=B[1],Z=Object(i.useRef)([r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef()]);return C.isLoaded&&(G({data:{},isFetching:!1,isLoaded:!1,params:{},makeRequest:!1}),y(Object(c.a)(Object(c.a)({},L),{},{isFetching:!0,isLoaded:!1,params:{"f:skuID":C.data.skuID||F.data.skus[0].skuID},makeRequest:!0})),K(Object(c.a)(Object(c.a)({},J),{},{search:"?skuid=".concat(C.data.skuID||F.data.skus[0].skuID),shouldRedirect:!0,time:200}))),Object(i.useEffect)((function(){F.isFetching||F.isLoaded||S(Object(c.a)(Object(c.a)({},F),{},{isFetching:!0,isLoaded:!1,params:{productID:t},makeRequest:!0})),!(u||F.isLoaded&&F.data.skus[0])||L.isFetching||L.isLoaded||y(Object(c.a)(Object(c.a)({},L),{},{isFetching:!0,isLoaded:!1,params:{"f:skuID":u||F.data.skus[0].skuID},makeRequest:!0})),T.isFetching||T.isLoaded||!L.isLoaded||q(Object(c.a)(Object(c.a)({},T),{},{isFetching:!0,isLoaded:!1,params:{productID:t,selectedOptionIDList:""},makeRequest:!0}))}),[S,F,t,L,y,q,T,u]),Object(n.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5",children:Object(n.jsx)("div",{className:"px-lg-3",children:Object(n.jsxs)("div",{className:"row",children:[Object(n.jsx)(m,{productID:t,skuID:L.data.skuID}),Object(n.jsx)("div",{className:"col-lg-6 pt-0",children:Object(n.jsxs)("div",{className:"product-details pb-3",children:[Object(n.jsxs)("div",{className:"d-flex justify-content-between align-items-center mb-2",children:[Object(n.jsxs)("span",{className:"d-inline-block font-size-sm align-middle px-2 bg-primary text-light",children:[" ",!0===o&&" On Special"]}),Object(n.jsx)(d.k,{skuID:L.data.skuID,className:"btn-wishlist mr-0 mr-lg-n3"})]}),Object(n.jsx)("h2",{className:"h4 mb-2",children:a}),Object(n.jsxs)("div",{className:"mb-2",children:[Object(n.jsx)("span",{className:"text-small text-muted",children:"SKU: "}),Object(n.jsx)("span",{className:"h4 font-weight-normal text-large text-accent mr-1",children:L.data.skuCode})]}),Object(n.jsx)("div",{className:"mb-3 font-weight-light font-size-small text-muted",dangerouslySetInnerHTML:{__html:j}}),Object(n.jsxs)("form",{className:"mb-grid-gutter",onSubmit:function(e){e.preventDefault(),O(Object(f.k)(L.data.skuID,V)),window.scrollTo({top:0,behavior:"smooth"})},children:[F.isLoaded&&T.isLoaded&&F.data.options.length>0&&F.data.options.map((function(e,a){var s=e.optionGroupName,i=e.options,r=e.optionGroupID,d=L.data.options.map((function(e){return e.optionID})).join(),o=i.filter((function(e){return d.includes(e.optionID)})),j=i;return M!==r&&(j=i.filter((function(e){return T.data.availableSkuOptions.includes(e.optionID)}))),j.length?Object(n.jsxs)("div",{className:"form-group",children:[Object(n.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(n.jsx)("label",{className:"font-weight-medium",htmlFor:r,children:s})}),Object(n.jsx)("select",{className:"custom-select",required:!0,id:r,ref:Z.current[a],value:o.length>0&&o[0].optionID||i[0],onChange:function(e){var a=Z.current.reduce((function(e,t){return t.current?[].concat(Object(l.a)(e),[t.current.value]):e}),[]).join();q(Object(c.a)(Object(c.a)({},T),{},{isFetching:!0,isLoaded:!1,params:{productID:t,selectedOptionIDList:e.target.value},makeRequest:!0})),G(Object(c.a)(Object(c.a)({},C),{},{isFetching:!0,isLoaded:!1,params:{productID:t,selectedOptionIDList:a},makeRequest:!0})),Q(r)},children:j&&j.map((function(e){var t=e.optionID,a=e.optionName;return Object(n.jsx)("option",{value:t,children:a},t)}))})]},r):Object(n.jsx)("div",{},r)})),Object(n.jsx)("div",{className:"mb-3",children:Object(n.jsx)(d.u,{salePrice:L.data.price,listPrice:L.data.listPrice})}),Object(n.jsxs)("div",{className:"form-group d-flex align-items-center",children:[Object(n.jsx)("select",{value:V,onChange:function(e){X(e.target.value)},className:"custom-select mr-3",style:{width:"5rem"},children:L.data.calculatedQATS>0&&Object(l.a)(Array(L.data.calculatedQATS>20?20:L.data.calculatedQATS).keys()).map((function(e,t){return Object(n.jsx)("option",{value:t+1,children:t+1},t+1)}))}),Object(n.jsxs)("button",{className:"btn btn-primary btn-block",type:"submit",children:[Object(n.jsx)("i",{className:"far fa-shopping-cart font-size-lg mr-2"}),h("frontend.product.add_to_cart")]})]})]}),Object(n.jsx)(p,{productID:t})]})})]})})})},D=a(6),k=a(95),L=a(69),y=function(e){var t=e.productID,a=Object(v.a)().t,r=Object(i.useState)({products:[],isLoaded:!1,err:"",productID:t}),d=Object(s.a)(r,2),o=d[0],l=d[1];return o.productID!==t&&l({products:[],isLoaded:!1,err:"",productID:t}),Object(i.useEffect)((function(){var e=!1;return o.isLoaded||D.a.products.getRelatedProducts({productID:t}).then((function(t){if(t.isSuccess()&&!e){var a=t.success().relatedProducts;Object(L.b)(a,"relatedProduct_",""),l(Object(c.a)(Object(c.a)({},o),{},{isLoaded:!0,products:a}))}else l(Object(c.a)(Object(c.a)({},o),{},{isLoaded:!0,err:"oops"}))})),function(){e=!0}}),[o,l,t]),Object(n.jsx)(k.a,{title:a("frontend.product.related"),sliderData:o.products})},w=a(19),R=a.n(w);t.default=function(e){var t=Object(g.h)(),a=t.pathname,r=t.search,l=Object(N.a)({location:"/404",time:300}),j=Object(s.a)(l,2),u=j[0],m=j[1],O=Object(b.f)(),h=Object(s.a)(O,2),p=h[0],f=h[1],x=Object(i.useState)(a),v=Object(s.a)(x,2),D=v[0],k=v[1],L=R.a.parse(r,{arrayFormat:"separator",arrayFormatSeparator:","});return Object(i.useEffect)((function(){var e=!1;if(!e&&(!p.isFetching&&!p.isLoaded||a!==D)){var t=a.split("/").reverse();k(a),f(Object(c.a)(Object(c.a)({},p),{},{params:{filter:{current:1,urlTitle:t[0]}},makeRequest:!0,isFetching:!0,isLoaded:!1}))}return!p.isFetching&&p.isLoaded&&0===Object.keys(p.data).length&&m(Object(c.a)(Object(c.a)({},u),{},{shouldRedirect:!0})),function(){e=!0}}),[p,f,a,r,D,u,m]),Object(n.jsx)(d.o,{children:Object(n.jsxs)("div",{className:"bg-light p-0",children:[Object(n.jsx)(o,{title:p.data.calculatedTitle}),p.data.productID&&Object(n.jsx)(I,Object(c.a)(Object(c.a)({},p.data),{},{skuID:L.skuid})),p.data.productID&&Object(n.jsx)(y,{productID:p.data.productID})]})})}}}]);
//# sourceMappingURL=7.9c2dc307.chunk.js.map