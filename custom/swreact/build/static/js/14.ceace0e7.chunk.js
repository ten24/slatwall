(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[14],{525:function(e,t,c){"use strict";c.r(t);var a=c(24),n=c(2),r=c(5),s=c(1),i=c(3),l=c(13),d=c(28),o=(c(33),c(34)),b=(c(66),c(57),c(8)),j=c(46),u=c(0);t.default=function(){var e=Object(l.g)(),t=Object(l.h)(),c=Object(i.d)((function(e){return e.configuration.shopByManufacturer})),h=c.gridSize,m=c.maxCount,g=4*h,O=Object(i.d)((function(e){return e.content[t.pathname.substring(1)]})),f=Object(i.d)(j.a),x=Object(s.useState)(1),p=Object(r.a)(x,2),N=p[0],v=p[1],w=O||{},y=w.title,F=w.customBody,k=Object(o.b)(),P=Object(r.a)(k,2),L=P[0],S=P[1];Object(s.useEffect)((function(){var e=!1;return L.isFetching||L.isLoaded||e||S(Object(n.a)(Object(n.a)({},L),{},{isFetching:!0,isLoaded:!1,entity:"brand",params:{"P:Show":m,"f:activeFlag":1},makeRequest:!0})),function(){e=!0}}),[L,S,m]);var C=[].concat(Object(a.a)(L.data.filter((function(e){return!0===e.brandFeatured})).sort((function(e,t){return e.brandName>t.brandName?1:-1}))),Object(a.a)(L.data.filter((function(e){return!0!==e.brandFeatured})).sort((function(e,t){return e.brandName>t.brandName?1:-1})))),M=(N-1)*g,A=M+g;return Object(u.jsx)(d.r,{children:Object(u.jsxs)("div",{className:"bg-light p-0",children:[Object(u.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(u.jsx)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:Object(u.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center",children:Object(u.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:y||""})})})}),Object(u.jsxs)("div",{className:"container bg-light box-shadow-lg rounded-lg p-5",children:[Object(u.jsx)("div",{className:"content-body",onClick:function(t){t.preventDefault(),t.target.getAttribute("href")&&e.push(t.target.getAttribute("href"))},dangerouslySetInnerHTML:{__html:F||""}}),F&&Object(u.jsx)("hr",{}),Object(u.jsx)("div",{className:"pb-4 pb-sm-5",children:Object(u.jsx)("div",{className:"row",children:L.isLoaded&&C.slice(M,A).map((function(e){return Object(u.jsx)("div",{className:"d-flex col-6 col-sm-4 col-md-3 col-lg-2 mb-4",children:Object(u.jsxs)(b.b,{className:"card border-1 shadow-sm text-center d-flex flex-column rounded-lg hover-shadow-none",to:"/".concat(f,"/").concat(e.urlTitle),children:[Object(u.jsx)("div",{className:"d-flex align-items-center flex-1",children:Object(u.jsx)(d.F,{className:"d-block w-100 p-2",customPath:"/custom/assets/images/brand/logo/",src:e.imageFile,alt:e.brandName})}),Object(u.jsx)("h2",{className:"h6 mx-1",children:e.brandName})]})},e.brandID)}))})}),Object(u.jsx)("div",{className:"container",children:Object(u.jsx)(d.t,{recordsCount:C.length,currentPage:N,totalPages:Math.ceil(C.length/g),setPage:v})})]})]})})}}}]);
//# sourceMappingURL=14.ceace0e7.chunk.js.map