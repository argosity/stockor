##= require 'skr/models/Base'

class Skr.Api.Models.Base extends Skr.Models.Base

    constructor: ->
        super


    api_path: ->
        '/skr/public/' + _.pluralize(@modelTypeIdentifier())
