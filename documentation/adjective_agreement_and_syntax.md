# Adjective agreement and syntax

In Nynorsk, participles tend to agree (in number and gender) with a
preceding subject, e.g.

* Mannen       er  kjend
  n.sg.m.@subj cop pp.sg.mf

* Personane    er  kjende
  n.m.pl.@subj cop pp.pl

* Huset         er  kjent
  n.sg.nt.@subj cop pp.sg.nt

There is no gender-difference in plural, and we don't differentiate
between masc/fem in participles, so we are left with three cases:

* `sg.m/f`
* `sg.nt`
* `pl`

(The one exception is the (non-participle) adjective "liten", which
has the form "lita" in feminine.)

To complicate matters, the "preceding subject" might be a full clause,
as in
* At folk i 2025 ikkje kan leva av jobbane sine, er uverdig.
* Kva dei skal ha gjort, er ikkje kjent.
where we have to ensure "uverdig" and "kjent" get `sg.nt` and not `pl`
(though there are plural subjects inside the clause).

Or it might be an ellipsed relative clause or subclause, as in
* Gjerde vil minske antall trafikkulykker relatert til rus
where "relatert" should agree with "trafikkulykker" and not "antall"
(the non-ellipsed clause would be "trafikkulykker som er relatert").


## How we find the subject

The CG file `apertium-nob.nob.syn.rlx` in `apertium-nob` runs after CG
disambiguation, and adds the tags `@subj` to possible main subjects,
and `@xubj` to subordinated subjects (e.g. ellipsed relative clauses).

In the example below, we use `nob-nno_e-tagger|cg-conv` to just show
the output of the disambiguated syntax analysis without all the
debug/trace info:

    $ echo Bilen var utstyrt med airbag |apertium -d . nob-nno_e-tagger|cg-conv
    "<Bilen>"
            "bil" n m sg def Aa @subj
    "<var>"
            "være" vblex pret aa @fv
    "<utstyrt>"
            "utstyre" adj pp mf sg ind aa @s-pred
    "<med>"
            "med" pr aa @adv
    "<airbag>"
            "airbag" n m sg ind aa @←p-utfyll
    "<.>"
            "." sent clb aa @s-gr

Here we see that "Bilen" was tagged as the subject, which should agree
with the predicate adjective.

Use `nob-nno_e-syntax|cg-conv` to see the rules that applied (line
numbers are after rule type):

    $ echo Bilen var utstyrt med airbag |apertium -d . nob-nno_e-syntax|cg-conv
    "<Bilen>"
            "bil" n m sg def Aa MAP:4257:n SELECT:10773:Sevland-svarte @subj
            "¬bil" n m sg def Aa MAP:4257:n REMOVE:5537:not-xubj @xubj
            "¬bil" n m sg def Aa MAP:4257:n SELECT:10773:Sevland-svarte @obj @i-obj @s-pred @←p-utfyll @tittel @subst→ @app @laus-np
    "<var>"
            "være" vblex pret aa MAP:4262:1363 @fv
    "<utstyrt>"
            "utstyre" adj pp mf sg ind aa MAP:2188:1552 SELECT:12667:vi-er-fornøyd @s-pred
            "¬utstyre" adj pp mf sg ind aa MAP:2188:1552 SELECT:12667:vi-er-fornøyd @o-pred @←p-utfyll @app @laus-np
    "<med>"
            "med" pr aa MAP:3551:1420 @adv
    "<airbag>"
            "airbag" n m sg ind aa MAP:4257:n SELECT:6436:på-Sarpsborg-stadion @←p-utfyll
            "¬airbag" n m sg ind aa MAP:4257:n SELECT:6436:på-Sarpsborg-stadion @subj @obj @i-obj @s-pred @tittel @subst→ @app @laus-np
            "¬airbag" n m sg ind aa MAP:4257:n REMOVE:5537:not-xubj @xubj
    "<.>"
            "." sent clb aa MAP:2267:1546 @s-gr

For relative clauses and such, we'll see `@xubj` used:

* de<pl><@subj> nevner mannen<mf><@xubj> i 50-åra som …
* et antall<sg><@subj> av deres krigere<pl><@xubj> …

