class Skr.Models.GlPeriod extends Skr.Models.Base

    FILE: FILE

    props:
        id:       {"type":"integer","required":true}
        year:     {"type":"integer","required":true}
        period:   {"type":"integer","required":true}
        is_locked:{"type":"boolean","required":true,"default":"false"}

