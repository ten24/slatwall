(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[17],{301:function(e,t,c){"use strict";var a=c(11),s=c(1),n=c(9);t.a=function(e){var t=e.shouldRedirect,c=void 0!==t&&t,r=e.location,i=void 0===r?"/":r,d=e.time,o=void 0===d?2e3:d,l=Object(n.g)(),u=Object(s.useState)(c),j=Object(a.a)(u,2),b=j[0],p=j[1];return Object(s.useEffect)((function(){if(b){var e=setTimeout((function(){l.push(i)}),o);return function(){return clearTimeout(e)}}}),[l,b,i,o]),[b,p]}},314:function(e,t,c){"use strict";function a(e){this.message=e}c.d(t,"b",(function(){return d})),c.d(t,"a",(function(){return o})),a.prototype=new Error,a.prototype.name="InvalidCharacterError";var s="undefined"!=typeof window&&window.atob&&window.atob.bind(window)||function(e){var t=String(e).replace(/=+$/,"");if(t.length%4==1)throw new a("'atob' failed: The string to be decoded is not correctly encoded.");for(var c,s,n=0,r=0,i="";s=t.charAt(r++);~s&&(c=n%4?64*c+s:s,n++%4)?i+=String.fromCharCode(255&c>>(-2*n&6)):0)s="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=".indexOf(s);return i};function n(e){var t=e.replace(/-/g,"+").replace(/_/g,"/");switch(t.length%4){case 0:break;case 2:t+="==";break;case 3:t+="=";break;default:throw"Illegal base64url string!"}try{return function(e){return decodeURIComponent(s(e).replace(/(.)/g,(function(e,t){var c=t.charCodeAt(0).toString(16).toUpperCase();return c.length<2&&(c="0"+c),"%"+c})))}(t)}catch(e){return s(t)}}function r(e){this.message=e}r.prototype=new Error,r.prototype.name="InvalidTokenError";var i=function(e,t){if("string"!=typeof e)throw new r("Invalid token specified");var c=!0===(t=t||{}).header?0:1;try{return JSON.parse(n(e.split(".")[c]))}catch(e){throw new r("Invalid token specified: "+e.message)}},d=function(e,t,c){e.forEach((function(e){!function(e,t){var c=arguments.length>2&&void 0!==arguments[2]?arguments[2]:"";Object.keys(e).forEach((function(a){var s=a.replace(t,c);e[s]=e[a],delete e[a]}))}(e,t,c)}))},o=function(){var e=localStorage.getItem("token");if(e)try{return(e=i(e)).exp&&1e3*e.exp>Date.now()}catch(t){}return!1}},379:function(e,t,c){"use strict";c.r(t);var a=c(2),s=c(11),n=c(1),r=c.n(n),i=c(27),d=c(0),o=function(e){var t=e.title,c=void 0===t?"":t;return Object(d.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(d.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(d.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(d.jsx)(i.b,{})}),Object(d.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(d.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:c})})]})})},l=c(37),u=c(4),j=function(e){var t=e.productID,c=Object(n.useState)({imageGallery:{},isLoaded:!1,productID:t}),r=Object(s.a)(c,2),o=r[0],l=r[1];return o.productID!==t&&l({imageGallery:[],isLoaded:!1,err:"",productID:t}),Object(n.useEffect)((function(){var e=!1;return o.isLoaded||u.a.products.getGallery({productID:t}).then((function(t){t.isSuccess()&&!e?l(Object(a.a)(Object(a.a)({},o),{},{isLoaded:!0,products:t.success().productImageGallery})):t.isFail()&&!e&&l(Object(a.a)(Object(a.a)({},o),{},{isLoaded:!0,err:"opps"}))})),function(){e=!0}}),[o,l,t]),Object(d.jsx)("div",{className:"col-lg-6 pr-lg-5 pt-0",children:Object(d.jsx)("div",{className:"cz-product-gallery",children:Object(d.jsx)("div",{className:"cz-preview order-sm-2",children:Object(d.jsxs)("div",{className:"cz-preview-item active",id:"first",children:[Object(d.jsx)(i.q,{className:"cz-image-zoom w-100 mx-auto",alt:"Product",style:{maxWidth:"500px"}}),Object(d.jsx)("div",{className:"cz-image-zoom-pane"})]})})})})},b=function(){return Object(d.jsxs)("div",{className:"accordion mb-4",id:"productPanels",children:[Object(d.jsxs)("div",{className:"alert alert-danger",role:"alert",children:[Object(d.jsx)("i",{className:"far fa-exclamation-circle"})," This item is not eligable for free freight"]}),Object(d.jsxs)("div",{className:"card",children:[Object(d.jsx)("div",{className:"card-header",children:Object(d.jsx)("h3",{className:"accordion-heading",children:Object(d.jsxs)("a",{href:"#productInfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"productInfo",children:[Object(d.jsx)("i",{className:"far fa-key font-size-lg align-middle mt-n1 mr-2"}),"Product info",Object(d.jsx)("span",{className:"accordion-indicator"})]})})}),Object(d.jsx)("div",{className:"collapse show",id:"productInfo","data-parent":"#productPanels",children:Object(d.jsx)("div",{className:"card-body",children:Object(d.jsxs)("div",{className:"font-size-sm row",children:[Object(d.jsx)("div",{className:"col-6",children:Object(d.jsxs)("ul",{children:[Object(d.jsx)("li",{children:"Manufacturer:"}),Object(d.jsx)("li",{children:"Style:"}),Object(d.jsx)("li",{children:"Fire Rated:"}),Object(d.jsx)("li",{children:"Safety Rating:"})]})}),Object(d.jsx)("div",{className:"col-6 text-muted",children:Object(d.jsxs)("ul",{children:[Object(d.jsx)("li",{children:"Gardall"}),Object(d.jsx)("li",{children:"Burgalry/Fire"}),Object(d.jsx)("li",{children:"2 hour"}),Object(d.jsx)("li",{children:"Residential Security Container (RSC)"})]})})]})})})]}),Object(d.jsxs)("div",{className:"card",children:[Object(d.jsx)("div",{className:"card-header",children:Object(d.jsx)("h3",{className:"accordion-heading",children:Object(d.jsxs)("a",{className:"collapsed",href:"#technicalinfo",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"technicalinfo",children:[Object(d.jsx)("i",{className:"far fa-drafting-compass align-middle mt-n1 mr-2"}),"Technical Info",Object(d.jsx)("span",{className:"accordion-indicator"})]})})}),Object(d.jsx)("div",{className:"collapse",id:"technicalinfo","data-parent":"#productPanels",children:Object(d.jsxs)("div",{className:"card-body font-size-sm",children:[Object(d.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(d.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(d.jsx)("a",{href:"#",children:"Download"})]}),Object(d.jsxs)("div",{className:"d-flex justify-content-between border-bottom py-2",children:[Object(d.jsx)("div",{className:"font-weight-semibold text-dark",children:"Document Title"}),Object(d.jsx)("a",{href:"#",children:"Download"})]})]})})]}),Object(d.jsxs)("div",{className:"card",children:[Object(d.jsx)("div",{className:"card-header",children:Object(d.jsx)("h3",{className:"accordion-heading",children:Object(d.jsxs)("a",{className:"collapsed",href:"#questions",role:"button","data-toggle":"collapse","aria-expanded":"true","aria-controls":"questions",children:[Object(d.jsx)("i",{className:"far fa-question-circle font-size-lg align-middle mt-n1 mr-2"}),"Questions?",Object(d.jsx)("span",{className:"accordion-indicator"})]})})}),Object(d.jsx)("div",{className:"collapse",id:"questions","data-parent":"#productPanels",children:Object(d.jsxs)("div",{className:"card-body",children:[Object(d.jsx)("p",{children:"Have questions about this product?"}),Object(d.jsx)("a",{href:"/contact",children:"Contact Us"})]})})]})]})},p=c(19),h=c(5),m=c(12),f=c.n(m),O=c(293),x=c(46),g=function(e){var t=e.productID,c=e.productName,o=e.productClearance,m=e.productCode,g=e.productDescription,v=e.defaultSku_skuID,N=void 0===v?"":v,I=Object(h.c)(),w=Object(O.a)(),y=w.t,S=(w.i18n,Object(x.i)(N)),D=Object(s.a)(S,2),k=D[0],L=D[1],T=Object(n.useState)(1),C=Object(s.a)(T,2),z=C[0],R=C[1],P=Object(n.useState)({skus:[],options:[],defaultSelectedOptions:"",availableSkuOptions:"",currentGroupId:"",isLoaded:!1}),E=Object(s.a)(P,2),G=E[0],q=E[1],F=Object(n.useRef)([r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef(),r.a.createRef()]),A=function(){var e=F.current.reduce((function(e,t){return t.current?[].concat(Object(l.a)(e),[t.current.value]):e}),[]).join();f()({method:"POST",withCredentials:!0,url:"".concat(u.b,"api/scope/productSkuSelected"),data:{productID:t,selectedOptionIDList:e},headers:{"Content-Type":"application/json"}}).then((function(e){if(200===e.status){var t=e.data.skuID;_(t)}}))},_=function(e){L(Object(a.a)(Object(a.a)({},k),{},{params:{"f:skuID":e},makeRequest:!0,isFetching:!0,isLoaded:!1}))};return Object(n.useEffect)((function(){var e=!1;return G.isLoaded||f()({method:"POST",withCredentials:!0,url:"".concat(u.b,"api/scope/getProductSkus"),data:{productID:t},headers:{"Content-Type":"application/json"}}).then((function(t){if(200!==t.status||e)e||q(Object(a.a)(Object(a.a)({},G),{},{isLoaded:!0}));else{var c=t.data,s=c.options,n=c.skus,r=c.defaultSelectedOptions;q(Object(a.a)(Object(a.a)({},G),{},{skus:n,options:s,defaultSelectedOptions:r,isLoaded:!0})),n.length&&!k.isLoaded&&_(n[0].skuID)}})),function(){e=!0}}),[q,G,t,k,_]),Object(d.jsx)("div",{className:"container bg-light box-shadow-lg rounded-lg px-4 py-3 mb-5",children:Object(d.jsx)("div",{className:"px-lg-3",children:Object(d.jsxs)("div",{className:"row",children:[Object(d.jsx)(j,{productID:t}),Object(d.jsx)("div",{className:"col-lg-6 pt-0",children:Object(d.jsxs)("div",{className:"product-details pb-3",children:[Object(d.jsxs)("div",{className:"d-flex justify-content-between align-items-center mb-2",children:[Object(d.jsxs)("span",{className:"d-inline-block font-size-sm align-middle px-2 bg-primary text-light",children:[" ",!0===o&&" On Special"]}),Object(d.jsx)(i.h,{className:"btn-wishlist mr-0 mr-lg-n3"})]}),Object(d.jsxs)("div",{className:"mb-2",children:[Object(d.jsx)("span",{className:"text-small text-muted",children:"".concat(y("frontend.product.subhead")," ")}),Object(d.jsx)("span",{className:"h4 font-weight-normal text-large text-accent mr-1",children:m})]}),Object(d.jsx)("h2",{className:"h4 mb-2",children:c}),Object(d.jsx)("div",{className:"mb-3 font-weight-light font-size-small text-muted",dangerouslySetInnerHTML:{__html:g}}),Object(d.jsxs)("form",{className:"mb-grid-gutter",onSubmit:function(e){e.preventDefault(),I(Object(p.g)(k.data.skuID,z))},children:[G.options.length>0&&G.options.map((function(e,c){var s=e.optionGroupName,n=e.options,r=e.optionGroupID,i=n.filter((function(e){return G.defaultSelectedOptions.includes(e.optionID)})),o=n;return""!==G.currentGroupId&&r!==G.currentGroupId&&(o=n.filter((function(e){return G.availableSkuOptions.includes(e.optionID)}))),o.length?Object(d.jsxs)("div",{className:"form-group",children:[Object(d.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(d.jsx)("label",{className:"font-weight-medium",htmlFor:r,children:s})}),Object(d.jsx)("select",{className:"custom-select",required:!0,id:r,ref:F.current[c],value:i.length>0&&i[0].optionID||n[0],onChange:function(e){var c=n.reduce((function(e,t){return G.defaultSelectedOptions.includes(t.optionID)?t.optionID:e}),"");!function(){var e=arguments.length>0&&void 0!==arguments[0]?arguments[0]:"",c=arguments.length>1&&void 0!==arguments[1]?arguments[1]:"",s=arguments.length>2?arguments[2]:void 0;f()({method:"POST",withCredentials:!0,url:"".concat(u.b,"api/scope/productAvailableSkuOptions"),data:{productID:t,selectedOptionIDList:e},headers:{"Content-Type":"application/json"}}).then((function(t){if(200===t.status){var n=t.data.availableSkuOptions,r="";r=n.split(",").reduce((function(e,t){return G.defaultSelectedOptions.includes(t)?t:e}),"")?G.defaultSelectedOptions.replace(c,e):e,q(Object(a.a)(Object(a.a)({},G),{},{defaultSelectedOptions:r,availableSkuOptions:n,currentGroupId:s,isLoaded:!0})),A()}}))}(e.target.value,c,r)},children:o&&o.map((function(e){var t=e.optionID,c=e.optionName;return Object(d.jsx)("option",{value:t,children:c},t)}))})]},r):Object(d.jsx)("div",{},r)})),0===G.options.length&&G.skus.length>1&&Object(d.jsxs)("div",{className:"form-group",children:[Object(d.jsx)("div",{className:"d-flex justify-content-between align-items-center pb-1",children:Object(d.jsx)("label",{className:"font-weight-medium",htmlFor:"product-size",children:y("frontend.product.option")})}),Object(d.jsx)("select",{className:"custom-select",required:!0,id:"product-size",children:G.skus&&G.skus.map((function(e){var t=e.skuID,c=e.calculatedSkuDefinition;return Object(d.jsx)("option",{value:t,children:c},t)}))})]}),Object(d.jsxs)("div",{className:"mb-3",children:[Object(d.jsx)("span",{className:"h4 text-accent font-weight-light",children:k.price?k.price:""})," ",Object(d.jsx)("span",{className:"font-size-sm ml-1",children:k.data.listPrice?"".concat(k.data.listPrice," ").concat(y("frontend.core.list")):""})]}),Object(d.jsxs)("div",{className:"form-group d-flex align-items-center",children:[Object(d.jsx)("select",{value:z,onChange:function(e){R(e.target.value)},className:"custom-select mr-3",style:{width:"5rem"},children:k.data.calculatedQATS>0&&Object(l.a)(Array(k.data.calculatedQATS>20?20:k.data.calculatedQATS).keys()).map((function(e,t){return Object(d.jsx)("option",{value:t+1,children:t+1},t+1)}))}),Object(d.jsxs)("button",{className:"btn btn-primary btn-block",type:"submit",children:[Object(d.jsx)("i",{className:"far fa-shopping-cart font-size-lg mr-2"}),y("frontend.product.add_to_cart")]})]})]}),Object(d.jsx)(b,{})]})})]})})})},v=c(73),N=c(314),I=function(e){var t=e.productID,c=Object(O.a)(),r=c.t,i=(c.i18n,Object(n.useState)({products:[],isLoaded:!1,err:"",productID:t})),o=Object(s.a)(i,2),l=o[0],j=o[1];return l.productID!==t&&j({products:[],isLoaded:!1,err:"",productID:t}),Object(n.useEffect)((function(){var e=!1;return l.isLoaded||u.a.products.getRelatedProducts({productID:t}).then((function(t){if(t.isSuccess()&&!e){var c=t.success().relatedProducts;Object(N.b)(c,"relatedProduct_",""),j(Object(a.a)(Object(a.a)({},l),{},{isLoaded:!0,products:c}))}else j(Object(a.a)(Object(a.a)({},l),{},{isLoaded:!0,err:"oops"}))})),function(){e=!0}}),[l,j,t]),Object(d.jsx)(v.a,{title:r("frontend.product.related"),sliderData:l.products})},w=c(9),y=c(301);t.default=function(e){var t=Object(w.h)(),c=Object(y.a)({location:"/404",time:300}),r=Object(s.a)(c,2),l=r[0],u=r[1],j=Object(x.f)(),b=Object(s.a)(j,2),p=b[0],h=b[1],m=Object(n.useState)(t.pathname),f=Object(s.a)(m,2),O=f[0],v=f[1];return Object(n.useEffect)((function(){var e=!1;if(!e&&(!p.isFetching&&!p.isLoaded||t.pathname!==O)){var c=t.pathname.split("/").reverse();v(t.pathname),h(Object(a.a)(Object(a.a)({},p),{},{data:{},params:{filter:{current:1,urlTitle:c[0]}},makeRequest:!0,isFetching:!0,isLoaded:!1}))}return!p.isFetching&&p.isLoaded&&0===Object.keys(p.data).length&&u(Object(a.a)(Object(a.a)({},l),{},{shouldRedirect:!0})),function(){e=!0}}),[p,h,t,O.setPath]),Object(d.jsx)(i.l,{children:Object(d.jsxs)("div",{className:"bg-light p-0",children:[Object(d.jsx)(o,{title:p.data.calculatedTitle}),p.data.productID&&Object(d.jsx)(g,Object(a.a)({},p.data)),p.data.productID&&Object(d.jsx)(I,{productID:p.data.productID})]})})}}}]);
//# sourceMappingURL=17.95e2dc4d.chunk.js.map