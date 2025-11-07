fileexist -path $BOOTPATH/language/$LANG/addin_cfgtext.xml -label INSTALL_FILE
goto -label END
#INSTALL_FILE
echo -text "Installing addin_cfgtext.xml for $LANG"
text -filename $BOOTPATH/language/$LANG/addin_cfgtext.xml -package $LANG
#END
