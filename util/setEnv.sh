WORKINGDIR="$pwd/web-scraper"
UTIL_DIR="$WORKINGDIR/util"
SILENT=true
FILE_TYPE="*.exe;*.zip;*.gz;*.deb;*.sh;*.rpm;*.tar.gz;*.tar;*.php;*.py"

export pwd=`pwd`
export PATH=$WORKINGDIR:$UTIL_DIR:$PATH
export SILENT=$SILENT
export FILE_TYPE=$FILE_TYPE