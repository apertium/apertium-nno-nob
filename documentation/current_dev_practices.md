# Current Development Practices

This document is aimed at the current maintainers and contributors of the repository **apertium-nno-nob**, along with the **apertium-nno** and **apertium-nob** repositories.

It's meant to be an up-to-date compilation of know-how's and tips and tricks to develop the translation pair Bokmål <-> Nynorsk.

## The General Overview

An overview of the repository, how to install Apertium, how to use Apertium to translate in the command line and citations are found in the README.md at the root of this repository.

## The Pipeline

The Apertium pipeline consists of several separate modules that follow a sequential order. You can find an overview of the pipeline [here](https://wiki.apertium.org/w/images/4/4f/Nob-nno-pipeline-marked-autoseq.png). Note that the recent module LSX has not been added yet.

## Git

The current workflow has been to commit and push on the **master** branch. We generally do not create new branches unless there is a good reason for it.

Because the files we work on are so long, it's rare to get a merge-conflict.

### A quick walkthrough for committing and pushing a change

1. Make a change. Save the change.
2. Compile your changes:
`make -j e`
2. Do a simple check to see if your change is working:
`echo "This is what I'm checking" | apertium nob-nno`
(For bigger changes you can run the test sets and/or run a before-and-after corpus check. This is explained in another section below.)
3. `git add <filename>`
4. `git commit -m "This is what I did"`
5. `git pull --rebase`
6. `git push`
7. Done!

### Tips and tricks in the terminal
Check if a word in is in all 3 dictionaries with this simple command run from the root of the apertium-nno-nob-folder:

Enter this in the terminal to look up the word "kake" (or other words):
`echo kake | dev/word-lookup`

### Other useful Git commands
1. `git status` <-- to see which files have been changed
2. `git diff` <-- to see which changes have been done inside the files
3. `git commit -am "This is what I did"` <-- a shortcut to step 3 and 4 above. Adds all changed files though.
4. `git restore <filename>` <-- restores the file to the last commit.
5. `git log --oneline` <-- handy to look at recent commits as a list
6. `git log --grep VAR: --author=Firstname` <-- Find a commit where someone created a new variant (or whatever else you want to look for)
7. `git show <commit hash>` <-- Look at the changes in a specific commit.
8. `git blame <filename> | grep "WORD"` <-- Uncertain why something was done the way it was? This command outputs who and when a specific change happened and you can ask them, or see if something was added a long, long time ago and is now ready to be modernized.

### Windows installation and setup

1. Install WSL, Windows Subsystem for Linux, by following
   https://docs.microsoft.com/en-us/windows/wsl/install-win10

2. Install Apertium **core tools**:
```
curl -sS https://apertium.projectjj.com/apt/install-nightly.sh | sudo bash
sudo apt-get -f install apertium-all-dev
```
(if you at any point need to update the core tools, the command is `sudo apt-get update && sudo apt-get dist-upgrade`)

3. Check out the **repos** – here we need to add some settings to the clone command so VSCode doesn't think we have changes where there are none (when opening WSL files from Windows):
```
cd   # ensure we're in home directory
git clone -c core.symlinks=false -c core.filemode=false https://github.com/apertium/apertium-nno.git
git clone -c core.symlinks=false -c core.filemode=false https://github.com/apertium/apertium-nob.git
git clone -c core.symlinks=false -c core.filemode=false https://github.com/apertium/apertium-nno-nob.git
```

4. Initial build **configuration** (this step ensures that the `-nno-nob` project knows where to find the `-nno` and `-nob` folders when running `make`):
```
cd   # ensure we're in home directory
apertium-get apertium-nno-nob
```

You should now be able to compile the pair in the `apertium-nno-nob` directory with `make -j langs` (or do a faster compile of just the Bokmål→Nynorsk direction with `make -j e`).

## Testing your changes

It's handy to check if your change fixed what it was supposed to fix and did not cause accidental havoc at the same time. Here are several ways to check for accidental havoc.

### Run the test sets

Run the command:
1. `make -j tests` to run all tests
or
`make test-progression` to run only the "progression" tests (from the `./tests` folder).
2. See if your changes have improved or broken anything. The words in *blue* script are the current translations. The *green* script is from when the tests were updated last.

### Run a corpus test before and after your changes

You can of course create your own corpus to test your changes. Below is just an example. The `korpus.xz` is a file we've used in development for a while. Ask Kevin for a copy if you want to use it too. The commands are run from the `apertium-nno-nob` repository in the terminal.

1. Run a corpus test before your change
`xzcat ~/path-to-file/korpus.xz | head -10000 | apertium -d . nob-nno_e >/tmp/før.txt`
2. Make a change and compile your change
`make -j e`
3. Run a new corpus test
`xzcat ~/path-to-file/korpus.xz | head -10000 | apertium -d . nob-nno_e >/tmp/etter.txt`
4. Diff the results between the first corpus test and the second corpus test
`dev/corpdiff /tmp/før.txt /tmp/etter.txt`


## Update the  test sets and add new test cases

####  Update the test sets

If you see that the output from the test sets are both outdated and improved, you can update the tests to reflect the current, and better, translations.

1. `make update-progression`
2. `git commit -m "higher expectations (or something)"`

(Note: `make update-progression` will first translate the full test set before updating the expectations to the current output. If you have already run `make test-progression` and not done any other changes and now want to accept the current output, it's faster to just run `t/progression update` and then commit.)

####  Adding new test cases

You can add your own test cases. Here is how:

1. Add the sentences you want as test cases at the end of `tests/ymse-nob-nno_e.input.txt`. Commit and push.
2. Alternatively, add your own files in `tests/`. The format should be something like: `NICENAME-nob-nno_e.input.txt`. Add, commit and push. Your file should now be automatically picked up when running the test commands.

There is also a shortcut to adding a sentence to an existing test set:

     echo 'Dette er en setning som har en grei oversettelse nå.' | t/progression expect ymse

This will add that sentence to `tests/ymse-nob-nno_e.input.txt`, and
the current output to `tests/expected/ymse-nob-nno_e.expected.txt`,
which you can then commit.

## Add a new translation to the nno-nob dictionary

While BIDIX (the short, colloquial name for the `apertium-nno-nob/apertium-nno-nob.nno-nob.dix`-file) is comprehensive, we'll always need to add new words. Here is how you can do that:

1. Check if the word exists in the Nynorsk dictionary: `apertium-nno.nno.dix`. This file is found in the repository `apertium-nno`. If the word is in the Nynorsk dictionary then move on, if not add the word with the correct paradigm. (Tip: Use the same paradigm as similar words uses if the paradigm names are confusing.)
2. Check if the word exists in the Bokmål dictionary: `apertium-nob.nob.dix`. This file is found in the repository `apertium-nob`. If the word is in the Bokmål dictionary then move on, if not add the word with the correct paradigm. (New tip: Unsure if the paradigm you chose is correct? You can search for the paradigm in the .DIX file like this: `pardef n="paradigm_name"`)
3. Check if the word is in the translation dictionary (BIDIX): `apertium-nno-nob/apertium-nno-nob.nno-nob.dix`. If not, add the translation with the correct paradigms in the file.
4. Save and compile your changes, then test if your word is now being translated correctly.

### Troubleshooting

#### A word gets \# in front of it
This frequently means that a paradigm is wrong in one of the 3 dictionaries.

#### A word gets \* in front of it
This means the word is not recognized by Apertium. Check if the word has been added to the dictionaries and compile your changes again.

## Adding varieties to the nynorsk translation

There is a high rate of variance within Nynorsk. For example, users can choose between "me" and "vi" (ENG: "we"), or root differences in a word, such as "naud" and "nød" (ENG: "need").

In 2022 the work to add new varieties accelerated. Currently, there is a high number of variants to choose from, making the translation from Bokmål to Nynorsk highly customizable.

### Adding lemma varieties
It's simple to add a variety were the users choose between 2 different lemmas, like the example of "me"/"vi".

To add a new variety of this type you can follow the template in the following commit: [VAR: samtidig_samstundes](https://github.com/apertium/apertium-nno-nob/commit/3bda68feca97ca0b5b667d050e97df5c890be672)

Slightly more complicated is having a grouping of several different lemmas under one rule: [VAR: apa_apen](https://github.com/apertium/apertium-nno-nob/commit/cebc2a145929b59cb72a49a108d772fa2307979b) (Note: This commit only shows how we can achieve this in one of the files. You still need to add the variety name in nob-nno.preferences.xml and make sure all the lemmas are in BIDIX without any RL/LR-tags)

Remember that both varieties need to be in the Nynorsk dictionary and in BIDIX.

### Adding variations of the same lemma

It can be slightly more complicated to add variations of the same lemma. An example of this type of variant is the verb "kome" which can also be written as "komme" (ENG: "to come").

To add a lemma variation of a common noun this is one way of doing it: [VAR: stove_stue](https://github.com/apertium/apertium-nno/commit/821a1dfb6ce9f4811cda1f6deeb0bfb1df8c64b6)

To add a variant of a lemma where you also need to adjust the inflection paradigm you can do something similar to this: [VAR: komme_kome](https://github.com/apertium/apertium-nno/commit/c932ee73f3af43acf7f665ac84b717c6c13e579d)

## Confirm that the varieties are working

You can check if your variety is working in the terminal like this:

`echo "Det er én skole i kommunen." | AP_SETVAR="skule_skole.vok-u2o" apertium -d. nob-nno_e`

You can also check specific words in a group of words within one variety like ths:

`echo "Den apen, den kassen" | AP_SETVAR="apa_apen=kasse:ape" apertium -d. nob-nno_e`

Or just one word:

`echo "Den apen, den kassen" | AP_SETVAR="apa_apen=kasse" apertium -d. nob-nno_e`


If you want to use the same `AP_SETVAR` for several `apertium` commands, you can `export` the variable:

`export AP_SETVAR="apa_apen=kasse"`

Now when you do

`echo "Den apen, den kassen" | apertium -d. nob-nno_e`

you will get the same result as if you did

`echo "Den apen, den kassen" | AP_SETVAR="apa_apen=kasse" apertium -d. nob-nno_e`

The setting will last until you close the terminal (or export it to something else or `unset AP_SETVAR`).
