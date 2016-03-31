#!/usr/bin/perl -w
use strict;
use warnings;
use Net::SMTP;

sub main {
	if ( @ARGV > 1 || @ARGV < 1 ) {
		printf "Usage: ./spam.pl list_of_names.txt";
		return 1;
	}

        open(my $file, "<", $ARGV[0]) 
    		or die "cannot open $ARGV[0]: $!";
	
	my $SMTP = Net::SMTP->new(
                           Host => 'localhost',
                           Hello => 'domain.tld',
                           Timeout => 30,
                           Debug   => 1,
			   );

	my @letters = ( 'a', 'b', 'c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z' );
	my @buff;
	my @buff1;
	my @realAddy;
printf "Reading input.\n"; #DEBUG
	while (<$file>) {
		chop;
		@buff = split(/ /,);
		@buff1 = split(//,$buff[0]);
		my @addresses;
		my $address = "$buff1[0]a$buff[1]\@domain.tld";;
		my $middleNum=0;
printf "Building single email address array.\n"; #DEBUG
		for ( @letters ) {
			#printf "$buff1[0]$_$buff[1]\@domain.tld\n"; 
			$addresses[$middleNum] = "$buff1[0]$_$buff[1]\@domain.tld";
			$middleNum++;
		}
printf "Sending E-Mail message.\n"; #DEBUG
		if ( 1 ) {
			# from
			$SMTP->mail($address);
			#$SMTP->mail($ENV{USER});
    			# to
			if ($SMTP->to($address)) {
printf "Communicating with server.\n"; #DEBUG
				# bcc recipient holder;
		      @realAddy=$SMTP->recipient(@addresses, { Notify => ['FAILURE'], SkipBad => 1 });
				#above array holds real E-Mail entry
     				$SMTP->data();
     				$SMTP->datasend("To: $address\n");
     				$SMTP->datasend("\n");
     				$SMTP->datasend("A simple test message\n");
     				$SMTP->dataend();
    			} else {
     				print "Error: ", $SMTP->message();
    			}
		}
printf "Printing real E-Mail address.\n"; #DEBUG
		for ( @realAddy ) {
			printf "$_\n";
		}
	}
printf "Closing resources.\n"; #DEBUG
	$SMTP->quit;
	close ($file);
	return 0;
}

main();
