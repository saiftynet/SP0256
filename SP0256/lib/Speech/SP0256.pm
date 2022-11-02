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
our $VERSION=0.01;
use Speech::SP0256::Allophone;
use Speech::SP0256::Dictionary;
use Speech::SP0256::Rules;
use Storable;

our $dsp;

sub start{
	my $self=shift;
	open(our $dsp,"|padsp tee /dev/dsp > /dev/null") or warn "DSP can not be intiated $!"; 
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

sub utter{
	my ($self,$ap)=@_;
	my @sounds=split(/[^a-zA-Z0-9]+/,uc $ap);
	unless ($dsp){
		$self->start();; 
	}
	foreach my $sound(@sounds){
		print $sound," ";
		next unless $self->{allophones}->{$sound};  # ignore sounds that are not available
		my $b=$self->{allophones}->{$sound}->{s};
		while (length $b){$b=substr $b,syswrite $dsp,$b};
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
	if ($word=~/\/([A-Z]{2}\d?)\//){return $1};
	my $result=lc $word;
	if (defined $self->{dic}->{$result}){
		$result= $self->{dic}->{$result} 
	}
	else{
		foreach my $rule (@{$self->{rules}}){
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





1;
