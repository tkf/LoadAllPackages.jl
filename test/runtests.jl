module TestLoadAllPackages

using LoadAllPackages
using Test

@testset """@loadall("../Project.toml")""" begin
    @test_logs(
        (:info, r"Loading packages from .*"),
        (:info, r"packages loaded in .* seconds"),
        match_mode = :any,
        LoadAllPackages.@loadall("../Project.toml")
    )
end

@testset """@loadall("..")""" begin
    @test_logs(
        (:info, r"Loading packages from .*"),
        (:info, r"packages loaded in .* seconds"),
        match_mode = :any,
        LoadAllPackages.@loadall("..")
    )
end

@testset "error handling" begin
    mktempdir() do emptydir
        @test_throws(
            ErrorException("`$emptydir` does not have `JuliaProject.toml` or `Project.toml`"),
            LoadAllPackages.@loadall(emptydir)
        )

        nonexisting = joinpath(emptydir, "nonexisting")
        @test_throws(
            ErrorException("`$nonexisting` is not a file or directory"),
            LoadAllPackages.@loadall(nonexisting)
        )
    end
end

end  # module
