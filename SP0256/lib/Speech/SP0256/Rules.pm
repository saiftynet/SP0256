package Speech::SP0256::Rules;

sub setRules{
	my ($self)=@_;
	$self->{rules}=[
	   ["dge\$", "JH"    ],
	   ["le\$" ,  "EL"   ],
	   ["^i\$" , "AY"    ],
	   ["^un"  , "AA NN" ],
       ["ght"  , "TT1"   ],
	   ["age"  ,  "EY JH"],
	   ["ck"   ,  "KK"   ],
	   ["ch"   , "CH"    ],
	   ["ng"   ,  "NG"   ],
	   ["ea"   ,  "Ih IH"],
	   ["^d"   ,  "DD2"  ],
	   
	   # for those that don't fit, the remaining letters are
	   # directly translated
	   [ "a","EH"],
		["b","BB1"],
		["c","KK1"],
		["d","DD1"],
		["e","EH"],
		["f","FF"],
		["g","GG1"],
		["h","HH1"],
		["i","IH"],
		["j","JH"],
		["k"," KK1 "],
		["l","LL"],
		["m","MM"],
		["n","NN1"],
		["o","OW"],
		["p","PP"],
		["q","KK2"],
		["r","RR1"],
		["s","SS"],
		["t","TT1"],
		["u","UW1"],
		["v","VV"],
		["w","WW"],
		["x","KK2 SS"],
		["y","IH"],
		["z","ZZ"],
	 ]
	   
	   
}

sub addRule{
	my ($self,$match,$result)=@_;
	$self->{rules}=[sort ruleSort([$match,$result],@{$self->{rules}})];
}

sub ruleSort{
	if (length $a->[0] > length $b->[0]) {return -1}
	elsif (length $a->[0] == length $b->[0]){return 0}
	else  {return 1}	
}


1;
