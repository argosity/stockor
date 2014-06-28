Skr.Extensions = {

    instances: []

    register: (identifier,klass)->
        extension = Skr.getObjectByName(klass,'Skr.Extension')
        if ! extension
            Skr.warn("Attempted to create extension #{klass} but couldn't find object.")
            return false
        this.instances[identifier] = new extension

    fireOnBootEvent: (event)->
        instance[event]?() for identifier, instance of @instances

    fireOnAvailable: (application)->
        instance.onAvailable(application) for identifier, instance of @instances

    setBootstrapData: (bootstrap_data)->
        for identifier,data of bootstrap_data
            instance.setBootstrapData(data) if instance = this.instances[identifier]

}