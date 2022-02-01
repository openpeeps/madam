import ./utils

task dev, "Compile Madam for development purposes":
    echo "\n✨ Compiling Madam " & $version & " for " & getCurrentOS() & "\n"
    exec "nimble build --gc:arc -d:useMalloc"