# When using this for a sys-prepped image, follow the instructions at 
# https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-using-a-configuration-file?view=sql-server-ver15#how-to-use-a-configuration-file-to-prepare-and-complete-an-image-of-a-stand-alone--instance-sysprep

$url = "https://go.microsoft.com/fwlink/?linkid=866658"
$output = ".\sqlexpress-installer.exe"

Invoke-WebRequest $url -OutFile $output

# Follow the instructions at https://docs.microsoft.com/sql/database-engine/install-windows/install-sql-server-using-a-configuration-file?view=sql-server-ver15
# to create a proper configuration file for your environment if the one provided is missing features.
# Look for the paragraph that explains how to use /UIMODE=Normal /ACTION=INSTALL to create the .INI file.
. $output /QUIET /IACCEPTSQLSERVERLICENSETERMS /CONFIGURATIONFILE=c:\scripts\sql-express-install-config.ini 