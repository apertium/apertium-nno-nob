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
| dift | diphthong | nød_naud.dift-ø2au |
| ø2au | ø -> au | nød_naud.dift-ø2au |