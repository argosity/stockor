module StockorSaas

    module Asset

        def self.getter
            root = Lanes::Extensions.controlling
                       .root_path.join('public', 'files')
            lambda do
                send_file(
                    root.join(
                        Apartment::Tenant.current,
                        params['splat'].first
                    ).to_s
                )
            end
        end

    end
end
