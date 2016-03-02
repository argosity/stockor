class Skr.Models.PaymentCategory extends Skr.Models.Base

    props:
        id:           {"type":"integer"}
        code:         {type:"code"}
        name:         {"type":"string"}
        gl_account_id:{"type":"integer"}

    mixins: [ 'HasCodeField' ]

    associations:
        gl_account: { model: "GlAccount", required: true }
