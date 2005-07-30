# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

use Test::More tests => 22;
use Data::Tree;

my $tree = Data::Tree->new(file => 't/test.dat');
ok($tree);
isa_ok($tree, 'Data::Tree');

ok($tree->is_parent('1', '11'));
ok($tree->is_parent('12', '121'));
ok(!$tree->is_parent('121','1'));
ok(!$tree->is_parent('1','121'));

ok($tree->is_child('12', '1'));
ok($tree->is_child('121', '12'));
ok(!$tree->is_child('1', '11'));
ok(!$tree->is_child('121', '1'));

ok($tree->is_ancestor('1', '11'));
ok($tree->is_ancestor('1', '121'));
ok(!$tree->is_ancestor('11', '1'));
ok(!$tree->is_ancestor('11', '121'));

ok($tree->is_descendent('11', '1'));
ok($tree->is_descendent('121', '1'));
ok(!$tree->is_descendent('1', '11'));
ok(!$tree->is_descendent('121', '11'));

my @p = $tree->ancestors('121');
ok(@p == 2);

@p = $tree->ancestors('1');
ok(!@p);

ok($tree->level('121') == 2);
ok($tree->level('1') == 0);
