(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[27],{340:function(e,t,c){"use strict";c.r(t);var a=c(0),s=c(1),n=c(27),r=c(5),i=c(2),l=c(34);var o=Object(r.b)((function(e){return Object(i.a)({},e.content.products)}))((function(e){var t=e.title,c=e.crumbs,i=Object(r.c)();return Object(s.useEffect)((function(){i(Object(l.d)({content:{products:["customBody","customSummary","title"]}}))}),[i]),Object(a.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(a.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(a.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(a.jsx)(n.b,{crumbs:c})}),Object(a.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(a.jsx)("h1",{className:"h3 text-dark mb-0",children:t})})]})})})),j=c(107);var d=Object(r.b)((function(e){var t=e.productSearchReducer;return Object(i.a)({},t)}))((function(e){var t=e.pageRecords;return Object(a.jsx)("div",{className:"row mx-n2",children:t&&t.map((function(e,t){return Object(a.jsx)("div",{className:"col-md-4 col-sm-6 px-2 mb-4",children:Object(a.jsx)(j.a,Object(i.a)({},e))},t)}))})})),b=c(12),m=c(302);var u=Object(r.b)((function(e){var t=e.preload,c=e.productSearchReducer;return Object(i.a)(Object(i.a)({},t.productListing),c)}))((function(e){var t=e.sortingOptions,c=e.appliedFilters,s=e.sortBy,n=Object(r.c)(),i=Object(m.a)(),l=i.t;i.i18n;return Object(a.jsxs)("div",{className:"d-flex justify-content-center justify-content-sm-between align-items-center pt-2 pb-4 pb-sm-5",children:[Object(a.jsx)("div",{className:"d-flex flex-wrap",children:Object(a.jsxs)("div",{className:"form-inline flex-nowrap mr-3 mr-sm-4 pb-sm-3",children:[Object(a.jsx)("label",{className:"text-dark opacity-75 text-nowrap mr-2 d-none d-sm-block",children:l("frontend.plp.search.applied_filters")}),c&&c.map((function(e,t){var c=e.name,s=e.filterName;return Object(a.jsxs)("span",{className:"badge badge-light border p-2 mr-2",children:[Object(a.jsx)("a",{onClick:function(e){n(Object(b.q)({name:c,filterName:s}))},children:Object(a.jsx)("i",{className:"far fa-times"})}),c]},t)}))]})}),Object(a.jsxs)("div",{className:"d-sm-flex pb-3 align-items-center",children:[Object(a.jsx)("label",{className:"text-dark opacity-75 text-nowrap mr-2 mb-0 d-none d-sm-block",htmlFor:"sorting",children:"Sort by:"}),Object(a.jsx)("select",{className:"form-control custom-select",id:"sorting",value:s,onChange:function(e){n(Object(b.u)(e.target.value)),n(Object(b.r)())},children:t&&t.map((function(e,t){var c=e.name,s=e.value;return Object(a.jsx)("option",{value:s,children:c},t)}))})]})]})})),O=c(59),p="LEFT",h="RIGHT",x=function(e,t){for(var c=arguments.length>2&&void 0!==arguments[2]?arguments[2]:1,a=e,s=[];a<=t;)s.push(a),a+=c;return s};var f=Object(r.b)((function(e){return e.productSearchReducer}))((function(e){var t=e.recordsCount,c=e.pageNeighbours,s=void 0===c?2:c,n=e.currentPage,i=e.totalPages,l=void 0===i?1:i,o=Object(r.c)(),j=Object(m.a)(),d=j.t,u=(j.i18n,function(e){var t=Math.max(0,Math.min(e,l));o(Object(b.s)(t)),o(Object(b.r)())}),f=function(){var e=2*s+3;if(l>e+2){var t=Math.max(2,n-s),c=Math.min(l-1,n+s),a=x(t,c),r=t>2,i=l-c>1,o=e-(a.length+1);switch(!0){case r&&!i:var j=x(t-o,t-1);a=[p].concat(Object(O.a)(j),Object(O.a)(a));break;case!r&&i:var d=x(c+1,c+o);a=[].concat(Object(O.a)(a),Object(O.a)(d),[h]);break;case r&&i:default:a=[p].concat(Object(O.a)(a),[h])}return[1].concat(Object(O.a)(a),[l])}return x(1,l)}();return t&&1!==l?Object(a.jsx)("nav",{className:"d-flex justify-content-between pt-2","aria-label":"Page navigation",children:Object(a.jsx)("ul",{className:"mx-auto pagination",children:f.map((function(e,t){return e===p?Object(a.jsx)("li",{className:"page-item",children:Object(a.jsxs)("div",{className:"page-link",href:"","aria-label":"Previous",onClick:function(e){e.preventDefault(),u(n-2*s-1)},children:[Object(a.jsx)("span",{"aria-hidden":"true",children:"\xab"}),Object(a.jsx)("span",{className:"sr-only",children:d("frontend.pagination.previous")})]})},t):e===h?Object(a.jsx)("li",{className:"page-item",children:Object(a.jsxs)("div",{className:"page-link","aria-label":"Next",onClick:function(e){e.preventDefault(),u(n+2*s+1)},children:[Object(a.jsx)("span",{"aria-hidden":"true",children:"\xbb"}),Object(a.jsx)("span",{className:"sr-only",children:d("frontend.pagination.next")})]})},t):Object(a.jsx)("li",{className:"page-item".concat(n===e?" active":""),children:Object(a.jsx)("div",{className:"page-link",onClick:function(t){t.preventDefault();var c=Math.max(0,Math.min(e,l));o(Object(b.s)(c)),o(Object(b.r)())},children:e})},t)}))})}):null})),v=c(43),g=c(99),N=c.n(g),y=function(e){var t=e.name,c=e.count,s=e.sub,n=e.filterName,i=e.isSelected,l=Object(r.c)(),o=n.replace(/\s/g,"")+t.replace(/\s/g,"")+"input";return Object(a.jsx)("li",{className:"widget-list-item cz-filter-item",children:Object(a.jsxs)("div",{className:"widget-list-link d-flex justify-content-between align-items-center",children:[Object(a.jsx)("span",{className:"cz-filter-item-text",children:Object(a.jsxs)("div",{className:"custom-control custom-checkbox",children:[Object(a.jsx)("input",{className:"custom-control-input",type:"checkbox",checked:i,onChange:function(e){l(Object(b.v)({name:t,filterName:n})),l(Object(b.r)())},id:o}),Object(a.jsxs)("label",{className:"custom-control-label",htmlFor:o,children:[t," ",Object(a.jsx)("span",{className:"font-size-xs text-muted",children:s})]})]})}),c&&Object(a.jsx)("span",{className:"font-size-xs text-muted ml-3",children:c})]})})},w=function(e){var t=e.name,c=e.count,s=e.filterName,n=Object(r.c)();return Object(a.jsx)("li",{className:"widget-list-item cz-filter-item",children:Object(a.jsxs)("a",{className:"widget-list-link d-flex justify-content-between align-items-center",onClick:function(e){n(Object(b.n)({name:t,filterName:s})),n(Object(b.r)())},children:[Object(a.jsx)("span",{className:"cz-filter-item-text",children:t}),c&&Object(a.jsx)("span",{className:"font-size-xs text-muted ml-3",children:c})]})})},k=function(e){var t=e.searchTerm,c=e.search;return Object(a.jsxs)("div",{className:"input-group-overlay input-group-sm mb-2",children:[Object(a.jsx)("input",{className:"cz-filter-search form-control form-control-sm appended-form-control",value:t,onChange:function(e){c(e.target.value)},type:"text",placeholder:"Search"}),Object(a.jsx)("div",{className:"input-group-append-overlay",children:Object(a.jsx)("span",{className:"input-group-text",children:Object(a.jsx)("i",{className:"far fa-search"})})})]})};var z=Object(r.b)((function(e){return Object(i.a)({},e.productSearchReducer)}))((function(e){var t=e.appliedFilters,c=(e.key,e.filterName),n=e.options,r=e.index,l=e.type,o=Object(s.useState)(""),j=Object(v.a)(o,2),d=j[0],b=j[1],m=Object(s.useState)([]),u=Object(v.a)(m,2),O=u[0],p=u[1];return Object(s.useEffect)((function(){var e=t.filter((function(e){return e.filterName===c})),a=n.filter((function(t){var c=t.name;return!e.some((function(e){return e.name!==c}))}));d.length&&(a=n.filter((function(e){return e.name.toLowerCase().includes(d.toLowerCase())}))),p(a)}),[d,n,t,c]),Object(a.jsxs)("div",{className:"card border-bottom pt-1 pb-2 my-1",children:[Object(a.jsx)("div",{className:"card-header",children:Object(a.jsx)("h3",{className:"accordion-heading",children:Object(a.jsxs)("a",{className:"collapsed",href:"#filer".concat(r),role:"button","data-toggle":"collapse","aria-expanded":"false","aria-controls":"productType",children:[c,Object(a.jsx)("span",{className:"accordion-indicator"})]})})}),Object(a.jsx)("div",{className:"collapse",id:"filer".concat(r),"data-parent":"#shop-categories",children:Object(a.jsx)("div",{className:"card-body",children:Object(a.jsxs)("div",{className:"widget widget-links cz-filter",children:[Object(a.jsx)(k,{searchTerm:d,search:b}),Object(a.jsx)("ul",{className:"widget-list cz-filter-list pt-1",style:{height:"12rem"},"data-simplebar":!0,"data-simplebar-auto-hide":"false",children:O&&O.map((function(e,t){return"attribute"===l?Object(s.createElement)(y,Object(i.a)(Object(i.a)({},e),{},{key:t,filterName:c})):Object(s.createElement)(w,Object(i.a)(Object(i.a)({},e),{},{key:t,filterName:c}))}))})]})})})]})}));var C=Object(r.b)((function(e){return e.productSearchReducer}))((function(e){var t=e.keyword,c=e.possibleFilters,n=e.attributes,l=e.recordsCount,o=Object(r.c)(),j=Object(s.useState)(t),d=Object(v.a)(j,2),u=d[0],O=d[1],p=Object(m.a)(),h=p.t,x=(p.i18n,Object(s.useCallback)(N()((function(e){o(Object(b.t)(e)),o(Object(b.r)())}),500),[N.a,o]));return Object(a.jsxs)("div",{className:"cz-sidebar rounded-lg box-shadow-lg",id:"shop-sidebar",children:[Object(a.jsx)("div",{className:"cz-sidebar-header box-shadow-sm",children:Object(a.jsxs)("button",{className:"close ml-auto",type:"button","data-dismiss":"sidebar","aria-label":"Close",children:[Object(a.jsxs)("span",{className:"d-inline-block font-size-xs font-weight-normal align-middle",children:[h("frontend.core.close_sidebar")," "]}),Object(a.jsx)("span",{className:"d-inline-block align-middle ml-2","aria-hidden":"true",children:Object(a.jsx)("i",{className:"far fa-times"})})]})}),Object(a.jsx)("div",{className:"cz-sidebar-body","data-simplebar":!0,"data-simplebar-auto-hide":"true",children:Object(a.jsxs)("div",{className:"widget widget-categories mb-3",children:[Object(a.jsxs)("div",{className:"row",children:[Object(a.jsx)("h3",{className:"widget-title col",children:h("frontend.core.filters")}),Object(a.jsx)("span",{className:"text-right col",children:"".concat(l," ").concat(h("frontend.core.results"))})]}),Object(a.jsxs)("div",{className:"input-group-overlay input-group-sm mb-2",children:[Object(a.jsx)("input",{className:"cz-filter-search form-control form-control-sm appended-form-control",type:"text",value:u,onChange:function(e){O(e.target.value),x(e.target.value)},placeholder:h("frontend.plp.search.placeholder")}),Object(a.jsx)("div",{className:"input-group-append-overlay",children:Object(a.jsx)("span",{className:"input-group-text",children:Object(a.jsx)("i",{className:"fa fa-search"})})})]}),Object(a.jsxs)("div",{className:"accordion mt-3 border-top",id:"shop-categories",children:[c&&c.map((function(e,t){return Object(a.jsx)(z,Object(i.a)({index:"filter".concat(t)},e),t)})),n&&n.map((function(e,t){return Object(a.jsx)(z,Object(i.a)({type:"attribute",index:"attr".concat(t)},e),t)}))]})]})})]})}));t.default=function(){var e=Object(r.c)();return Object(s.useEffect)((function(){e(Object(b.r)()),e(Object(b.p)())}),[e]),Object(a.jsxs)(n.i,{children:[Object(a.jsx)(o,{}),Object(a.jsx)("div",{className:"container pb-5 mb-2 mb-md-4",children:Object(a.jsxs)("div",{className:"row",children:[Object(a.jsx)("aside",{className:"col-lg-4",children:Object(a.jsx)(C,{})}),Object(a.jsxs)("div",{className:"col-lg-8",children:[Object(a.jsx)(u,{r:!0}),Object(a.jsx)(d,{}),Object(a.jsx)(f,{})]})]})})]})}}}]);
//# sourceMappingURL=27.e4ad25a8.chunk.js.map