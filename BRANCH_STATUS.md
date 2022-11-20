# PLAN

This branch changes the pipeline to insert the syntax CG right after
disam and capstag (before tagger), which gives us syntax @-tags on all
lexical units. Then, after bidix and lexical selection, the new step
refsyn.t1x removes the @-tags, but also attends to the last seen @subj
and puts it in the ref-field (of the following words). Then t1x reads
the ref-field and uses that to compute the gender/number of pp's
created from passives.

- See `refsyn.t1x` which stores `cur_subj` and places it in the ref
  field (as well as remove syntactic function tags so tNx doesn't have
  to deal with them – using syntax tags in transfer will have to be a
  later extension)

We wait with apertium-anaphora for now. What we want is to put the
governed @subj – which is typically the *nearest* – into <clip
side="ref"> for transfer to use. It's syntactic, not anaphoric.

## Pretty much done:

- lrx needs to deal with @-tags (typically does, but some rules might
  end in <aa>)

- lsx needs to deal with @-tags
  - Explicit <s n="aa"/><d/> in lsx needs to be turned into <par n="d"/>
    (or <par n="d:"/>) which can skip the function tags; try
    `xmllint --xpath '//l/s[@n="aa"]/../../l/d/../..' apertium-nno-nob.nob-nno.lsx`

- passive gender/number now uses the `ref` field, via refsyn.t1x

- In some cases, we need to use a subject that's to the right,
  refsyn.t1x needs some rules for that

- Syntax CG now before tagger, using syntax for disambiguation.

- Most lrx/lsx regressions fixed.

## Main work remaining:

- Remaining regressions in passive genders (missing refsyn.t1x
  patterns, bad syntax disambiguation?)

- We should use the subj→ref method for participles as well as
  passives. Currently we "disambiguate" participles based on preceding
  subject, but that fails when subject changes gender in bidix, since
  we disambiguate based on nob gender – while it's the target language
  subject that gets stored in the `ref` field, which *will* have the
  right gender.
