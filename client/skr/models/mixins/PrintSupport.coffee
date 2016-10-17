Skr.Models.Mixins.PrintSupport = {

    _mixinPrintFormIdentifier: ->
        if @printFormIdentifier then @printFormIdentifier() else @modelTypeIdentifier()

    pdfDownloadUrl: ->
        "//#{Lanes.config.api_host}#{Lanes.config.api_path}/skr/print/#{@_mixinPrintFormIdentifier()}/#{@hash_code}.pdf"

}
