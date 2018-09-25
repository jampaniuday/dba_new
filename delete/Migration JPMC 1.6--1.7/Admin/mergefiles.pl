#################################
#Replace strings
sub replace_vars {
my $line=$_;
	$line=~ s/\^sol/JPMC/g;
	$line=~ s/\^conf/jpmc/g;
	$line=~ s/\^pkg./jpmc/g;
	$line=~ s/\^notif_mail/jpmc.qa.notis\@traiana.com/g;
	$line=~ s/\^flat_doc/FlatJPMC/g;
	$line=~ s/\^flat_multi_doc/FlatMultiJPMC/g;
	$line=~ s/\^domain_id/1000000/g;
	$line=~ s/\^PartnerID/'1000000'/g;
	$line=~ s/COMMIT;//g;
	$line=~ s/commit;//g;
	$line=~ s/^\s+//g;	
	return $line; 
}


# Define Variables:
    $currentTable,
    $scriptFile = "insert_pure.sql",
    $filesList="list",
    $currentFile,
    $dir,
    $devDir="D:\\dvlpPr2800\\db\\dev\\",
    $solutionDir="D:\\solutions1700\\jpmc\\db\\dev\\",
    $sqlfile="\\data.sql";
#################################
#Begin main
#
	# Create the merged file, and open the list of files to merge. 
	open FILELIST,   "<$filesList"  or die ("Cann't open file: $filesList");
	open SCRIPTFILE, ">$scriptFile" or die ("Cann't open file: $fileList");
	#for every file in the list
	while (<FILELIST>) { 
		$currentFile = $_ ;
		chop $currentFile ;
		if (open CURRENTFILE, "<$currentFile")  {
			#Note the file name at the merged file 
			print SCRIPTFILE "\nREM -----------------------------------\nREM Source File: $currentFile \n";
			#Read&write every line until EOF
			while (<CURRENTFILE>) {
				replace_vars $_ ;
				if ("$_" ne "\n") {
					print SCRIPTFILE replace_vars $_ ;
				}	
			}
			close CURRENTFILE ;
		} else {
			 print "Failed to open file : $currentFile \n";
		}
	}
	#Close open files... 
	close FILELIST;
	close SCRIPTFILE;

