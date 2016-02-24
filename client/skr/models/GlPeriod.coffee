class Skr.Models.GlPeriod extends Skr.Models.Base

    props:
        id:       {type:"integer"}
        year:     {type:"integer", required: true}
        period:   {type:"integer", required: true}
        is_locked:{type:"boolean", default:false}
