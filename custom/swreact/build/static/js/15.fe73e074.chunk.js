(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[15],{522:function(e,t,a){"use strict";a.r(t);var c=a(16),n=a(2),s=a(5),r=a(1),i=a(4),d=a(11),l=a(21),b=(a(28),a(26)),o=(a(59),a(50),a(7)),j=a(39),u=a(0);t.default=function(){var e=Object(d.g)(),t=Object(d.h)(),a=Object(i.d)((function(e){return e.content[t.pathname.substring(1)]})),h=Object(i.d)(j.a),m=Object(r.useState)(1),g=Object(s.a)(m,2),O=g[0],f=g[1],p=a||{},x=p.title,N=p.customBody,v=Object(b.b)(),w=Object(s.a)(v,2),y=w[0],k=w[1];Object(r.useEffect)((function(){var e=!1;return y.isFetching||y.isLoaded||e||k(Object(n.a)(Object(n.a)({},y),{},{isFetching:!0,isLoaded:!1,entity:"brand",params:{"P:Show":500,"f:activeFlag":1},makeRequest:!0})),function(){e=!0}}),[y,k]);var F=[].concat(Object(c.a)(y.data.filter((function(e){return!0===e.brandFeatured})).sort((function(e,t){return e.brandName>t.brandName?1:-1}))),Object(c.a)(y.data.filter((function(e){return!0!==e.brandFeatured})).sort((function(e,t){return e.brandName>t.brandName?1:-1})))),P=12*(O-1),L=P+12;return Object(u.jsxs)("div",{className:"bg-light p-0",children:[Object(u.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(u.jsx)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:Object(u.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center",children:Object(u.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:x||""})})})}),Object(u.jsxs)("div",{className:"container bg-light box-shadow-lg rounded-lg p-5",children:[Object(u.jsx)("div",{className:"content-body",onClick:function(t){t.preventDefault(),t.target.getAttribute("href")&&e.push(t.target.getAttribute("href"))},dangerouslySetInnerHTML:{__html:N||""}}),N&&Object(u.jsx)("hr",{}),Object(u.jsx)("div",{className:"container pb-4 pb-sm-5",children:Object(u.jsx)("div",{className:"row pt-5",children:y.isLoaded&&F.slice(P,L).map((function(e){return Object(u.jsx)("div",{className:"col-md-4 col-sm-6 mb-3",children:Object(u.jsx)("div",{className:"card border-0",children:Object(u.jsxs)(o.b,{className:"d-block overflow-hidden rounded-lg",to:"/".concat(h,"/").concat(e.urlTitle),children:[Object(u.jsx)(l.x,{className:"d-block w-100",customPath:"/custom/assets/images/brand/logo/",src:e.imageFile,alt:e.brandName}),Object(u.jsx)("h2",{className:"h5",children:e.brandName})]})})},e.brandID)}))})}),Object(u.jsx)("div",{className:"container pb-4 pb-sm-5",children:Object(u.jsx)(l.q,{recordsCount:F.length,currentPage:O,totalPages:Math.ceil(F.length/12),setPage:f})})]})]})}}}]);
//# sourceMappingURL=15.fe73e074.chunk.js.map