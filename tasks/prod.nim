import ./utils

task prod, "Compile Madam for production":
    echo "\n✨ Compiling Madam " & $version & " for " & getCurrentOS() & "\n"
    exec "nimble build --gc:arc -d:release -d:useMalloc --opt:size --spellSuggest"