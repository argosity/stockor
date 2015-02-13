class Skr.Models.GlAccount extends Skr.Models.Base

    FILE: FILE

    props:
        id:         {"type":"integer","required":true}
        number:     {"type":"string","required":true}
        name:       {"type":"string","required":true}
        description:{"type":"string","required":true}
        is_active:  {"type":"boolean","required":true,"default":"true"}
