package main;
use strict; use warnings;
unless (caller){
	
	my $chip=Speech::SP0256->new();
	my $a=scalar keys %{$chip->{dic}};
	my $r=@{$chip->{rules}};
	print "\n\n  ******  Speech Using Pure Perl Emulating a Retro SP0256   *****\n",
	      "  *                  Version 0.01                               *\n",
	      "  *       Allophones available:                                 *\n",
	      "  *  @{$chip->{items}}[0..15]   *\n",
	      "  *  @{$chip->{items}}[16..31]    *\n",
	      "  *  @{$chip->{items}}[32..47]      *\n",
	      "  *  @{$chip->{items}}[47..63] *\n",   
	      "  *       Words available $a   Rules Available  $r              *\n",
	      "  ***************************************************************\n\n",
	      "   Enter words to speak;\n   Allophones may be passed as /XX/ e.g. /PP/ /ER1/ /LL/:\n\n" ;

	$chip->speak("hello");
	print "\n";
	my $input="";
	while ($input ne "q"){
		$input=<STDIN>;
		chomp $input;
		$chip->speak($input);
		print "\n";
	}
};

package Speech::SP0256;
use strict; use warnings;
use lib "../../lib";
our $VERSION=0.03;
use Speech::SP0256::Allophone;
use Speech::SP0256::Dictionary;
use Speech::SP0256::Rules;
use Storable;
use if $^O eq 'MSWin32', "Win32::Sound";

our $dsp;

sub start{
	my $self=shift;
	if ($^O eq 'MSWin32'){
	   our $dsp = new Win32::Sound::WaveOut(8000, 8, 1);
	} 
	else{
	   open(our $dsp,"|padsp tee /dev/dsp > /dev/null") or warn "DSP can not be intiated $!";
    }	   
}

sub new{
	my $class=shift;	
	our $dsp;
	my $self=Speech::SP0256::Allophone->build();
	Speech::SP0256::Dictionary::initDic($self);
	Speech::SP0256::Rules::setRules($self);
	bless $self, $class;
	return $self;

}

sub debug{
	my ($self, $debug)=@_;
	$self->{debug}=$debug?1:0;
}

sub utter{
	my ($self,$ap)=@_;
	my @sounds=split(/[^a-zA-Z0-9]+/,uc $ap);
	unless ($dsp){
		$self->start();; 
	}
	foreach my $sound(@sounds){
		print $sound," " if $self->{debug};
		next unless $self->{allophones}->{$sound};  # ignore sounds that are not available
		my $b=$self->{allophones}->{$sound}->{s};
		if ($^O eq 'MSWin32'){
		   $dsp->Load($b);       # get it
		   $dsp->Write();           # hear it
	    } 
		else{
	       while (length $b){$b=substr $b,syswrite $dsp,$b};
        }
		
	}
#	print "\n";
}

sub speak{
	my ($self,$text)=@_;
	my $build="";my $nextChar="";
	while (length $text){
		$nextChar=substr $text, 0, 1, "";
		if ($nextChar=~/[ \.,;\-:?]/){
            $self->utter($self->tts($build) ." ".$self->tts($nextChar));
            $build="";
		}
		else{
			$build.=$nextChar;
		}
	}
	$self->utter($self->tts($build));
}

sub tts{
	my ($self,$word)=@_;
	if ($word=~/\/([A-Z]{2}\d?)\//){return $1};    # Direct Allophone output
	my $result=lc $word;             
	if (defined $self->{dic}->{$result}){          # Word is in dictionary
		$result= $self->{dic}->{$result} 
	}
	elsif($word=~/^\d+$/){
		$result=$self->numberSpeak($word); 
	}
	else{
		foreach my $rule (@{$self->{rules}}){      # Build word from set of rules
			my ($match,$replace)=@$rule;
			if ($result=~/$match/){
				$result=~s/$match/ $replace /g;	
				#print "Match $match found, replaced with $replace \n";
			}	
		}
		$result=~s/\s+/ /g;
	}
	print "Word found $word ; output is $result\n" if $self->{debug};
	return $result;
}

sub numberSpeak{
	my ($self,$number)=@_;
	my $split=numberSplit(1*$number);
	print $split,"\n" if $self->{debug};
	my $inWords="";
	foreach (split " ",$split){
		$inWords.=$self->tts($_);
		$inWords.=" PA4 "
	}
	return $inWords;
	
}

sub numberSplit{
	my $number=shift;
	return "0" if ($number== 0);
    if ($number < 0){ return "minus " . numberSplit(-$number)};
    if ($number >= 1000000000){ return numberSplit(int($number / 1000000000)) . " 1000000000 " . numberSplit($number % 1000000000)};
    if ($number >= 1000000){ return numberSplit(int($number / 1000000)) . " 1000000 " . numberSplit($number % 1000000)};
    if ($number >= 1000){ return numberSplit(int($number / 1000)) . " 1000 " . numberSplit($number % 1000)};
    if ($number >= 100){ return numberSplit(int($number / 100)) . " 100 " . numberSplit($number % 100)};
    if ($number >= 20){ return (10*int($number/10))." ".($number%10) };
    return $number if $number;
    return "";
}




1;
