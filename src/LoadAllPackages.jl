module LoadAllPackages

using Base: PkgId, UUID
using Pkg: TOML

function as_project_file(project)
    isfile(project) && return project
    isdir(project) || error("`$project` is not a file or directory")
    candidates = joinpath.(project, ("JuliaProject.toml", "Project.toml"))
    i = findfirst(isfile, candidates)
    if i === nothing
        error("`$project` does not have `JuliaProject.toml` or `Project.toml`")
    end
    return candidates[i]
end

"""
    LoadAllPackages.loadall(project = Base.active_project())

Load all packages in `project`.
"""
function loadall(project = Base.active_project())
    @info "Loading packages from `$project`..."
    project = as_project_file(project)
    deps = get(TOML.parsefile(project), "deps", nothing)
    deps === nothing && return
    @info "Loading $(length(deps)) packages..."
    t0 = time_ns()
    for (name, uuid) in deps
        pkg = PkgId(UUID(uuid), name)
        @debug "Loading `$pkg`..."
        Base.require(pkg)
        @debug "`$pkg` loaded."
    end
    sec = (time_ns() - t0) / 10^9
    @info "$(length(deps)) packages loaded in $sec seconds"
    return
end

_loadall(cwd, path) = loadall(joinpath(cwd, path))

"""
    LoadAllPackages.@loadall(project)

Load all packages in `project`.  If `project` is a relative path,
interpret it as the relative path from `@__DIR__` rather than `pwd()`.
"""
macro loadall(project)
    :(_loadall($Base.@__DIR__, $(esc(project))))
end

end
