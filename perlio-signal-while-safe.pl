#!/usr/bin/env perl
use strict;
use warnings;

use POSIX;

pipe(P,C);

if (fork() == 0) {
    close P;
    sleep 2; # write to pipe after timeout
    print C "42\n";
    exit 0;
}

print "parent $$\n";
local $SIG{ALRM} = sub{
    print "timeout\n";
    open my $fh, '<', 'README.md' or die $!;
    while (<$fh>) {}
    close $fh;
};

alarm 1;
close C;

print while <P>;
while (wait() != -1) {}
print "done\n";
