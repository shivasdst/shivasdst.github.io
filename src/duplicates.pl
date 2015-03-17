#!/usr/bin/perl

$hashfile = "X/texfiles/dictionarywords.tex";
@list = ();
%mainhash = ();

manage_duplicates();

sub manage_duplicates()
{
	my($label,$dupline,$id,$prevocc,$wl,$occ,$linecopy,$item);
	
	open(HASH, "$hashfile") or die("can't open $hashfile\n");

	$label = "xid";

	$dupline = <HASH>;
	$id = 1;

	$prevocc = 0;

	while($dupline)
	{
		chop($dupline);
		
		#print $line . "->xid" . $id . "\n";
		
		if($dupline =~ /(.*)\(([0-9]+)\)/)
		{
			$wl = $1;
			$occ = $2;
			
			if( ($prevocc == 0) || ($occ == ($prevocc + 1)) )
			{
				$linecopy = $dupline;
				$linecopy =~ s/"//g;
				$linecopy =~ s/,//g;
				$item = $label . $id . ";" . $linecopy;
				push(@list,$item);
		
				$prevocc = $occ;	
			}
			else
			{
				create_hash();
				$prevocc = 0;
				@list = ();
				$linecopy = $dupline;
				$linecopy =~ s/"//g;
				$linecopy =~ s/,//g;
				$item = $label . $id . ";" . $linecopy;
				push(@list,$item);
		
				$prevocc = $occ;			
			}
		}
		else
		{
			if(@list > 0)
			{
				create_hash();			
			}
			$prevocc = 0;
			@list = ();	
		}
		
		$dupline = <HASH>;
		$id++;
	}

	close(HASH);
}


sub create_hash()
{
	my($l,$tmpword,$hashid,$m,$seealso_data,$nextid,$nextword);
	
	for($l=0;$l<@list;$l++)
	{
		#print $list[$l] . "\n";			
		($hashid,$tmpword) = split(/;/,$list[$l]);
		$mainhash{$hashid} = "";
		
		for($m=0;$m<@list;$m++)
		{
			if($m != $l)
			{
				($nextid,$nextword) = split(/;/,$list[$m]);
				$nextword =~ s/(.*)\(([0-9]+)\)/\${}^\2\$\1/;
				$mainhash{$hashid} = $mainhash{$hashid} . "<span class=\"seealso\"><a href=\"#". $nextid . "\">". $nextword ."</a></span>&nbsp;&nbsp;";
			}
		}
		$mainhash{$hashid} =~ s/&nbsp;&nbsp;$//g;
		print $hashid . "-->" . $mainhash{$hashid} . "\n";
	}	
	
	print "\n\n";
}
