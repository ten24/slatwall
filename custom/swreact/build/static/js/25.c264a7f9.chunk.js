(this.webpackJsonpswreact=this.webpackJsonpswreact||[]).push([[25],{451:function(e,s,t){"use strict";t.r(s);var c=t(2),r=t(12),a=t(1),n=t(5),i=t(295),l=t(29),d=t(0),j=function(e){var s=e.Quantity,t=e.ProductTitle,c=e.BrandName,r=e.isSeries,a=e.ProductSeries,n=e.totalPrice,i=e.listPrice,j=e.price,m=e.skuCode,b=e.imgUrl;return Object(d.jsxs)("div",{className:"d-sm-flex justify-content-between align-items-center my-4 pb-3 border-bottom",children:[Object(d.jsxs)("div",{className:"media media-ie-fix d-block d-sm-flex align-items-center text-center text-sm-left",children:[Object(d.jsx)("a",{className:"d-inline-block mx-auto mr-sm-4",style:{width:"10rem"},children:Object(d.jsx)(l.n,{src:b,alt:"Product"})}),Object(d.jsxs)("div",{className:"media-body pt-2",children:[r&&Object(d.jsx)("span",{className:"product-meta d-block font-size-xs pb-1",children:a}),Object(d.jsx)("h3",{className:"product-title font-size-base mb-2",children:Object(d.jsx)("a",{href:"shop-single-v1.html",children:t})}),Object(d.jsxs)("div",{className:"font-size-sm",children:[c," ",Object(d.jsx)("span",{className:"text-muted mr-2",children:m})]}),Object(d.jsxs)("div",{className:"font-size-sm",children:["$".concat(j," each "),Object(d.jsx)("span",{className:"text-muted mr-2",children:"($".concat(i," list)")})]}),Object(d.jsx)("div",{className:"font-size-lg text-accent pt-2",children:"$".concat(n)})]})]}),Object(d.jsxs)("div",{className:"pt-2 pt-sm-0 pl-sm-3 mx-auto mx-sm-0 text-center text-sm-left",style:{width:"9rem"},children:[Object(d.jsxs)("div",{className:"form-group mb-0",children:[Object(d.jsx)("label",{className:"font-weight-medium",children:"Quantity"}),Object(d.jsx)("span",{children:s})]}),Object(d.jsx)("a",{href:"#",className:"btn btn-outline-secondary",children:"Re-order"})]})]})},m=function(e){var s=e.shipments;return Object(d.jsx)("div",{className:"order-items mr-3",children:s&&s.map((function(e,t){return Object(d.jsxs)("div",{className:"shippment mb-5",children:[Object(d.jsxs)("div",{className:"row order-tracking bg-lightgray p-2",children:[Object(d.jsx)("div",{className:"col-sm-6",children:"Shippment ".concat(t+1," of ").concat(s.length)}),Object(d.jsxs)("div",{className:"col-sm-6 text-right",children:["Tracking Number: ",Object(d.jsx)("a",{href:"#",target:"_blank",children:e.trackingNumber})]})]}),e.items&&e.items.map((function(e,s){return Object(d.jsx)(j,{item:e},s)}))]})}))})},b=function(){return Object(d.jsxs)("div",{className:"d-flex justify-content-between mb-4 mr-3",children:[Object(d.jsxs)("a",{href:"##",className:"previous-btn",children:[Object(d.jsx)("i",{className:"far fa-chevron-left"}),"Previous Order"]}),Object(d.jsxs)("a",{href:"##",className:"next-btn",children:["Next Order",Object(d.jsx)("i",{className:"far fa-chevron-right"})]})]})},o=function(e){var s=e.delivered;return Object(d.jsx)("div",{className:"d-flex justify-content-between align-items-center pt-lg-2 pb-4 pb-lg-5",children:Object(d.jsxs)("div",{className:"row justify-content-between w-100 align-items-center",children:[Object(d.jsxs)("div",{className:"col-sm-6",children:["Status ",Object(d.jsx)("span",{className:"badge badge-success m-0 p-2 ml-2",children:s})]}),Object(d.jsx)("div",{className:"col-sm-6",children:Object(d.jsxs)("div",{className:"row justify-content-end",children:[Object(d.jsx)("div",{className:"mr-3",children:Object(d.jsxs)("a",{href:"#",className:"btn btn-outline-secondary",children:[Object(d.jsx)("i",{className:"far fa-box-full mr-2"})," Request RMA"]})}),Object(d.jsx)("div",{children:Object(d.jsxs)("a",{href:"#",className:"btn btn-outline-secondary",children:[Object(d.jsx)("i",{className:"far fa-print mr-2"})," Print"]})})]})})]})})};s.default=function(e){var s=e.path,t=e.forwardState||{orderID:""},l=Object(a.useState)(Object(c.a)(Object(c.a)({},t),{},{isLoaded:!1})),j=Object(r.a)(l,2),h=j[0],x=j[1];return Object(a.useEffect)((function(){var e=!1;return h.isLoaded||n.a.account.orders({orderID:s}).then((function(s){s.isSuccess()&&!e&&s.success().ordersOnAccount.ordersOnAccount.length?x(Object(c.a)(Object(c.a)({},s.success().ordersOnAccount.ordersOnAccount[0]),{},{isLoaded:!0})):x(Object(c.a)(Object(c.a)({},h),{},{isLoaded:!0}))})),function(){e=!0}}),[h,s,x]),Object(d.jsxs)(i.a,{title:"Order: ".concat(h.orderNumber||""),children:[Object(d.jsx)(o,{delivered:h.orderStatusType_typeName}),Object(d.jsx)(b,{}),Object(d.jsx)(m,{order:h})]})}}}]);
//# sourceMappingURL=25.c264a7f9.chunk.js.map