!function(e,n,t,r,m,o,s,a,d,i){n.Screens.PaymentTerms=function(){function e(){}return e.prototype.displayName="Skr.Screens.PaymentTerms",e.prototype.FILE=a,e.prototype.modelBindings={term:function(){return this.loadOrCreateModel({klass:n.Models.PaymentTerm,prop:"term",attribute:"code"})}},e.prototype.getInitialState=function(){return{commands:new n.Screens.Commands(this,{modelName:"term"})}},e.prototype.render=function(){return o.createElement(m.ScreenWrapper,{identifier:"payment-terms"},o.createElement(r.ScreenControls,{commands:this.state.commands}),o.createElement(s.Row,null,o.createElement(r.TermsChooser,{useFinder:!0,ref:"finder",name:"code",sm:3,autoFocus:!0,editOnly:!0,model:this.term,commands:this.state.commands}),o.createElement(m.Input,{sm:9,name:"description",model:this.term})),o.createElement(s.Row,null,o.createElement(m.NumberInput,{sm:2,name:"days",format:"##",model:this.term}),o.createElement(m.NumberInput,{sm:2,name:"discount_days",format:"##",model:this.term}),o.createElement(m.Input,{sm:2,name:"discount_amount",model:this.term})))},e}(),n.Screens.PaymentTerms=n.Screens.Base.extend(n.Screens.PaymentTerms)}(window.Lanes,window.Lanes?window.Lanes.Skr:null,window.Lanes.Vendor.ld,window.Lanes.Skr.Components,window.Lanes.Components,window.Lanes.Vendor.React,window.Lanes.Vendor.ReactBootstrap,{namespace:window.Lanes.Skr,extension:{name:"Skr",identifier:"skr"},path:["skr","screens","payment-terms","PaymentTerms"]},window);