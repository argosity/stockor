class Skr.Screens.Commands extends Lanes.Screens.Commands

    constructor: ->
        super

    canPrint: ->
        model = @getModel()
        not model.isNew() and model?.pdfDownloadUrl

    printModel: ->
        model = @getModel()
        width  = Math.min(1000, window.screen.width - 20)
        height = Math.min(800, window.screen.height - 30)
        options = ["toolbar=no", "location=" + (if window.opera then "no" else "yes"),
          "directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no",
          "width=" + width, "height=" + height,
          "top="   + (window.screen.height - height) / 2,
          "left="  + (window.screen.width - width)   / 2].join()

        prn = window.open('', 'lanes-print', options)
        printFn = ->
            prn.location.href = _.result(model, 'pdfDownloadUrl')
            _.delay ->
                prn?.print?()
            , 5000 # onload doesn't seem to work with PDF's so we just delay a bit
        if model.isDirty
            model.save().then printFn
        else
            printFn()
