import kapsis/[runtime, cli]
import ../madam/configurator
from strutils import `%`

proc runCommand*(v: Values) =
    ## Command for generating a `madam.yml` configuration file
    display("Generate a Madam Server Configuration", indent=2)
    # let Config = Configurator.init()
    # let (source_path, public_path) = Config.instance.getAssetsPath()
