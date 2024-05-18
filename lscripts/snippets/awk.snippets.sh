
## This command will print the label count, unique labels count, and total files count, all with tab-separated columns.
awk -F'\t' 'NR>1{labels[$2]++; total_files++} END {print "Label\tCount"; for (label in labels) print label "\t" labels[label]; print "\nUnique labels:", length(labels), "\nTotal files:", total_files}' $1
