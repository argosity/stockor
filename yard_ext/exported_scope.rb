class ExportedScopeHandler < YARD::Handlers::Ruby::ActiveRecord::Scopes::ScopeHandler
    handles method_call(:export_scope)
    namespace_only
end
