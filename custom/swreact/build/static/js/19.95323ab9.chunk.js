(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[19],{315:function(e,t,c){"use strict";c.r(t);var n=c(41),a=c(2),r=c(0),s=c(1),i=c(5),o=c(7),l=c(9),d=c(56),j=c(273),b="LEFT",u="RIGHT",O=function(e,t){for(var c=arguments.length>2&&void 0!==arguments[2]?arguments[2]:1,n=e,a=[];n<=t;)a.push(n),n+=c;return a},h=function(e){var t=e.recordsCount,c=e.pageNeighbours,n=void 0===c?2:c,a=e.currentPage,s=e.totalPages,i=void 0===s?0:s,o=e.setCurrentPage,l=Object(j.a)(),h=l.t,p=(l.i18n,function(e){var t=Math.max(0,Math.min(e,i));o(t)}),m=function(){var e=2*n+3;if(i>e+2){var t=Math.max(2,a-n),c=Math.min(i-1,a+n),r=O(t,c),s=t>2,o=i-c>1,l=e-(r.length+1);switch(!0){case s&&!o:var j=O(t-l,t-1);r=[b].concat(Object(d.a)(j),Object(d.a)(r));break;case!s&&o:var h=O(c+1,c+l);r=[].concat(Object(d.a)(r),Object(d.a)(h),[u]);break;case s&&o:default:r=[b].concat(Object(d.a)(r),[u])}return[1].concat(Object(d.a)(r),[i])}return O(1,i)}();return t&&1!==i?Object(r.jsx)("nav",{className:"d-flex justify-content-between pt-2","aria-label":h("frontend.pagination.nav"),children:Object(r.jsx)("ul",{className:"mx-auto pagination",children:m.map((function(e,t){return e===b?Object(r.jsx)("li",{className:"page-item",children:Object(r.jsxs)("div",{className:"page-link",href:"","aria-label":h("frontend.pagination.previous"),onClick:function(e){e.preventDefault(),p(a-2*n-1)},children:[Object(r.jsx)("span",{"aria-hidden":"true",children:"\xab"}),Object(r.jsx)("span",{className:"sr-only",children:h("frontend.pagination.previous")})]})},t):e===u?Object(r.jsx)("li",{className:"page-item",children:Object(r.jsxs)("div",{className:"page-link","aria-label":h("frontend.pagination.next"),onClick:function(e){e.preventDefault(),p(a+2*n+1)},children:[Object(r.jsx)("span",{"aria-hidden":"true",children:"\xbb"}),Object(r.jsx)("span",{className:"sr-only",children:h("frontend.pagination.next")})]})},t):Object(r.jsx)("li",{className:"page-item".concat(a===e?" active":""),children:Object(r.jsx)("div",{className:"page-link",onClick:function(t){t.preventDefault();var c=Math.max(0,Math.min(e,i));o(c)},children:e})},t)}))})}):null},p=c(276),m=function(e){var t=e.term,c=e.updateTerm,n=Object(j.a)(),a=n.t;n.i18n;return Object(r.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(r.jsxs)("div",{className:"d-flex justify-content-between w-100",children:[Object(r.jsxs)("div",{className:"input-group-overlay d-lg-flex mr-3 w-50",children:[Object(r.jsx)("input",{className:"form-control appended-form-control",type:"text",value:t,onChange:function(e){c(e.target.value)},placeholder:"Search item #, order #, or PO"}),Object(r.jsx)("div",{className:"input-group-append-overlay",children:Object(r.jsx)("span",{className:"input-group-text",children:Object(r.jsx)("i",{className:"far fa-search"})})})]}),Object(r.jsxs)("a",{href:"##",className:"btn btn-outline-secondary",children:[Object(r.jsx)("i",{className:"far fa-file-alt mr-2"})," ",a("frontend.account.request_statement")]})]})})},x=function(e){var t=e.trackingNumbers,c=Object(j.a)(),n=c.t;c.i18n;return Object(r.jsxs)("div",{className:"btn-group",children:[Object(r.jsx)("button",{type:"button",className:"btn bg-white dropdown-toggle","data-toggle":"dropdown","aria-haspopup":"true","aria-expanded":"false",children:Object(r.jsx)("i",{className:"far fa-shipping-fast"})}),Object(r.jsxs)("div",{className:"dropdown-menu dropdown-menu-right",children:[Object(r.jsxs)("span",{children:[n("frontend.account.tracking_numbers"),":"]}),t&&t.map((function(e,t){return Object(r.jsx)("a",{className:"dropdown-item",href:"##",children:e},t)}))]})]})},f=function(e){var t=e.type,c=void 0===t?"info":t,n=e.text;return Object(r.jsx)("span",{className:"badge badge-".concat(c," m-0"),children:n})},g=function(e){var t=e.orderNumber,c=e.orderID,n=e.createdDateTime,s=e.orderStatusType_typeName,i=e.calculatedTotal,l=e.trackingNumbers;return Object(r.jsxs)("tr",{children:[Object(r.jsxs)("td",{className:"py-3",children:[Object(r.jsx)(o.b,{className:"nav-link-style font-weight-medium font-size-sm",to:{pathname:"/my-account/orders/".concat(c),state:Object(a.a)({},e)},children:t}),Object(r.jsx)("br",{})]}),Object(r.jsx)("td",{className:"py-3",children:n}),Object(r.jsx)("td",{className:"py-3",children:Object(r.jsx)(f,{text:s})}),Object(r.jsx)("td",{className:"py-3",children:i}),Object(r.jsx)("td",{className:"py-3",children:Object(r.jsx)(x,{trackingNumbers:l})})]})},v=function(e){var t=e.sortDirection,c=void 0===t?"":t,n=e.setSortDirection;return Object(r.jsx)("span",{className:"s-sort-arrows",children:Object(r.jsx)("svg",{className:"nc-icon outline",xmlns:"http://www.w3.org/2000/svg",x:"0px",y:"0px",width:"20px",height:"20px",viewBox:"0 0 64 64",children:Object(r.jsxs)("g",{transform:"translate(0.5, 0.5)",children:[Object(r.jsx)("polygon",{onClick:function(){n&&n("ASC")},className:"s-ascending",fill:"ASC"===c?"black":"gray",stroke:"#cccccc",strokeWidth:"3",strokeLinecap:"square",strokeMiterlimit:"10",points:"20,26 44,26 32,12 ",strokeLinejoin:"round"}),Object(r.jsx)("polygon",{onClick:function(){n&&n("DESC")},className:"s-descending",fill:"DESC"===c?"black":"gray",stroke:"#cccccc",strokeWidth:"3",strokeLinecap:"square",strokeMiterlimit:"10",points:"44,38 20,38 32,52 ",strokeLinejoin:"round"})]})})})},N=function(){var e=Object(s.useState)(1),t=Object(n.a)(e,2),c=t[0],i=t[1],o=Object(s.useState)("ASC"),d=Object(n.a)(o,2),b=d[0],u=d[1],O=Object(s.useState)(""),p=Object(n.a)(O,2),x=p[0],f=p[1],N=Object(s.useState)(""),k=Object(n.a)(N,2),y=k[0],w=k[1],C=Object(s.useState)({orders:[],records:0,isLoaded:!1}),S=Object(n.a)(C,2),D=S[0],L=S[1],M=Object(j.a)(),T=M.t;M.i18n;return Object(s.useEffect)((function(){D.isLoaded||l.a.account.orders().then((function(e){e.isFail()?L(Object(a.a)(Object(a.a)({},D),{},{isLoaded:!0})):L({orders:e.success().ordersOnAccount.ordersOnAccount,records:e.success().ordersOnAccount.records,isLoaded:!0})}))}),[D,l.a]),Object(r.jsxs)(r.Fragment,{children:[Object(r.jsx)(m,{term:y,updateTerm:w}),Object(r.jsx)("div",{className:"table-responsive font-size-md",children:Object(r.jsxs)("table",{className:"table table-hover mb-0",children:[Object(r.jsx)("thead",{children:Object(r.jsxs)("tr",{children:[Object(r.jsxs)("th",{children:[T("frontend.account.order.heading")," #"]}),Object(r.jsxs)("th",{children:[T("frontend.account.order.date"),Object(r.jsx)(v,{sortDirection:b,setSortDirection:u})]}),Object(r.jsxs)("th",{children:[T("frontend.account.order.status"),Object(r.jsx)(v,{sortDirection:x,setSortDirection:f})]}),Object(r.jsxs)("th",{children:[" ",T("frontend.account.order.total")]}),Object(r.jsx)("th",{})]})}),Object(r.jsx)("tbody",{children:D&&D.orders.map((function(e,t){return Object(r.jsx)(g,Object(a.a)({},e),t)}))})]})}),Object(r.jsx)("hr",{className:"pb-4"}),Object(r.jsx)(h,{recordsCount:D.records,currentPage:c,setCurrentPage:i})]})};t.default=Object(i.b)((function(e){return Object(a.a)(Object(a.a)({},e.configuration.accountOrderHistory),{},{user:e.userReducer})}))((function(e){e.crumbs,e.title;var t=e.orders,c=Object(j.a)(),n=c.t;c.i18n;return Object(r.jsx)(p.a,{title:n("frontend.account.account_order_history"),children:Object(r.jsx)(N,{orders:t})})}))}}]);
//# sourceMappingURL=19.95323ab9.chunk.js.map