The syn.rlx file first has a bunch of `MAP` rules which apply all
possible syntactic functions to a word. The word is now very
syntactically ambiguous :) Then it uses regular `SELECT/REMOVE` rules
to narrow down the possibilities, hopefully ending up with just one
syntactic function.

(If the input was morphologically ambiguous – if the preceding rlx
file didn't pick a single reading – the syntax file may actually end
up disambiguating the morphology too.)

## How we relate the subject to the adjective

After bidix and lexical selection, the file
`apertium-nno-nob.nob-nno.refsyn.t1x` in this repo keeps track of the
last seen `@subj` (or `@xubj`) and puts it in the `ref` (referent)
field of the following words.

The `ref`-field is the third "reading", so after bidix lookup we have
`^nynorsk/bokmål$` and after refsyn we have `^nynorsk/bokmål$/ref$`.

Here I've run the refsyn step with `2>/dev/null` to strip away trace
info:

    $ echo Bilen var utstyrt med airbag |apertium -d . nob-nno_e-refsyn 2>/dev/null
    ^bil<n><m><sg><def><Aa>/bil<n><m><sg><def><Aa>/bil<n><m><sg><def><Aa><@subj>$ ^være<vblex><pret><aa>/vere<vblex><pret><aa>/bil<n><m><sg><def><Aa><@subj>$ ^utstyre<adj><pp><mf><sg><ind><aa>/utstyre<adj><pp><mf><sg><ind><aa>/bil<n><m><sg><def><Aa><@subj>$ ^med<pr><aa>/med<pr><aa>/bil<n><m><sg><def><Aa><@subj>$ ^airbag<n><m><sg><ind><aa>/kollisjonspute<n><f><sg><ind><aa>/bil<n><m><sg><def><Aa><@subj>$^.<sent><clb><aa>/.<sent><clb><aa>/bil<n><m><sg><def><Aa><@subj>$

We can use the `cg-conv` step to get more readable output, though note
that this is not form/reading/reading, but bokmål/nynorsk/referent:

    $ echo Bilen var utstyrt med airbag |apertium -d . nob-nno_e-refsyn 2>/dev/null|cg-conv

    "<bil>" n m sg def Aa
            "bil" n m sg def Aa
            "bil" n m sg def Aa @subj
    "<være>" vblex pret aa
            "vere" vblex pret aa
            "bil" n m sg def Aa @subj
    "<utstyre>" adj pp mf sg ind aa
            "utstyre" adj pp mf sg ind aa
            "bil" n m sg def Aa @subj
    "<med>" pr aa
            "med" pr aa
            "bil" n m sg def Aa @subj
    "<airbag>" n m sg ind aa
            "kollisjonspute" n f sg ind aa
            "bil" n m sg def Aa @subj
    "<.>" sent clb aa
            "." sent clb aa
            "bil" n m sg def Aa @subj

Although all the words have referents attached, the only one where it matters is

    "<utstyre>" adj pp mf sg ind aa
            "utstyre" adj pp mf sg ind aa
            "bil" n m sg def Aa @subj

which indeed has the correct referent "bil".

The refsyn T1X file is mostly quite "mechanical" in attaching
preceding subjects to following words and is not often changed, but
there are exceptions for some cases where we tend to see the target
words before their referents, e.g. passives like "selges de fine
kuene" where "selges" (transformed into "blir selde") needs to know
about its referent "kuene".

Note: For lexical adjectives, refsyn will only add the referent if the
adjective is tagged `@s-pred` and the subject gender changed to/from
nt or is plural. This is to avoid changing adverbial usage like
* Tallene<pl> er sterkt<nt> dominert (not *sterke)
* Det vi<pl> har fått til teknologisk<nt> (not *teknologiske)

## How we apply gender/number from the referent

After the refsyn step, the chunking T1X file reads the `ref`-field and
uses that to compute the gender/number of adjectives, both participles
created when splitting up passives and participles/adjectives that
existed in the input Bokmål.

The T1X rules doing this are fairly simple and not often changed. The
main logic happens in macros

    <def-macro n="ref-subj2adj" npar="1" …
    <def-macro n="ref-subj2pasv" npar="1" …

