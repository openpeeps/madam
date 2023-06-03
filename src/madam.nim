import kapsis
import ./commands/[initCommand, runCommand, buildCommand]

App:
  commands:
    $ "init":
      ? "Create a new project"
    $ "run":
      ? "Run madam for current project"