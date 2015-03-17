#!/usr/bin/perl

$file = "M/texfiles/letter_m1.tex";
$outfile = "M/texfiles/letter_m.tex";

open(IN, "$file") or die "can't open $file";
open(OUT, ">$outfile") or die "can't open $outfile";

$line = <IN>;
$mflag = 0;
$mng = "";

while($line)
{
	chop($line);
	
	if($line =~ /\\bentry/)
	{
		$mflag = 0;
		print OUT $line . "\n";
	}
	elsif($line =~ /\\eentry/)
	{
		$mng = $mng . " " . $line;
		replace_all($mng);
		$mng = "";
		$mflag = 0;
	}
	elsif($line =~ /^\\addanothertarget/)
	{
		print OUT $line . "\n";
	}
	elsif($line =~ /^\\word/)
	{
		print OUT $line . "\n";
	}
	elsif($line =~ /^\\pron/)
	{
		print OUT $line . "\n";
	}
	elsif($line =~ /^\\gl/)
	{
		$line =~ s/\\gl\{(.*?)\} (.*)/\\gl{\1}\n\\expl{\2}/;
		print OUT $line . "\n";
	}
	elsif($line =~ /^\s*$/)
	{
		if($mflag)
		{
			$mng = $mng . " " . $line;
		}
		else
		{
			print OUT $line . "\n";
		}
	}
	elsif($line =~ /\\dictmeaning/)
	{
		$mflag = 1;
		$mng =  $mng . " " . $line;
	}
	elsif($line =~ /\\noindent/)
	{
		replace_all($mng);
		$mng = "";
		$mflag = 0;
		print OUT "\n" . $line . "\n";
	}
	else
	{
		if($mflag)
		{
			$mng =  $mng . " " . $line;
		}
		else
		{
			print OUT $line;
		}
	}
	
	
	
	$line = <IN>;
}

close(IN);

sub replace_all()
{
	my($meaning) = @_;
	my(@list,$i,$j,$k,$num,$alnum);
	
	$num = 0;
	$alnum = 0;
	
	$meaning =~ s/^ //;
	$meaning =~ s/\\hyperdef/!!!\\hyperdef/g;
	$meaning =~ s/\\hypertarget/!!!\\hypertarget/g;
	$meaning =~ s/\\num/!!!\\num/g;
	$meaning =~ s/\\alnum/!!!\\alnum/g;
	$meaning =~ s/^\{\\dictmeaning\{(.*)\}\}\s*/\\bmng!!!\1 !!!\\emng!!!/g;
	$meaning =~ s/^\\dictmeaning\{(.*)\}\s*/\\bmng!!!\1 !!!\\emng!!!/g;
	$meaning =~ s/\!\!\! \!\!\!/!!!/g;
	$meaning =~ s/[\s]+/ /g;
	#~ $meaning =~ s/\\num\{1\}/\\bnum!!!\\num\{1\}/g;
	#~ $meaning =~ s/\\alnum\{a\}/\\banum!!!\\alnum\{a\}/g;
	#  $meaning =~ s/!!!/\n/g;
	
	@list = split(/!!!/,$meaning);
	
	for($j=0;$j<@list;$j++)
	{
		if($list[$j] =~ /\\alnum\{a\}/)
		{
			for($k = $j-1;$k>=0; $k--)
			{
				if($list[$k] =~ /\\num/)
				{
					$list[$k] =~ s/\\num\{/\\numi\{/;
					last;
				}
			}
			#$list[$j-1] =~ s/\\num\{/\\numi\{/;
		}
	}
	
	for($i=0;$i<@list;$i++)
	{
		if($list[$i] =~ /\\num/) 
		{
			$num++;
			if($num == 1)
			{
				print OUT '\bnum' . "\n" . $list[$i] . "\n";
			}
			else
			{
				if($alnum > 0)
				{
					print OUT '\eanum' . "\n" . "\\numie\n";
					$alnum = 0;
				}				
				print OUT $list[$i] . "\n";
			}
		}
		elsif($list[$i] =~ /\\alnum/) 
		{
			$alnum++;
			if($alnum == 1)
			{
				print OUT '\banum' . "\n" . $list[$i] . "\n";
			}
			else
			{
				print OUT $list[$i] . "\n";
			}
		}
		elsif($list[$i] =~ /\\hyperdef/)
		{
			print OUT $list[$i] . "\n";
		}
		elsif($list[$i] =~ /\\hypertarget/)
		{
			print OUT $list[$i] . "\n";
		}
		elsif($list[$i] =~ /^\s*$/)
		{
			
		}
		else
		{
			if($alnum > 0)
			{
				print OUT '\eanum' . "\n"; 
				if($num > 0)
				{
					print OUT '\numie' . "\n";
				}
				$alnum = 0;
			}
			if($num > 0)
			{
				print OUT '\enum' . "\n"; 
				$num = 0;
			}
		
			print OUT $list[$i] . "\n";
		}		
	} 	

#print OUT $meaning;

}
