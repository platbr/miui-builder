echo Adicionando "pt_BR" a lista de locales.
TMP=/tmp/tmp.$(date +%Y%m%d%H%M%S)
FILE=$PATHB/unpacked/system/framework/framework-miui-res.apk/res/values/arrays.xml
xmlstarlet sel -t -v "/resources/string-array[@name='supported_locale']/item" -m pt_BR $FILE  | grep ^pt_BR$ >/dev/null
if [ $? -ne 0 ]
then
	xmlstarlet ed -s "/resources/string-array[@name='supported_locale']" -t elem -n "item" -v "pt_BR" $FILE > $TMP
	cat $TMP > $FILE
	rm $TMP
else
	echo Ja possui suporte pt_BR...
	
fi
