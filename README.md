Tools for trivially transforming tricky Erlang terms.

Scope
=====

This library solves two problems in Erlang:

* Boilerplate pattern matching purely for the purpose of traversal.
* Writing new tree traversal utility functions every time that gets old.

These problems show up in anything that builds an Abstract Syntax tree out of
Erlang terms, such as:

* Compilers and interpreters.
* Large, complex configurations.
* Complex process states.

The library isn't meant for mucking with the following:

* Opaque data types. I shouldn't have to explain why. Don't do it.
* Things that aren't tagged tuples or lists. Wrap them in atom-tagged tuples!

Inspiration
===========

Generic programming is about writing code that doesn't really care what
underlying data structure are used. It reduces coupling on internal data,
increasing flexibility and robustness to change.

The following Haskell libraries were inspiring:

* 'SYB' (Scrap Your Boilerplate )
* 'Uniplate'
* 'Traversal.hs' by Sebastian Fischer

Examples
========

Extracting errors from trace.

Extracting specific calls from stack traces.

Optimizations on AST.

Editing large configurations.


API
===

Generic operates on tagged tuples (tuples where the first element is an atom).

It does not modify or return 0th order types like integers and binaries: if you
want to do generic operations on them, they should be wrapped with tagged tuples.

It does traverse into lists.

Viewers
-------

```erlang
% use with partial list comprehensions: 
%   [E||{error,E}<-generic:family(Msg)].
-spec children(term()) -> [term()]. % first level children
-spec family(term()) -> [term()]. % parent, its children, their children, etc
% use with partial functions:
%   generic:family(fun({local,S})->S; {global,S}->S end, Code).
-spec children(fun(A)->B, term()) -> [B].
-spec family(fun(A)->B, term()) -> [B].
```

Transformers
------------

```erlang
% use partial function to replace matching terms in entire tree, bottom-up
-spec transform(fun(A)->B, term()) -> term().
% like transform, but applies functions to replacements until a fixed point is
% reached
-spec rewrite(fun(A)->{ok,term()}|done, term()) -> term().
% stateful variants:
-spec transform(fun(A,St)->{ok,term,St}|{done,St}, St, term()) -> {term,St}.
-spec rewrite(fun(A,St)->{ok,term,St}|{done,St}, St, term()) -> {term,St}.
```

Others
------

Paramorphisms. Folds are needed.

Contexts/holes, like transform but passing the parent node as well? 


Installing
==========

Add to {deps,[...]} in rebar.config, if using rebar:

```erlang
{generic, "v0.0.0", {git,"git://github.com/amtal/generic.git",{tag,"v0.0.0"}}},
{lfe_utils, ".*", {git,"git://github.com/amtal/lfe_utils.git",{tag,"v1.2.3"}}},
{lfe, "0.6.2", {git,"git://github.com/rvirding/lfe",{tag,"v0.6.2"}}}
```
