(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[10],{238:function(e,t,c){"use strict";var s=c(0),a=c(6),r=c(35),n=c(21),i=c(7),l=function(e){var t=e.user,c=Object(i.c)();return Object(s.jsx)("aside",{className:"col-lg-4 pt-4 pt-lg-0",children:Object(s.jsxs)("div",{className:"cz-sidebar-static rounded-lg box-shadow-lg px-0 pb-0 mb-5 mb-lg-0",children:[Object(s.jsx)("div",{className:"px-4 mb-4",children:Object(s.jsx)("div",{className:"media align-items-center",children:Object(s.jsxs)("div",{className:"media-body",children:[Object(s.jsx)("h3",{className:"font-size-base mb-0",children:"".concat(t.firstName," ").concat(t.lastName)}),Object(s.jsx)("a",{href:"#",onClick:function(){c(Object(n.f)())},className:"text-accent font-size-sm",children:"Logout"}),Object(s.jsx)("br",{}),Object(s.jsx)(a.b,{to:"/testing"})]})})}),Object(s.jsx)("div",{className:"bg-secondary px-4 py-3",children:Object(s.jsx)("h3",{className:"font-size-sm mb-0 text-muted",children:Object(s.jsx)(a.b,{to:"/my-account",className:"nav-link-style active",children:"Overview"})})}),Object(s.jsxs)("ul",{className:"list-unstyled mb-0",children:[Object(s.jsx)("li",{className:"border-bottom mb-0",children:Object(s.jsxs)(a.b,{to:"/my-account/order-history",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(s.jsx)("i",{className:"far fa-shopping-bag pr-2"})," Order History"]})}),Object(s.jsx)("li",{className:"border-bottom mb-0",children:Object(s.jsxs)(a.b,{to:"/my-account/profile",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(s.jsx)("i",{className:"far fa-user pr-2"})," Profile Info"]})}),Object(s.jsx)("li",{className:"border-bottom mb-0",children:Object(s.jsxs)(a.b,{to:"/my-account/favorites",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(s.jsx)("i",{className:"far fa-heart pr-2"})," Favorties"]})}),Object(s.jsx)("li",{className:"border-bottom mb-0",children:Object(s.jsxs)(a.b,{to:"/my-account/addresses",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(s.jsx)("i",{className:"far fa-map-marker-alt pr-2"})," Addresses"]})}),Object(s.jsx)("li",{className:"mb-0",children:Object(s.jsxs)(a.b,{to:"/my-account/cards",className:"nav-link-style d-flex align-items-center px-4 py-3",children:[Object(s.jsx)("i",{className:"far fa-credit-card pr-2"})," Payment Methods"]})})]})]})})},j=function(e){var t=e.crumbs,c=e.title;return Object(s.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(s.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(s.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(s.jsx)(r.b,{crumbs:t})}),Object(s.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(s.jsx)("h1",{className:"h3 mb-0",children:c})})]})})};t.a=Object(i.b)((function(e){return{user:e.userReducer}}))((function(e){var t=e.crumbs,c=e.children,a=e.title,r=e.user;return Object(s.jsxs)(s.Fragment,{children:[Object(s.jsx)(j,{crumbs:t,title:a}),Object(s.jsx)("div",{className:"container pb-5 mb-2 mb-md-3",children:Object(s.jsxs)("div",{className:"row",children:[Object(s.jsx)(l,{user:r}),Object(s.jsx)("section",{className:"col-lg-8",children:c})]})})]})}))},261:function(e,t,c){"use strict";c.r(t);var s=c(2),a=c(36),r=c(0),n=c(1),i=c(7),l=(c(13),c(11)),j=c(29),o="LEFT",d="RIGHT",b=function(e,t){for(var c=arguments.length>2&&void 0!==arguments[2]?arguments[2]:1,s=e,a=[];s<=t;)a.push(s),s+=c;return a},m=function(e){var t=e.recordsCount,c=e.pageNeighbours,s=void 0===c?2:c,a=e.currentPage,n=e.totalPages,i=void 0===n?0:n,l=e.setCurrentPage,m=function(e){var t=Math.max(0,Math.min(e,i));l(t)},u=function(){var e=2*s+3;if(i>e+2){var t=Math.max(2,a-s),c=Math.min(i-1,a+s),r=b(t,c),n=t>2,l=i-c>1,m=e-(r.length+1);switch(!0){case n&&!l:var u=b(t-m,t-1);r=[o].concat(Object(j.a)(u),Object(j.a)(r));break;case!n&&l:var x=b(c+1,c+m);r=[].concat(Object(j.a)(r),Object(j.a)(x),[d]);break;case n&&l:default:r=[o].concat(Object(j.a)(r),[d])}return[1].concat(Object(j.a)(r),[i])}return b(1,i)}();return t&&1!==i?Object(r.jsx)("nav",{className:"d-flex justify-content-between pt-2","aria-label":"Page navigation",children:Object(r.jsx)("ul",{className:"mx-auto pagination",children:u.map((function(e,t){return e===o?Object(r.jsx)("li",{className:"page-item",children:Object(r.jsxs)("div",{className:"page-link",href:"","aria-label":"Previous",onClick:function(e){e.preventDefault(),m(a-2*s-1)},children:[Object(r.jsx)("span",{"aria-hidden":"true",children:"\xab"}),Object(r.jsx)("span",{className:"sr-only",children:"Previous"})]})},t):e===d?Object(r.jsx)("li",{className:"page-item",children:Object(r.jsxs)("div",{className:"page-link","aria-label":"Next",onClick:function(e){e.preventDefault(),m(a+2*s+1)},children:[Object(r.jsx)("span",{"aria-hidden":"true",children:"\xbb"}),Object(r.jsx)("span",{className:"sr-only",children:"Next"})]})},t):Object(r.jsx)("li",{className:"page-item".concat(a===e?" active":""),children:Object(r.jsx)("div",{className:"page-link",onClick:function(t){t.preventDefault();var c=Math.max(0,Math.min(e,i));l(c)},children:e})},t)}))})}):null},u=c(238),x=function(e){var t=e.term,c=e.updateTerm;return Object(r.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5 mb-lg-3",children:Object(r.jsxs)("div",{className:"d-flex justify-content-between w-100",children:[Object(r.jsxs)("div",{className:"input-group-overlay d-lg-flex mr-3 w-50",children:[Object(r.jsx)("input",{className:"form-control appended-form-control",type:"text",value:t,onChange:function(e){c(e.target.value)},placeholder:"Search item ##, order ##, or PO"}),Object(r.jsx)("div",{className:"input-group-append-overlay",children:Object(r.jsx)("span",{className:"input-group-text",children:Object(r.jsx)("i",{className:"far fa-search"})})})]}),Object(r.jsxs)("a",{href:"##",className:"btn btn-outline-secondary",children:[Object(r.jsx)("i",{className:"far fa-file-alt mr-2"})," Request Statement"]})]})})},O=function(e){var t=e.trackingNumbers;return Object(r.jsxs)("div",{className:"btn-group",children:[Object(r.jsx)("button",{type:"button",className:"btn bg-white dropdown-toggle","data-toggle":"dropdown","aria-haspopup":"true","aria-expanded":"false",children:Object(r.jsx)("i",{className:"far fa-shipping-fast"})}),Object(r.jsxs)("div",{className:"dropdown-menu dropdown-menu-right",children:[Object(r.jsx)("span",{children:"Tracking Numbers:"}),t&&t.map((function(e,t){return Object(r.jsx)("a",{className:"dropdown-item",href:"##",children:e},t)}))]})]})},h=function(e){var t=e.type,c=void 0===t?"info":t,s=e.text;return Object(r.jsx)("span",{className:"badge badge-".concat(c," m-0"),children:s})},p=function(e){var t=e.orderNumber,c=e.createdDateTime,s=e.orderStatusType_typeName,a=e.calculatedTotal,n=e.trackingNumbers;return Object(r.jsxs)("tr",{children:[Object(r.jsxs)("td",{className:"py-3",children:[Object(r.jsx)("a",{className:"nav-link-style font-weight-medium font-size-sm",href:"##","data-toggle":"modal",children:t}),Object(r.jsx)("br",{})]}),Object(r.jsx)("td",{className:"py-3",children:c}),Object(r.jsx)("td",{className:"py-3",children:Object(r.jsx)(h,{text:s})}),Object(r.jsx)("td",{className:"py-3",children:a}),Object(r.jsx)("td",{className:"py-3",children:Object(r.jsx)(O,{trackingNumbers:n})})]})},f=function(e){var t=e.sortDirection,c=void 0===t?"":t,s=e.setSortDirection;return Object(r.jsx)("span",{className:"s-sort-arrows",children:Object(r.jsx)("svg",{className:"nc-icon outline",xmlns:"http://www.w3.org/2000/svg",x:"0px",y:"0px",width:"20px",height:"20px",viewBox:"0 0 64 64",children:Object(r.jsxs)("g",{transform:"translate(0.5, 0.5)",children:[Object(r.jsx)("polygon",{onClick:function(){s&&s("ASC")},className:"s-ascending",fill:"ASC"===c?"black":"gray",stroke:"#cccccc",strokeWidth:"3",strokeLinecap:"square",strokeMiterlimit:"10",points:"20,26 44,26 32,12 ",strokeLinejoin:"round"}),Object(r.jsx)("polygon",{onClick:function(){s&&s("DESC")},className:"s-descending",fill:"DESC"===c?"black":"gray",stroke:"#cccccc",strokeWidth:"3",strokeLinecap:"square",strokeMiterlimit:"10",points:"44,38 20,38 32,52 ",strokeLinejoin:"round"})]})})})},g=function(){var e=Object(n.useState)(1),t=Object(a.a)(e,2),c=t[0],i=t[1],j=Object(n.useState)("ASC"),o=Object(a.a)(j,2),d=o[0],b=o[1],u=Object(n.useState)(""),O=Object(a.a)(u,2),h=O[0],g=O[1],N=Object(n.useState)(""),v=Object(a.a)(N,2),y=v[0],k=v[1],w=Object(n.useState)({orders:[],records:0,isLoaded:!1}),S=Object(a.a)(w,2),C=S[0],D=S[1];return Object(n.useEffect)((function(){C.isLoaded||l.a.account.orders().then((function(e){e.isFail()?D(Object(s.a)(Object(s.a)({},C),{},{isLoaded:!0})):D({orders:e.success().ordersOnAccount.ordersOnAccount,records:e.success().ordersOnAccount.records,isLoaded:!0})}))}),[C,l.a]),Object(r.jsxs)(r.Fragment,{children:[Object(r.jsx)(x,{term:y,updateTerm:k}),Object(r.jsx)("div",{className:"table-responsive font-size-md",children:Object(r.jsxs)("table",{className:"table table-hover mb-0",children:[Object(r.jsx)("thead",{children:Object(r.jsxs)("tr",{children:[Object(r.jsx)("th",{children:"Order #"}),Object(r.jsxs)("th",{children:["Date Purchased",Object(r.jsx)(f,{sortDirection:d,setSortDirection:b})]}),Object(r.jsxs)("th",{children:["Status",Object(r.jsx)(f,{sortDirection:h,setSortDirection:g})]}),Object(r.jsx)("th",{children:"Order Total"}),Object(r.jsx)("th",{})]})}),Object(r.jsx)("tbody",{children:C&&C.orders.map((function(e,t){return Object(r.jsx)(p,Object(s.a)({},e),t)}))})]})}),Object(r.jsx)("hr",{className:"pb-4"}),Object(r.jsx)(m,{recordsCount:C.records,currentPage:c,setCurrentPage:i})]})};t.default=Object(i.b)((function(e){return Object(s.a)(Object(s.a)({},e.preload.accountOrderHistory),{},{user:e.userReducer})}))((function(e){e.crumbs,e.title;var t=e.orders;return Object(r.jsx)(u.a,{title:"Account Order History",children:Object(r.jsx)(g,{orders:t})})}))}}]);
//# sourceMappingURL=10.28d86294.chunk.js.map