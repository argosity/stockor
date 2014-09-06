module Skr

    # The UserProxy is a stand-in for the real user
    # model that will be implementation specific by the user of Stockor Core
    class UserProxy

        # The user who's currently interacting with Stockor.
        # Defaults to 0, indicating anonymous or unknown
        # @return [Object,FixNum] whatever was set using scoped_to, or 0 if nothing was set
        def self.current
            Thread.current[:skr_user_proxy]
        end

        # Retrieve the current id of the user we're proxying for.
        # get's a bit complicated since we can proxy both for a user object
        # or just the user's id
        # @return [Fixnum] current user's ID.  If the current user is not set, returns 0
        def self.current_id
            if self.current.nil?
                0
            else
                self.current.is_a?(Fixnum) ? self.current : self.current.id
            end
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
            prev_user, Thread.current[:skr_user_proxy] = self.current, user
            yield user
        ensure
            Thread.current[:skr_user_proxy] = prev_user
        end
    end
end
