########################################################
########################################################
################### DEFINE WORKING PATH ################
########################################################

export YEAR=2006
export THRESHOLD=2006
export WORKING_PATH="/Users/Thomas/Downloads/Stata_translate"
export FILENAME=$WORKING_PATH/data_$YEAR.rar
export EXTRACT_FOLDER="data_$YEAR"

export PATH=$PATH:/Applications/Stata/StataMP.app/Contents/MacOS 
echo "Working directory is $WORKING_PATH"
echo "Path for the filename is $FILENAME"
echo "Extracted files are in $EXTRACT_FOLDER"

########################################################
########################################################
################### Proceed translation ################
########################################################

echo "Proceeding to YEAR=$YEAR..."
if [ $YEAR -gt $THRESHOLD ]
then
	export TRANSLATEFOLDER=$WORKING_PATH/sup_2007
	cd $WORKING_PATH
	echo "Extract rar"
	open $FILENAME &&
	sleep 300 &&
	mv $EXTRACT_FOLDER/*.dta $WORKING_PATH &&
	rmdir $EXTRACT_FOLDER &&
	echo "Next step: Creating intermediate files" &&
	stata-mp -e do sup_2007/02_create_int_files &&
	rm temp.dta &&
	bash 04_move_to_translate.sh && 
	echo "Translation done, moving to dataset prepation" &&
	find . -name "*.dta" -size -20k -delete &&
	stata-mp -e do sup_2007/05_change_var_name &&
	echo "Done preparing the file. Move to Python" &&
	rm *.log &&
	rm $FILENAME
else
	export TRANSLATEFOLDER=$WORKING_PATH/inf_2007
	cd $WORKING_PATH
	echo "Extract rar"
	open $FILENAME &&
	sleep 300 && 
	echo "Next step: Creating intermediate files" &&
	stata-mp -e inf_2007/02_create_int_files.do &&
	rm temp.dta &&
	bash 04_move_to_translate.sh &&
	echo "Translation done, moving to dataset prepation" &&
	stata-mp -e do inf_2007/05_keep_var &&
	echo "Done preparing the file. Move to Python" &&
	rm *.log &&
	rm $FILENAME
fi

