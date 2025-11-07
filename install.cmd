# ---------------------------------------------------------------------------
# ABB RobotWare add-in skeleton installer
# ---------------------------------------------------------------------------
echo -text "YOUR_ADDIN_NAME skeleton install started"

# Keep boot path but allow RobotWare to inject language package
setstr -strvar $TMP_ADDIN -value $BOOTPATH
include -path "$RELEASE/system/instlang.cmd"
setstr -strvar $BOOTPATH -value "$TMP_ADDIN"

# Publish a short alias so cfg files can reference ADDIN:/Code/...
setenv -Name "YOUR_ADDIN_NAME" -value $BOOTPATH

# ---------------------------------------------------------------------------
# Optional registrations
# ---------------------------------------------------------------------------
register -type cfgtext  -domain PROC -prepath $BOOTPATH/language/ -postpath /addin_cfgtext.xml
register -type cfgrules -domain PROC -prepath $BOOTPATH/rules/    -postpath addin_cfgrules.xml
invoke -entry cfg_create_proc_types_from_xml_def -strarg "addin_cfgrules" -nomode

# ---------------------------------------------------------------------------
# Load configuration snippets. Replace/extend with your own domains.
# ---------------------------------------------------------------------------
config -filename $BOOTPATH/config/EIO/eioSkeleton.cfg   -domain EIO  -replace
config -filename $BOOTPATH/config/PROC/procSkeleton.cfg  -domain PROC -replace
config -filename $BOOTPATH/config/SYS/sysSkeleton.cfg    -domain SYS  -replace -internal
config -filename $BOOTPATH/config/MMC/mmcSkeleton.cfg    -domain MMC  -replace -internal

# ---------------------------------------------------------------------------
# Optional user interaction
# ---------------------------------------------------------------------------
echo -text "Optional: install demo RAPID/sample configuration?"
echo -text " 1 = Install demo assets (default)"
echo -text " 2 = Skip demo assets"
getkey -id "YOUR_ADDIN_NAME_DEMO_CHOICE" -var 1 -strvar $ANSWER -errlabel OPTIONAL_INVALID
goto -strvar $ANSWER

#1
echo -text "Installing YOUR_ADDIN_NAME demo RAPID modules and sample cfg."
#  Example: copy files, enable extra config blocks, etc.
goto -label OPTIONAL_DONE

#2
echo -text "Skipping demo assets."
goto -label OPTIONAL_DONE

#OPTIONAL_INVALID
echo -text "Invalid selection. Defaulting to option 1."
goto -label 1

#OPTIONAL_DONE

echo -text "YOUR_ADDIN_NAME skeleton install complete"

#END_LABEL
