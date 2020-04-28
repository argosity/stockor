!function(e,n,t,a,s,m,i,o,r,d){n.Screens.Payments=function(){function t(){}return t.prototype.displayName="Skr.Screens.Payments",t.prototype.FILE=o,t.prototype.syncOptions={include:["address","bank_account","category","vendor"]},t.prototype.modelBindings={payment:function(){return this.loadOrCreateModel({syncOptions:this.syncOptions,klass:n.Models.Payment,prop:"payment",attribute:"visible_id"})},query:function(){return new e.Models.Query({syncOptions:this.syncOptions,src:n.Models.Payment,fields:[{id:"id",visible:!1},{id:"visible_id",title:"Payment ID",fixedWidth:130},{id:"check_number",title:"Check #",fixedWidth:130},{id:"name",flex:1},{id:"amount",fixedWidth:120,textAlign:"right",format:e.u.format.currency}]})}},t.prototype.getInitialState=function(){return{commands:new n.Screens.Commands(this,{modelName:"payment"})}},t.prototype.render=function(){return m.createElement(s.ScreenWrapper,{identifier:"payments"},m.createElement(a.ScreenControls,{commands:this.state.commands}),m.createElement(i.Row,null,m.createElement(s.RecordFinder,{ref:"finder",sm:2,autoFocus:!0,editOnly:!0,commands:this.state.commands,model:this.category,label:"Payment ID",name:"visible_id",model:this.payment,query:this.query}),m.createElement(a.LocationChooser,{hideSingle:!0,sm:2,model:this.payment}),m.createElement(a.BankAccountFinder,{selectField:!0,name:"bank_account",model:this.payment}),m.createElement(a.PaymentCategoryFinder,{selectField:!0,name:"category",sm:2,labelField:"code",label:"Cateogry",model:this.payment}),m.createElement(s.DateTime,{name:"date",format:"ddd, MMM Do YYYY",sm:3,model:this.payment}),this.payment.isNew()?void 0:m.createElement(s.DisplayValue,{align:"right",label:"Number",model:this.payment,name:"check_number",sm:1})),m.createElement(i.Row,null),m.createElement(i.Row,null,m.createElement(a.VendorFinder,{sm:2,selectField:!0,syncOptions:{include:["billing_address"]},model:this.payment}),m.createElement(s.Input,{sm:6,name:"name",model:this.payment}),m.createElement(s.NumberInput,{smOffset:1,sm:3,name:"amount",align:"right",model:this.payment})),m.createElement(i.Row,null,m.createElement(s.TextArea,{smOffset:2,sm:6,name:"address",model:this.payment})),m.createElement(i.Row,null,m.createElement(s.Input,{sm:12,name:"notes",model:this.payment})))},t}(),n.Screens.Payments=n.Screens.Base.extend(n.Screens.Payments)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","payments","Payments"]},window);