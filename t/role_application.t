#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 7;

use MooseX::Declare;

role Fooable { has foo => (is => 'ro', default => 1) }
role Barable { has bar => (is => 'ro', default => 1) }

class FooBar1 with (Fooable, Barable) {}

my $foobar1 = FooBar1->new;

is $foobar1->foo, 1;
is $foobar1->bar, 1;

class FooBar2 with Fooable with Barable {}

my $foobar2 = FooBar2->new;

is $foobar2->foo, 1;
is $foobar2->bar, 1;

role RootRole {
    method root {
        return "root";
    };
}

role ChildRole {
    with 'RootRole';
};

class RoleInherit with ChildRole {};

can_ok('RoleInherit', 'root');
is(RoleInherit->new->root, "root", "Methods defined in roles included in another role works");

TODO: {
    local $TODO = 'we need better error messages on parse fail';
    #error message should refer to this file, not an internal file
    #NOTE: string eval is needed because this happens at compile time
    eval "class FooBar with Fooable, Barable {}";
    like $@, qr/999_misc[.]t/;
}

#FIXME: decide on a good error message and check for it here
