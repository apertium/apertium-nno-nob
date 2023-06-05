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

- Use the subj→ref method for participles as well as passives. The old
  method was to "disambiguate" participles based on preceding subject,
  but that fails when subject changes gender in bidix, since we
  disambiguate based on nob gender. OTOH it's the target language
  subject that gets stored in the `ref` field, which *will* have the
  right gender. T1X now uses the `ref` field if it's set, falling back
  to the input gender/number (given by the old method) if unset.

- Subjects of relative clauses and subclauses tagged as @xubj
  - de<pl><@subj> nevner mannen<mf><@xubj> i 50-åra som …
  - et antall<sg><@subj> av deres krigere<pl><@xubj> …

- Regular (non-pp) adjectives
  - restricted to the cases where the subject is plural, or it changes
    in translation between nt and non-nt genders

## Main work remaining:

- Remaining regressions in passive genders (missing refsyn.t1x
  patterns, bad syntax disambiguation?)

- Sometimes the subject is a whole clause – should give nt:
  - [At disse<pl> ble solgt] er fint<nt!>
  May require "outer" ref, flip on clause boundary.
  But we can't always trust that som+comma ends the clause:
  - Han stadfestar at<nt> alle tenestemennene<pl> som avfyrte skot, no
    er avhøyrde<pl>

- Coordination should give plural
  - To politivakter og en vakt fra et privat vaktselskap ble drept<pl!>
  But sometimes hard to know if it's the same person (sg) or different (pl):
  - Programleder og tidligere gjengleder skutt og drept i København.

- Missing relative pronouns are difficult:
  - Jeg er her på grunn av beslutninger<pl> tatt<pl> på europeiske møter
  - Brasil<nt> er hardt truffet med vel 55.000 dødsfall<pl> relatert<pl> til pandemien
  Difficult, since e.g.: ble det ved flere anledninger<pl> tatt<nt> opp i Stortinget
  - Maybe we can use ngram frequencies f(ta beslutninger) >>> f(ta anledninger)

- adj.sg.nt.@adv should be adv_movable
  - domineres sterkt → er sterkt dominert

- Crossing subject are difficult:

  1. Samtidig skal vi ha respekt for den politiske plattformen<xubj> som de fire partiene<subj> fremforhandlet på Granavollen, og som ble godkjent<plattform> av partienes organer
  2. Antallet<subj> mennesker<xubj> som døde<menneske> i etterkant, var kraftig underrapportert<antall>.

  We could use commas as a signal to switch to a previous subject, which would fix the above, but
  but commas after "non-optional" relatives should *not* lead to a switch:

  3. Han<subj> opplyser at alle flyvinger<xubj> som var planlagt<flyvning> tirsdag, er innstilt<flyvning>.
  4. Regjeringa<subj> stadfestar no at lisenskontoret<subj> i Mo i Rana, som har<lisenskontoret> 106 arbeidsplassar, legges<lisenskontoret> ned.
  5. Tidligere i februar ble det<subj> kjent at seks politifolk<xubj> som jobbet for å avdekke narkotikakriminalitet, var pågrepet<folk> for selv å ha smuglet narkotika.

  (Though in those cases, we have «at.cnjcoo.clb» on which to empty prev-subj.)
  But it's hard to consistently tag these commas as clb; e.g. below we
  have an "optional" relative sentence where we do want to switch subjects
  on the comma:

  6. Den ene såkalte svarte boksen<subj> fra flyet<xubj> som styrtet<fly> i Etiopia, er funnet<boks>, melder etiopiske medier.

  (Note: In example 1. we have xubj-subj-ref:subj-ref:xubj, whereas
  in 6. we have subj-xubj-ref:xubj-ref:subj, ie. we can't always
  expect the relative subject to be the inner one.)

  Possible idea: split @clb-tag into clause-with-subject vs clause-without-subject (ellipsis)?

