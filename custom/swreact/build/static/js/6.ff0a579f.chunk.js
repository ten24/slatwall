(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[6,18],{517:function(t,e,c){"use strict";var r=c(3),n=c(15),a=(c(1),c(0)),s=function(){var t=Object(n.g)(),e=Object(n.h)().pathname.split("/").reverse()[0],c=Object(r.d)((function(t){return Object.keys(t.content).map((function(e){return t.content[e]&&t.content[e].settings&&"sidebar.cfm"===t.content[e].settings.contentTemplateFile?(t.content[e].key=e,t.content[e]):null})).filter((function(t){return t})).map((function(t){return t.key.includes("".concat(e,"/"))?t:null})).filter((function(t){return t}))}),[]);return Object(a.jsx)("aside",{className:"col-lg-4 pt-4 pt-lg-0",children:Object(a.jsx)("div",{className:"cz-sidebar-static rounded-lg box-shadow-lg p-4 mb-5",children:c&&c.sort((function(t,e){return t.sortOrder-e.sortOrder})).map((function(e,c){return Object(a.jsxs)("div",{children:[Object(a.jsx)("div",{onClick:function(e){e.target.getAttribute("href")&&(e.preventDefault(),e.target.getAttribute("href").includes("http")?window.location.href=e.target.getAttribute("href"):t.push(e.target.getAttribute("href")))},dangerouslySetInnerHTML:{__html:e.customBody}}),e.customSummary.length&&Object(a.jsx)("iframe",{title:"location Map",src:e.customSummary.replace(/(<([^>]+)>)/gi,""),width:"400",height:"250",frameBorder:"0",style:{border:0},"aria-hidden":"false",tabIndex:"0"})]},c)}))})})};e.a=function(t){var e=t.children,c=Object(n.g)(),i=Object(n.h)().pathname.split("/").reverse()[0].toLowerCase(),l=Object(r.d)((function(t){return t.content[i]}))||{},o=l.title,d=l.customSummary;return Object(a.jsxs)(a.Fragment,{children:[Object(a.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4 pb-5",children:Object(a.jsx)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:Object(a.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(a.jsx)("h1",{className:"h3 mb-0",children:o||""})})})}),Object(a.jsx)("div",{className:"container pb-5 mb-2 mb-md-3",children:Object(a.jsxs)("div",{className:"row",children:[Object(a.jsx)("section",{className:"col-lg-8",children:Object(a.jsxs)("div",{className:"mt-5 pt-5",children:[Object(a.jsx)("div",{onClick:function(t){t.preventDefault(),t.target.getAttribute("href")&&(t.target.getAttribute("href").includes("http")?window.location.href=t.target.getAttribute("href"):c.push(t.target.getAttribute("href")))},dangerouslySetInnerHTML:{__html:d||""}}),e]})}),Object(a.jsx)(s,{})]})})]})}},519:function(t,e,c){"use strict";c.r(e);var r=c(3),n=c(15),a=c(0);e.default=function(){var t=Object(n.g)(),e=Object(r.d)((function(t){return t.content[404]}))||{};return Object(a.jsxs)("div",{className:"container py-5 mb-lg-3",onClick:function(e){e.target.getAttribute("href")&&(e.preventDefault(),e.target.getAttribute("href").includes("http")?window.location.href=e.target.getAttribute("href"):t.push(e.target.getAttribute("href")))},children:[Object(a.jsx)("div",{className:"row justify-content-center pt-lg-4 text-center",children:Object(a.jsxs)("div",{className:"col-lg-5 col-md-7 col-sm-9",children:[Object(a.jsx)("h1",{className:"display-404",children:e.title}),Object(a.jsx)("div",{dangerouslySetInnerHTML:{__html:e.customSummary}})]})}),Object(a.jsx)("div",{className:"row justify-content-center",children:Object(a.jsx)("div",{className:"col-xl-8 col-lg-10",children:Object(a.jsx)("div",{dangerouslySetInnerHTML:{__html:e.customBody}})})})]})}},538:function(t,e,c){"use strict";c.r(e);var r=c(3),n=c(28),a=c(1),s=c(15),i=c(519),l=c(517),o=c(2),d=c(5),u=c(32),g=c(19),b=c.n(g),h=c(0),j=function(){var t=Object(s.g)(),e=Object(s.h)(),c=b.a.parse(e.search,{arrayFormat:"separator",arrayFormatSeparator:","}),i=Object(r.d)((function(t){return t.content[e.pathname.substring(1)]})),l=i||{},g=l.title,j=l.customBody,m=Object(a.useState)(e.search),f=Object(d.a)(m,2),p=f[0],O=f[1],x=Object(u.h)(c),v=Object(d.a)(x,2),y=v[0],N=v[1];return Object(a.useEffect)((function(){var t=!1;return t||(y.isFetching||y.isLoaded)&&e.search===p||!i.productListingPageFlag||(O(e.search),N(Object(o.a)(Object(o.a)({},y),{},{params:Object(o.a)(Object(o.a)({},c),{},{content_id:i.contentID,includePotentialFilters:!1}),makeRequest:!0,isFetching:!0,isLoaded:!1}))),function(){t=!0}}),[y,N,c,e,p,i]),Object(h.jsxs)("div",{className:"bg-light p-0",children:[Object(h.jsx)("div",{className:"page-title-overlap bg-lightgray pt-4",children:Object(h.jsx)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:Object(h.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center",children:Object(h.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:g||""})})})}),Object(h.jsxs)("div",{className:"container bg-light box-shadow-lg rounded-lg p-5",children:[Object(h.jsx)("div",{className:"content-body mb-5",onClick:function(e){e.preventDefault(),e.target.getAttribute("href")&&(e.target.getAttribute("href").includes("http")?window.location.href=e.target.getAttribute("href"):t.push(e.target.getAttribute("href")))},dangerouslySetInnerHTML:{__html:j||""}}),i.productListingPageFlag&&Object(h.jsxs)("div",{className:"col",children:[Object(h.jsx)(n.x,{isFetching:y.isFetching,pageRecords:y.data.pageRecords}),Object(h.jsx)(n.y,{recordsCount:y.data.recordsCount,currentPage:y.data.currentPage,totalPages:y.data.totalPages,setPage:function(t){c.currentPage=t,y.data.currentPage=t,N(Object(o.a)(Object(o.a)({},y),{},{params:{currentPage:t,content_id:i.contentID,includePotentialFilters:!1},makeRequest:!0,isFetching:!0,isLoaded:!1}))}})]})]})]})},m={BasicPageWithSidebar:l.a,BasicPage:j,NotFound:i.default};e.default=function(){var t=Object(s.h)().pathname.split("/").reverse()[0].toLowerCase(),e=Object(r.d)((function(t){return t.content})),c="NotFound";return!e.isFetching&&e[t]&&(c=e[t].settings.contentTemplateFile.replace(".cfm","")),console.log("content",e),Object(h.jsx)(n.w,{children:!e.isFetching&&Object(a.createElement)(m[c])})}}}]);
//# sourceMappingURL=6.ff0a579f.chunk.js.map