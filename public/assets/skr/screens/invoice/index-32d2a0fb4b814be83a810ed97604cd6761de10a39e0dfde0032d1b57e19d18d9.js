!function(e,n,t,i,o,s,r,a,c,l){n.Screens.Invoice=function(){function e(){}return e.prototype.displayName="Skr.Screens.Invoice",e.prototype.FILE=a,e.prototype.syncOptions={"with":["with_details"],include:["sales_order","billing_address","shipping_address","lines"]},e.prototype.dataObjects={invoice:function(){return this.loadOrCreateModel({syncOptions:this.syncOptions,klass:n.Models.Invoice,prop:"invoice",attribute:"visible_id"})}},e.prototype.getInitialState=function(){return{commands:new n.Screens.Commands(this,{modelName:"invoice",print:!0})}},e.prototype.setSalesOrder=function(e){return this.invoice.setFromSalesOrder(e)},e.prototype.onPayment=function(){return this.invoice.save()},e.prototype.getPayment=function(){return this.context.viewport.displayModal({title:"Accept Payment",autoHide:!0,size:"sm",onOk:this.onPayment,body:function(e){return function(){return s.createElement(n.Screens.Invoice.Payment,{invoice:e.invoice})}}(this)})},e.prototype.PaymentButton=function(){return this.invoice.isNew()||this.invoice.isPaidInFull()?null:s.createElement(i.ToolbarButton,{onClick:this.getPayment},s.createElement(o.Icon,{type:"money"}),"Payment")},e.prototype.shouldSaveLinesImmediately=function(){return!this.invoice.isNew()},e.prototype.linesQueryBuilder=function(e){var n;return this.invoice.isNew()||(n=t.find(e.fields,{id:"sku_code"}),n.editable=!1),e},e.prototype.render=function(){return s.createElement(o.ScreenWrapper,{identifier:"invoice",flexVertical:!0},s.createElement(i.ScreenControls,{commands:this.state.commands},s.createElement(this.PaymentButton,null)),s.createElement(r.Row,null,s.createElement(i.InvoiceFinder,{ref:"finder",editOnly:!0,sm:2,xs:3,model:this.invoice,commands:this.state.commands,syncOptions:this.syncOptions}),s.createElement(i.SalesOrderFinder,{autoFocus:!1,sm:2,xs:3,editOnly:!1,onModelSet:this.setSalesOrder,associationName:"sales_order",syncOptions:this.syncOptions,parentModel:this.invoice}),s.createElement(i.CustomerFinder,{selectField:!0,sm:3,xs:6,model:this.invoice}),s.createElement(i.TermsChooser,{model:this.invoice,sm:3,xs:6}),s.createElement(o.DisplayValue,{sm:2,xs:4,name:"state",model:this.invoice})),s.createElement(r.Row,null,s.createElement(o.Input,{name:"po_num",model:this.invoice,sm:3,xs:6}),s.createElement(o.DateTime,{name:"invoice_date",format:"ddd, MMM Do YYYY",sm:3,model:this.invoice}),s.createElement(i.PrintFormChooser,{label:"Print Form",sm:3,xs:4,model:this.invoice}),s.createElement(i.LocationChooser,{sm:3,xs:4,label:"Src Location",model:this.invoice})),s.createElement(r.Row,null,s.createElement(o.TextArea,{name:"notes",model:this.invoice})),s.createElement(r.Row,null,s.createElement(o.FieldSet,{sm:12,title:"Address",expanded:this.invoice.isNew()},s.createElement(i.Address,{lg:6,title:"Billing",model:this.invoice.billing_address}),s.createElement(i.Address,{lg:6,title:"Shipping",model:this.invoice.shipping_address}))),s.createElement(i.SkuLines,{location:this.invoice.location,queryBuilder:this.linesQueryBuilder,saveImmediately:this.shouldSaveLinesImmediately,commands:this.state.commands,lines:this.invoice.lines}),s.createElement(i.TotalsLine,{model:this.invoice}))},e}(),n.Screens.Invoice=n.Screens.Base.extend(n.Screens.Invoice)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","invoice","Invoice"]},window),function(e,n,t,i,o,s,r,a,c,l){n.Screens.Invoice.Payment=function(){function e(){}return e.prototype.displayName="Skr.Screens.Invoice.Payment",e.prototype.FILE=a,e.prototype.dataObjects={invoice:"props"},e.prototype.componentDidMount=function(){return this.invoice.amount_paid=this.invoice.open_amount},e.prototype.onEnter=function(){return this.props.modal.onButton()},e.prototype.render=function(){return s.createElement(o.ScreenWrapper,{identifier:"payment"},s.createElement(r.Row,null,s.createElement(o.DisplayValue,{name:"total",getValue:function(){return t.sprintf("%0.2f",Number(this.total))},model:this.invoice,align:"right"}),s.createElement(o.DisplayValue,{name:"prev_amount_paid",label:"Amount Paid",getValue:function(){return t.sprintf("%0.2f",Number(this.prev_amount_paid))},model:this.invoice,align:"right"}),s.createElement(o.Input,{label:"Amount",editOnly:!0,autoFocus:!0,getValue:function(){return t.sprintf("%0.2f",Number(this.amount_paid))},onEnter:this.onEnter,name:"amount_paid",align:"right",model:this.invoice})))},e}(),n.Screens.Invoice.Payment=e.React.Component.extend(n.Screens.Invoice.Payment)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","invoice","Payment"]},window);