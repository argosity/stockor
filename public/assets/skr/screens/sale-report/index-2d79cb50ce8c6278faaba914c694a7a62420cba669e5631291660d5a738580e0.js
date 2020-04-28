!function(e,t,n,r,i,s,o,a,d,l){var c;c=function(){function r(){r.__super__.constructor.apply(this,arguments)}return r.prototype.FILE=a,r.prototype.session={start_at:{type:"date","default":function(){return n.moment().subtract(1,"week").toDate()}},end_at:{type:"date","default":function(){return new Date}},sku:{type:"state"},customer:{type:"state"}},r.prototype.derived={query:{deps:["start_at","end_at","sku","customer"],fn:function(){var n;return n={"with":{with_details:!0},query:{invoice_date:{op:"in",value:[this.start_at.toISOString(),this.end_at.toISOString()]}}},this.sku&&(n["with"].with_sku_id=this.sku.id),this.customer&&(n.query.customer_id=this.customer.id),new e.Models.Query({title:"Lines",src:t.Models.Invoice,syncOptions:n,fields:[{id:"id",visible:!1},{id:"visible_id",title:"Invoice #",fixedWidth:100},{id:"invoice_date",title:"Date",format:e.u.format.shortDate,fixedWidth:100},{id:"customer_code",title:"Customer",fixedWidth:120},{id:"customer_name"},{id:"invoice_total",title:"Total",fixedWidth:120,textAlign:"right",format:e.u.format.currency}]})}}},r}(),e.Models.State.extend(c),t.Screens.SaleReport=function(){function e(){}return e.prototype.displayName="Skr.Screens.SaleReport",e.prototype.FILE=a,e.prototype.modelBindings={filters:function(){return new c}},e.prototype.resetQuery=function(){return this.filters.clear()},e.prototype.onPrint=function(e){return this.setState({isPrinting:e}),e?this.filters.query.results.loadFully():void 0},e.prototype.render=function(){var e;return e={sm:3,xs:4,writable:!0,editOnly:!0,model:this.filters,step:15},s.createElement(i.ScreenWrapper,{flexVertical:!0,identifier:"sales-report"},s.createElement(o.Panel,{header:s.createElement(i.PanelHeader,{title:"Sales Report"},s.createElement(r.PrintButton,{onPrint:this.onPrint,iconOnly:!0}),s.createElement(i.Icon,{onClick:this.resetQuery,type:"repeat",noPrint:!0}))},s.createElement(o.Row,null,s.createElement(i.DateTime,Object.assign({},e,{name:"start_at"})),s.createElement(i.DateTime,Object.assign({},e,{name:"end_at"})),s.createElement(r.SkuFinder,Object.assign({},e,{parentModel:this.filters,associationName:"sku"})),s.createElement(r.CustomerFinder,Object.assign({},e,{name:"code",parentModel:this.filters,associationName:"customer"})))),s.createElement(i.Grid,{renderCompleteResults:this.state.isPrinting,query:this.filters.query}))},e}(),t.Screens.SaleReport=t.Screens.Base.extend(t.Screens.SaleReport)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","sale-report","SaleReport"]},window);