def source
    src = super
    super src + erb(:github_link)
end
