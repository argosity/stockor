class Roles
    grantsFor: ->
        {create:true,read:true,update:true,delete:true }


class Skr.Data.User extends Skr.Data.Model

    initialize: ->
        @roles = new Roles


Skr.current_user ||= new Skr.Data.User
