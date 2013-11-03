#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;

require Devel::Quick;

# errors get reported properly
throws_ok
	{ Devel::Quick->import('$x - '); }
	qr/Failed to parse code:.*22:\s+\$x -/ms,
	"Bad code detected and reported"
;

# non-strict is default
lives_ok
	{ Devel::Quick->import('$x = 1'); }
	'Strict is disabled by default'
;

# strict is enabled when asked for by long form
throws_ok
	{ Devel::Quick->import('-strict', '$x = 1') }
	qr/Failed to parse code: Global symbol \"\$x\" requires explicit/,
	"Strict is enabled by -strict"
;

# strict is enabled when asked for by short form
throws_ok
	{ Devel::Quick->import('-s', '$x = 1') }
	qr/Failed to parse code: Global symbol \"\$x\" requires explicit/,
	"Strict is enabled by -s"
;

# strict doesn't prevent code from working
lives_ok
	{ Devel::Quick->import('-s', 'my $x = 1'); }
	'Strict code works'
;

# Bad switch
throws_ok
	{ Devel::Quick->import('-r', '$x = 1') }
	qr/Unknown switch '-r'/,
	"Bad switches are detected"
;

# Can still use '-' as first char in code
lives_ok
	{ Devel::Quick->import('; $x = 1') }
	'Switch processing bypassed by \';\' as first character'
;

done_testing;
