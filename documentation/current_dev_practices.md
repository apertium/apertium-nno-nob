# Current Development Practices

This document is aimed at the current maintainers and contributors of the repository **apertium-nno-nob**, along with the **apertium-nno** and **apertium-nob** repositories. 

It's meant to be an up-to-date compilation of know-how's and tips and tricks to develop the translation pair Bokmål <-> Nynorsk.

## The General Overview

An overview of the repository, how to install Apertium, how to use Apertium to translate in the command line and citations are found in the README.md at the root of this repository.

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

### Other useful Git commands
1. `git status` <-- to see which files have been changed
2. `git diff` <-- to see which changes have been done inside the files
3. `git commit -am "This is what I did"` <-- a shortcut to step 3 and 4 above. Adds all changed files though.
4. `git restore <filename>` <-- restores the file to the last commit. 
5. `git log --oneline` <-- handy to look at recent commits as a list
6. `git log --grep VAR: --author=Firstname` <-- Find a commit where someone created a new variant (or whatever else you want to look for)
7. `git show <commit hash>` <-- Look at the changes in a specific commit.
8. `git blame <filename> | grep "WORD"` <-- Uncertain why something was done the way it was? This command outputs who and when a specific change happened and you can ask them, or see if something was added a long, long time ago and is now ready to be modernized.

## Testing your changes

It's handy to check if your change fixed what it was supposed to fix and did not cause accidental havoc at the same time. Here are several ways to check for accidental havoc.

### Run the test sets

Run the command:
1. `make -j tests` 
or 
`make test-progression`
2. See if your changes have improved or broken anything. The words in *blue* script are the current translations. The *green* script is from when the tests were updated last. 

### Run a corpus test before and after your changes

You can of course create your own corpus to test your changes. Below is just an example. The `korpus.xz` is a file we've used in development for a whil. Ask Kevin for a copy if you want to use it too. The commands are run from the `apertium-nno-nob` repository in the terminal.

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

####  Adding new test cases

You can add your own test cases. Here is how:

1. Add the sentences you want as test cases at the end of `tests/ymse-nob-nno_e.input.txt`. Commit and push.
2. Alternatively, add your own files in `tests/`. The format should be something like: `NICENAME-nob-nno_e.input.txt`. Add, commit and push. Your file should now be automatically picked up when running the test commands.

## Add a new translation to the nno-nob dictionary

While BIDIX (the short, colloquial name for the `apertium-nno-nob/apertium-nno-nob.nno-nob.dix`-file) is comprehensive, we'll always need to add new words. Here is how you can do that:

1. Check if the word exists in the Nynorsk dictionary: `apertium-nno.nno.dix`. This file is found in the repository `apertium-nno`. If the word is in the Nynorsk dictionary then move on, if not add the word with the correct paradigm. (Tip: Use the same paradigm as similar words uses if the paradigm names are confusing.)
2. Check if the word exists in the Bokmål dictionary: `apertium-nob.nob.dix`. This file is found in the repository `apertium-nob`. If the word is in the Bokmål dictionary then move on, if not add the word with the correct paradigm. (New tip: Unsure if the paradigm you chose is correct? You can search for the paradigm in the .DIX file like this: `pardef n="paradigm_name"`)
3. Check if the word is in the translation dictionary (BIDIX): `apertium-nno-nob/apertium-nno-nob.nno-nob.dix`. If not, add the translation with the correct paradigms in the file. 
4. Compile your changes and test if your word is now being translated.

### Troubleshooting

#### A word gets \# in front of it
This frequently means that a paradigm is wrong in one of the 3 dictionaries. 

#### A word gets \* in front of it
This means the word is not recognized by Apertium. Check if the word has been added to the dictionaries and compile your changes again. 