which have some exceptions for adjectives that shouldn't change
(number-words, dates, the `<def-list n="no-samsvar"`,
compound-left-parts), and otherwise just apply the gender/number of
the referent in the `ref` field to the adjective.

## How to fix a bug

Given a problem like

    $ echo 'Operasjon med fjernelse av hele eller deler av skjoldbruskkjertelen er nødvendig for å kurere sykdommen.'|apertium -d . nob-nno_e
    Operasjon med *fjernelse av heile eller delar av skjoldbruskkjertelen er nødvendige for å kurere sjukdommen.

where Apertium gave the wrong "*nødvendige" instead of "nødvendig", we
first look at the refsyn output:

    echo 'Operasjon med fjernelse av hele eller deler av skjoldbruskkjertelen er nødvendig for å kurere sykdommen.'|apertium -d . nob-nno_e-refsyn |cg-conv

and find

    "<nødvendig>" adj pst mf sg ind aa
            "nødvendig" adj pst mf sg ind aa
            "del" n m pl ind aa @subj

So "del" must've been tagged `@subj` by the syntax step; this is wrong
(it's part of the prepositional phrase "av hele eller deler av …"). We
[add some rules to the syntax
CG](https://github.com/apertium/apertium-nob/commit/5b69e024cfcbb6636fd72d5cf8f36409f2cf3ad5)
to remove `@subj` from "hele eller deler" after prepositions. Now the
adjective is left alone and no longer turns into plural:

    $ echo 'Operasjon med fjernelse av hele eller deler av skjoldbruskkjertelen er nødvendig for å kurere sykdommen.'|apertium -d . nob-nno_e
    Operasjon med *fjernelse av heile eller delar av skjoldbruskkjertelen er nødvendig for å kurere sjukdommen.



## Work remaining

- We should not remove marked plurals! Our tagging doesn't show if
  e.g. utelatt<adj><pp><pl> was the ambiguous form "utelatt" or the
  plural-only "utelatte", so T1X might turn that into mf.sg.ind to
  match the @subj, but if it actually was unambiguously plural in nob
  we should keep it that way (e.g. when adj is used as noun in
  "rapportering av utelatte").

- Sometimes the subject is a whole clause – should give nt:
  - [At disse<pl> ble solgt] er fint<nt!>
  - [Hva de mistenkte<pl> skal ha gjort], er ikke kjent<nt!>.
  May require "outer" ref, flip on clause boundary.
  But we can't always trust that som+comma ends the clause:
  - Han stadfestar at<nt> alle tenestemennene<pl> som avfyrte skot, no
    er avhøyrde<pl>

- Coordination should give plural
  - To politivakter og en vakt fra et privat vaktselskap ble drept<pl!>
  - Et fransk kjærestepar sier til VG at det var de som fant norske Maren Ueland og danske Louisa Vesterager Jespersen drept i Marokko mandag morgen.
  But sometimes hard to know if it's the same person (sg) or different (pl):
  - Programleder og tidligere gjengleder skutt og drept i København.

- Missing relative pronouns are difficult:
  - Jeg er her på grunn av beslutninger<pl> tatt<pl> på europeiske møter
  - Brasil<nt> er hardt truffet med vel 55.000 dødsfall<pl> relatert<pl> til pandemien
  - … stemte med mannens fingeravtrykk<nt> funnet<nt> hos …
  Difficult, since e.g.: ble det ved flere anledninger<pl> tatt<nt> opp i Stortinget
  - Maybe we can use ngram frequencies f(ta beslutninger) >>> f(ta anledninger)
  - Current solution: We treat sequences `n.ind pp.@o-pred` as
    agreeing. So a participle tagged as object predicate will agree in
    this manner, but this fails in e.g. «med dødsfall relatert til»
    where «dødsfall» is tagged `@←p-utfyll` and so «relatert» is just
    tagged `@adv` (maybe syn.rlx could have an `@a-pred`, but this is
    in general a difficult attachment problem)

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

- Uncommon, but referent may be far to the right:
  - Desto lenger ut i kampen vi<pl> er, desto mer sliten<sg> blir muskulaturen<sg>.
  - Mange har reist langveisfra, spesielt populær<mf> kan det virke som om Foyle<mf> er i Australia.

