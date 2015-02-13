module Skr

    class Model < Lanes::Model
        self.abstract_class = true

        include Concerns::ActsAsUOM
        include Concerns::StateMachine
        include Concerns::HasSkuLocLines
        include Concerns::HasGlTransaction
        include Concerns::IsOrderLike
        include Concerns::IsSkuLocLine
        include Concerns::ImmutableModel
        include Concerns::VisibleIdIdentifier
        include Concerns::LockedFields
        include Concerns::CodeIdentifier
        include Concerns::RandomHashCode
    end

end
