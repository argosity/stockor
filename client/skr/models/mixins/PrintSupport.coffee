Skr.Models.Mixins.PrintSupport = {

    pdfDownloadUrl: ->
        "#{Lanes.config.api_path}/skr/print/#{@modelTypeIdentifier()}/#{@hash_code}.pdf"

}
