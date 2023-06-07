# About word and spelling preferences in Nynorsk

During 2022 and 2023 the work to add word and spelling preferences in the Bokmål -> Nynorsk translation accelerated. This change allows the users translating their text into Nynorsk to have a highly customizable translation, a translation that will hopefully be close to their desired Nynorsk variant.

The purpose of this document is to explain what those word forms or spelling preferences look like, because as of now they can look confusing to an outside developer.

## What are these word forms and spelling variations?

Written Norwegian, both Bokmål and Nynorsk, have several permitted spelling variations. For instance, in Bokmål you it's possible to write both "vei" or "veg" for the word English word "road", and in Nynorsk you can write "me" or "vi" for the Enlish word "we". It's up to the user or organization to decide which variant they prefer.

### What about spelling preferences in Bokmål?

As of now, we've only worked on the word and spelling preferences in Nynorsk, this is what we had funding for. However, the structure we've set up for allowing word and spelling preferences in Nynorsk is also in place for Bokmål, as such the work will be significantly easier in the reverse direction.

## Where are the variations listed?

There are 2 main files where the word and spelling preferences are listed:

```
nob-nno.preferences.xml
nno.preferences.xml
```

In those files you'll se the preferences listed like this:
```
<preference id="nød_naud.dift-ø2au">
    <description lang="nno">nødvendig → naudsynt, unødvendig → uturvande, ikkje-nødvendig → ikkje-naudsynt, nødvendighet → naudsyn, nødvendigvis → naudsynleg
</description>
```

As you can see there is a description. The description explains what type of change you can expect when activating this preference. The id is slightly more opaque. In this case `nød_naud.dift-ø2au` means that the the word `nød` is changed to `naud`, in addition to similar words. `dift` means diphthong and `ø2au`specifies that the vowel `ø` that is changed to `au`.

### List of custion abbreviation used in preferences

| Abbreviation | Meaning | Example use case |
| -------------------- | -------------------- | -------------------- |
| 2e | Ø -> e | mengd_mengde.vok-2e |
| a2e | a -> e | kvalp_kvelp.vok-a2e |
| a2å | a -> å | då_da.vok-a2å |
| d2t | d -> t | kjende_kjente.vb-d2t |
| dift | diphthong | nød_naud.dift-ø2au |
| e2ei | e -> ei | pek_peik.dift-e2ei |
| e2i | e -> i | segle_sigle.vok-e2i |
| en2tt | en -> tt | tek_tar.vb-en2tt |
| fore2føre | fore -> føre | formål_føremål.afx-fore2føre |
| i2y | i -> y | drikk_drykk.vok-i2y |
| inf | infinitive form | flyg_flyr.vb-inf |
| kj2k_gj2g | kj -> k, gj -> j | enke_enkje.kj2k_gj2g |
| kons | consonant | følgje_følge.kons-lgj2lg |
| lgj2lg  | lgj -> lg | følgje_følge.kons-lgj2lg |
| mm2m | mm -> m | venn_ven.kons-mm2m |
| ning2ing | ning -> ing | forvaltning_forvalting.afx-ning2ing |
| o2a | o -> a | trost_trast.vok-o2a |
| sel2sle | sel -> sle | redsel_redsle.kons-sel2sle |
| stav | spelling (stavelse) | nærare_nærmare.stav |
| syn | synonym | krins_krets.syn |
| tj2tt | tj -> tt | setje_sette.kons-tj2tt |
| u2o | u -> o | skule_skole.vok-u2o |
| vb | verb | kjende_kjente.vb-d2t |
| vok | vowel | følgje_fylgje.vok-ø_gj2y_gj |
| y2jo | y -> jo | lys_ljos.vok-y2jo |
| y2u | y -> u | lykke_lukke.vok-y2u |
| ø_gj2y_gj | ø_gj -> y_gj | følgje_fylgje.vok-ø_gj2y_gj |
| ø2au | ø -> au | nød_naud.dift-ø2au |
| ø2o | ø -> o | høvding_hovding.vok-ø2o |
| ø2u | ø -> u | søndag_sundag.vok-ø2u |
| ø2y | ø -> y | først_fyrst.vok-ø2y |
| ø2æ | ø -> æ | fjøre_fjære.vok-ø2æ |
| ø2øy | ø -> øy | dødeleg_døyeleg.dift-ø2øy |
