(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[25],{305:function(e,t,c){"use strict";var s=c(24),n=c(6),r=c(13),a=c(0);t.a=function(e){var t=e.children,c=Object(r.h)().pathname.split("/").reverse()[0].toLowerCase(),l=Object(n.d)((function(e){return e.content[c]}))||{};return Object(a.jsxs)("div",{className:"page-title-overlap bg-lightgray pt-4",children:[Object(a.jsxs)("div",{className:"container d-lg-flex justify-content-between py-2 py-lg-3",children:[Object(a.jsx)("div",{className:"order-lg-2 mb-3 mb-lg-0 pt-lg-2",children:Object(a.jsx)(s.b,{})}),Object(a.jsx)("div",{className:"order-lg-1 pr-lg-4 text-center text-lg-left",children:Object(a.jsx)("h1",{className:"h3 text-dark mb-0 font-accent",children:l.title||""})})]}),t]})}},569:function(e,t,c){"use strict";c.r(t);var s=c(9),n=c(24),r=c(6),a=c(296),l=c(13),i=c(17),b=c(1),o=c(33),d=c(305),j=c(0);t.default=function(){var e=Object(a.a)().t,t=Object(r.c)(),c=Object(r.d)((function(e){return e.cart})),m=Object(l.g)(),h=c.total,u=c.isFetching,O=Object(o.a)({}),p=Object(s.a)(O,1)[0];return Object(b.useEffect)((function(){t(Object(i.o)())}),[t]),Object(j.jsxs)(n.l,{children:[Object(j.jsx)(d.a,{}),Object(j.jsx)("div",{className:"container pb-5 mb-2 mb-md-4",children:Object(j.jsxs)("div",{className:"row",children:[Object(j.jsxs)("section",{className:"col-lg-8",children:[Object(j.jsxs)("div",{className:"d-flex justify-content-between align-items-center pt-3 pb-2 pb-sm-5 mt-1",children:[Object(j.jsx)("h2",{className:"h6 mb-0",children:e("frontend.cart.heading")}),Object(j.jsxs)("button",{className:"btn btn-outline-primary btn-sm pl-2",disabled:u,onClick:function(e){e.preventDefault(),m.goBack()},children:[Object(j.jsx)("i",{className:"far fa-chevron-left"})," ",e("frontend.order.continue_shopping")]})]}),c.orderItems&&c.orderItems.map((function(e){var t=e.orderItemID;return Object(j.jsx)(n.d,{orderItemID:t},t)}))]}),Object(j.jsx)("aside",{className:"col-lg-4 pt-4 pt-lg-0",children:Object(j.jsxs)("div",{className:"cz-sidebar-static rounded-lg box-shadow-lg ml-lg-auto",children:[Object(j.jsx)(n.p,{}),Object(j.jsxs)("div",{className:"text-center mb-4 pb-3 border-bottom",children:[Object(j.jsx)("h2",{className:"h6 mb-3 pb-1",children:e("frontend.order.subtotal")}),Object(j.jsx)("h3",{className:"font-weight-normal",children:p(h)})]}),Object(j.jsx)(n.e,{}),Object(j.jsx)("button",{className:"btn btn-primary btn-block mt-4",disabled:c.isFetching,onClick:function(e){e.preventDefault(),m.push("/checkout")},children:e("frontend.order.to_checkout")})]})})]})})]})}}}]);
//# sourceMappingURL=25.645ef40a.chunk.js.map