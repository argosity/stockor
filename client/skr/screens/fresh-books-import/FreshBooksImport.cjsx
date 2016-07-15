##= require_self
##= require ./Import
##= require ./ApiInfo
##= require ./ChooseRecords
##= require ./ViewRecords

class Skr.Screens.FreshBooksImport extends Skr.Screens.Base
    modelForAccess: 'invoice'
    getInitialState: -> isEditing: true
    modelBindings:
        import: ->
            new Skr.Screens.FreshBooksImport.Import

    JobStatus: ->
        return null unless @import.job.isExecuting
        message = if @import.stage is 'complete'
            "Importing records from Fresh Books"
        else
            "Loading record summaries from Fresh Books"
        <LC.JobStatus job={@import.job} onlyExecuting
            message={message} />

    render: ->
        <LC.ScreenWrapper identifier="fresh-books-import">
            <LC.ErrorDisplay model={@import} />

            <Skr.Screens.FreshBooksImport.ApiInfo import={@import} />
            <@JobStatus />
            <Skr.Screens.FreshBooksImport.ChooseRecords import={@import} />
            <Skr.Screens.FreshBooksImport.ViewRecords import={@import} />
        </LC.ScreenWrapper>
