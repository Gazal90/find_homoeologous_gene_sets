#!usr/bin/perl
#
open(IN,$ARGV[0]); #file with all homoeolog pairs from Biomart
$i=1;		   #counter for key names in hash %homeo_lists            

while(<IN>)
{	$match=0;@temp="";	
	chomp;
	@pair=split("\t",$_); chomp $pair[0]; chomp $pair[1]; #split each line to get pair as array elements
	foreach $key(keys %homeo_lists)			      #check presence of first ID in all key elements; no need to check second ID as same pair will also be present with reversed order
	{	chomp $homeo_lists{$key};	
		if(($homeo_lists{$key} =~ $pair[0]))				#if ID1 is present in a key value; add ID2 to the value, separated by \t
		{	$homeo_lists{$key} = "$homeo_lists{$key}\t$pair[1]";
			push (@temp,$key);					#if added to key value, store key name in @temp (to later process if more than 1 kay has same ID ##will be concatenated into a single kwy later)
			$match++;						#append value if added an ID to key value
		}
	}	if($match==0)							#if ID1 was not present in any keyValue, make a new key and add the ID as value
		{$i++;								#append key name	
			#	print "ldldld\t$i\n";
		 $homeo_lists{$i}="$pair[0]\t$pair[1]";				#add new pair tab separated as value to new key
	 	}
		if($match > 1)							#if ID was added to more than 1 key, create a new key and cat repititious value to it
		{$i++;foreach $t (@temp)
			{$homeo_lists{$i}="$homeo_lists{$i}\t$homeo_lists{$t}";
			delete $homeo_lists{$t};				#delete repetitive ID keys
			}
		}
	
}
foreach $key(keys %homeo_lists)
{	@current_homeos=split("\t",$homeo_lists{$key});
	@current_homeosUNQ = do { %seen; grep { !$seen{$_}++ } @current_homeos };# check each key for repiting IDs and keep only uniques
	#DO: remove space at start of array
	print "@current_homeosUNQ\n";
}
