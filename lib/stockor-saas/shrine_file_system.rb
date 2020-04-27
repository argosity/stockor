module StockorSaas

    class ShrineFileSystem < Shrine::Storage::FileSystem

        ROOT = Lanes::Extensions.controlling.root_path.join('public/files')

        def directory
            @directory.join(Apartment::Tenant.current)
        end

    end

end
