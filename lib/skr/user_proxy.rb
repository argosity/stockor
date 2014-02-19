module Skr

    # The UserProxy simply a stand-in for the real user
    # model that will be implementation specific by the user of Stockor Core
    class UserProxy


        # The user who's currently interacting with Stockor.
        # Defaults to 0, indicating anonymous or unknown
        # @return [Object,FixNum] whatever was set using scoped_to, or 0 if nothing was set
        def self.current
            Thread.current[:skr_user_proxy] || 0
        end

        # Retrieve the current id of the user we're proxying for.
        # get's a bit complicated since we can proxy both for a user object
        # or just the user's id
        def self.current_id
            self.current.is_a?(Fixnum) ? self.current : self.current.id
        end

        # sets the user for the duration of the block
        # @example Inside a Rails controller
        #
        #     class DocumentsController < ApplicationController
        #         around_filter :set_skr_user
        #
        #         # update's the Document's owner to current
        #         # But sets all the notes to be owned by admin
        #         def update_owner
        #             doc = Document.find(params[:id])
        #             doc.current_owner = Skr::UserProxy.current
        #             Skr::UserProxy.scoped_to( User.admin ) do
        #                 doc.notes.each{ |note| note.set_owner_to_current! } # will set to Skr::UserProxy.current
        #             end
        #         end
        #
        #         private
        #
        #         def set_skr_user
        #             user = SuperUserModel.find( session[:user] )
        #             Skr::UserProxy.scoped_to( user ) do
        #                  yield
        #             end
        #          end
        #      end
        #
        # @return [UserProxy] self
        def self.scoped_to( user )
            prev_user, Thread.current[:skr_user_proxy] = self.currrent, user
            yield
            self
        ensure
            Thread.current[:skr_user_proxy] = prev_user
        end


    end
end
