echo Adicionando "pt_BR" a lista de locales.
xmlstarlet ed -s "/resources/string-array[@name='supported_locale']" -t elem -n "item" -v "pt_BR" $PATHP/unpacked/system/framework/framework-miui-res.apk/res/values/arrays.xml
