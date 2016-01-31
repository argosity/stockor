##= require_self
##= require ./Import
##= require ./ApiInfo
##= require ./ChooseRecords
##= require ./ViewRecords
##= require ./data

class Skr.Screens.FreshBooksImport extends Skr.Screens.Base
    modelForAccess: 'invoice'
    getInitialState: -> isEditing: true
    dataObjects:
        import: ->
            i = new Skr.Screens.FreshBooksImport.Import
            # i.stage = 'complete'
            # i.job.data = { output: Skr.Screens.FreshBooksImport.DATA }
            i

    jobStatus: ->
        return null unless @import.job.isExecuting
        message = if @import.stage is 'complete'
            "Importing records from Fresh Books"
        else
            "Loading record summaries from Fresh Books"
        <LC.JobStatus job={@import.job} onlyExecuting
            message={message} />

    render: ->
        window.jss = @import.job
        <LC.ScreenWrapper identifier="fresh-books-import">
            <Skr.Screens.FreshBooksImport.ApiInfo import={@import} />
            {@jobStatus()}
            <Skr.Screens.FreshBooksImport.ChooseRecords import={@import} />
            <Skr.Screens.FreshBooksImport.ViewRecords import={@import} />
        </LC.ScreenWrapper>
