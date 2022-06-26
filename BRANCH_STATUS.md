# PLAN

We wait with apertium-anaphora for now. What we want is to put the
governed @subj – which is typically the *nearest* – into <clip
side="ref"> for transfer to use. It's syntactic, not anaphoric.
- See `synref.t1x` which stores `cur_subj` and places it on `pasv`
  in the ref field (as well as remove syntactic function tags so tNx
  doesn't have to deal with them – using syntax tags in transfer will
  have to be a later extension)

We should use the subj→ref method for participles as well as passives.
Currently we "disambiguate" participles based on preceding subject,
but that fails when subject changes gender in bidix, since we
disambiguate based on nob gender. OTOH it's the tl subject that gets
stored in the ref field, which will have the right gender.


## Main work remaining:

- lrx needs to deal with @-tags (typically does, but some rules might
  end in <aa>)

- lsx needs to deal with @-tags
  - Explicit <s n="aa"/><d/> in lsx needs to be turned into <par n="d"/>
    (or <par n="d:"/>) which can skip the function tags; try
    `xmllint --xpath '//l/s[@n="aa"]/../../l/d/../..' apertium-nno-nob.nob-nno.lsx`

- Syntax CG removes readings that disam doesn't – sometimes the wrong ones!

- A million regressions, most seem to be rlx or lsx?
