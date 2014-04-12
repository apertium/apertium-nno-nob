#!/usr/bin/perl -w

# bleu implementation in perl
# written by torbjørn nordgård, ntnu, trondheim
# modified 100804

# Usage: bleu.pl <file>

use strict;                             # syntakssjekk i perl

$| = 1;

# globale variabler
my %unigramhash = ();                   # opprett unigramhash og sett den tom
my %unigramhash_kladd = ();             # opprett unigramhash_kladd og sett den tom. denne brukes til å
                                        # holde orden på antall unigramforekomster
my %bigramhash = ();                    # opprett bigramhash og sett den tom
my %trigramhash = ();                   # opprett trigramhash og sett den tom
my %fourgramhash = ();                  # opprett fourgramhash og sett den tom

my $total_score = 0;                    # nullstill totalscore
my $total_sentences = 0;                # nullstill antall setninger som er oversatt
my $acceptable_length = 0;              # denne holde informasjon om kortest akseptabel setningslengde
my $source_sentence = "";                # ta vare på kildesetningen

# These globals are quite arbitrary ...
my $missing_bigram_penalty = 10;    # Added 2006-05-12
my $missing_trigram_penalty = 5;    # Added 2006-05-12
my $missing_fourgram_penalty = 2;    # Added 2006-05-12

my $unigram_count = 0;                  # Added 2006-05-12
my $bigram_count = 0;                  # Added 2006-05-12
my $trigram_count = 0;                  # Added 2006-05-12
my $fourgram_count = 0;                  # Added 2006-05-12



# hovedløkka:
while(<>) {                             # så lenge det er noe på fila ...
  next if /^\s*\;/;                     # hopp over kommentarer
  next if /^\s*$/;                      # hopp over blank
  chomp;                                # fjern eol-tegn
  my $sentence = $_;                    # opprett variabel til linja
  if ($sentence =~ /^\s*SOURCE/) {      # kildesetningsetning
       #print " $sentence \n";
       $source_sentence = $sentence;    # ta vare på hva som er kildesetningen
       %unigramhash = ();               # tøm unigraminfo
       %bigramhash = ();                # tøm bigraminfo
       %trigramhash = ();               # tøm trigraminfo
       %fourgramhash = ();              # tøm fourgraminfo
       $acceptable_length = 999999;     # gi denne en passe høy verdi (skal uansett reduseres når referansesetningene konsulteres)
  } elsif ($sentence =~ /^\s*REF.?\s+/) {      # referansesetning
     #print " $sentence\n";
     %unigramhash_kladd = ();                  # tøm unigraminfo på kladden for akkurat denne setninga
     $sentence = prepare_sentence($sentence);  # ordne opp i formatteringsinfo etc
     collect_and_store_unigram($sentence);     # lagre unigraminfo
     collect_and_store_bigram($sentence);      # lagre bigraminfo
     collect_and_store_trigram($sentence);     # lagre trigraminfo
     collect_and_store_fourgram($sentence);    # lagre fourgraminfo
     my @words = split(/\s+/,$sentence);       # lagre ordene i en liste - split på spacetegn
     if (scalar(@words) < $acceptable_length) {   # setningen er kortere enn tidligere registrerte korteste oversettelse
        $acceptable_length = scalar(@words);      # lagre som korteste oversettelse så langt
     }
  } elsif ($sentence =~ /^\s*TRANS.?\s+/) {                 # oversettelse
       #print " $sentence ";
       my $sentence_orig = $sentence;                       # kopier originalen
       $sentence = prepare_sentence($sentence);             # ordne opp i formatteringsinfo etc
       my $unigramval = compare_unigrams($sentence);        # beregn verdi for unigramsammenligning
       my $bigramval = compare_bigrams($sentence);          # beregn verdi for bigramsammenligning
       my $trigramval = compare_trigrams($sentence);        # beregn verdi for trigramsammenligning
       my $fourgramval = compare_fourgrams($sentence);      # beregn verdi for fourgramsammenligning
       my $short_penalty = penalize_short($sentence);       # beregn brevity penalty
       #print STDERR " UNI $unigramval BI $bigramval TRI $trigramval FOUR $fourgramval  \n";
       my($score);
       if ($sentence_orig =~ /^\s*TRANS\s*$/) {             # ingen oversettelse ..   # 100804
          $score = 0;                                       # .. skal gi score 0      # 100804
       } else {
          if ($unigramval == 0) {
            $score = 0;
          } elsif ($fourgram_count > 0) {
            #print " 4-gram: $fourgram_count \n";
            $score = exp(                       # vi vil ha desimaltallverdi 
                   (log($unigramval) / 4) +   # log av unigramverdi teller 1/4
                   (log($bigramval) / 4) +    # log av bigramverdi teller 1/4
                   (log($trigramval) / 4) +   # log av trigramverdi teller 1/4
                   (log($fourgramval) / 4))   # log av fourgramverdi teller 1/4
                  * $short_penalty;           # .. og ta hensyn til ev straff for kort setning
          } elsif ($trigram_count > 0) {
            #print  " 3-gram: $trigram_count \n";
            $score = exp(                       # vi vil ha desimaltallverdi 
                   (log($unigramval) / 3) +   # log av unigramverdi teller 1/3
                   (log($bigramval) / 3) +    # log av bigramverdi teller 1/3
                   (log($trigramval) / 3))   # log av trigramverdi teller 1/3
                  * $short_penalty;           # .. og ta hensyn til ev straff for kort setning          
          } elsif ($bigram_count > 0) {
            #print  " 2-gram: $bigram_count \n";
            $score = exp(                       # vi vil ha desimaltallverdi 
                   (log($unigramval) / 2) +   # log av unigramverdi teller 1/2
                   (log($bigramval) / 2))     # log av bigramverdi teller 1/2
                  * $short_penalty;           # .. og ta hensyn til ev straff for kort setning          
          } else {
            #print  " 1-gram: $unigram_count \n";
            $score = exp(                       # vi vil ha desimaltallverdi 
                   (log($unigramval) / 1))      # log av unigramverdi teller 1/1
                  * $short_penalty;           # .. og ta hensyn til ev straff for kort setning          
          } 
       }
       print $score . "\n";              # skriv ut bleu-score
       #print STDERR "$sentence has value $score \n" if ($score > 0.5);
       $total_score = $total_score + $score;               # summer opp totalscore (skal senere deles på antall setninger)
       $total_sentences++;                                 # oppdater antall setninger
    # print STDERR "MISSED THIS ONE: " . $sentence . "\n";
  } else {  # illegalt input hvis man kommer hit
     die "Dette går ikke: " . $sentence . "\n";
  }
}

# skriv deretter ut totalresultat for testfila:

#print STDERR "\n\nDOCUMENT BLEU SCORE: " . ($total_score / $total_sentences) . "\n";

############
## subrutiner:
############

# formatter setningen mht kommaer etc
sub prepare_sentence {
  my $sentence = shift;
  #print STDERR "SENTENCE IN: $sentence \n";
  $sentence =~ s/^\s*\d*\s*//;
  $sentence =~ s/^\s*REF\s*//;                # fjern innledene identifikatorer
  $sentence =~ s/^\s*SOURCE\s*//;             # fjern innledene identifikatorer
  $sentence =~ s/^\s*TRANS\s*//;              # fjern innledene identifikatorer
  $sentence =~ s/,/ ,/g;                       # space before comma
  $sentence =~ s/\./ \./g;                     # space before punctuation mark
  #print STDERR "SENTENCE OUT: $sentence \n";
  return "§START§ " . $sentence;              # legg til startsymbol
}

# lagre unigraminformasjon
sub collect_and_store_unigram {
  $unigram_count = 0;                     # Added 2006-05-12
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);      # split på spacetegn
  my $word;                                # opprett lokal variabel
  foreach $word (@words) {                 # iterer over de ordene som er samlet opp
    next if ($word eq "§START§");          # hopp over denne  # 100804
    $unigramhash_kladd{$word}++;           # store and update count
    $unigram_count++;                      # Added 2006-05-12
  }
  foreach $word (keys %unigramhash_kladd) {                       # iterer over ordene som er identifisert
     if ( (exists($unigramhash{$word})) &&                        # ordet er registert før (fra en annen referanseoversettelse)
     	  ($unigramhash_kladd{$word} > $unigramhash{$word}) ) {   # .. med færre forekomster 
          $unigramhash{$word} = $unigramhash_kladd{$word};        # legg til ny verdi
     } elsif (!(exists($unigramhash{$word}))) {                   # ordet er ikke registert før 
        $unigramhash{$word} = $unigramhash_kladd{$word};          # lagre
     }
  }
}

sub collect_and_store_bigram {
  $bigram_count = 0;                     # Added 2006-05-12
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);                  # split på spacetegn
  my($i);
  for ($i = 0; $i < (scalar(@words) -1); $i++) {       # iterer inntil nest siste ord i lista
    my $key = $words[$i] . "\t" . $words[$i+1];
    $bigramhash{$words[$i] . "\t" . $words[$i+1]}++;   # store and update bigram count
    $bigram_count++;                      # Added 2006-05-12 
    #print STDERR "Bigram key: $key \n";
  }
}

sub collect_and_store_trigram {
  $trigram_count = 0;                     # Added 2006-05-12
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);               # split på spacetegn
  my($i);
  for ($i = 0; $i < (scalar(@words) -2); $i++) {    # iterer inntil nest nest siste ord i lista
    my $key = $words[$i] . "\t" . $words[$i+1] . "\t" . $words[$i+2];
    $trigramhash{$key}++;     # store and update trigram count
    $trigram_count++;                      # Added 2006-05-12 
    #print STDERR "Trigram key: $key \n";
  }
}

sub collect_and_store_fourgram {
  $fourgram_count = 0;                     # Added 2006-05-12
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);             # split på spacetegn
  my($i);
  for ($i = 0; $i < (scalar(@words) -3); $i++) {  # iterer inntil nest nest nest siste ord i lista
    my $key = $words[$i] . "\t" . $words[$i+1] . "\t" . $words[$i+2] . "\t" . $words[$i+3];
    $fourgramhash{$key}++;     # store and update fourgram count
    #print STDERR "Fourgram key: $key \n";
    $fourgram_count++;                      # Added 2006-05-12 
  }
}


###############
#
# så sammenligningene. disse rutinene kalles etter at referansesetningenes n-grammer er talt opp
# n-gramhashene som konsulteres er kalkulert over referansesetningene
#
###############

# straff for korte setninger
sub penalize_short {
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);      # split på spacetegn
  my $wordcount = 0;                       # initialiser tellevariabel
  my($word);                               # opprett lokal variabel
  foreach $word (@words) {                 # iterer over ordene
        $wordcount++;                      # oppdater ordtelleren
  }
  if ($wordcount < $acceptable_length) {       # setningen er kortere enn minstelengden
    return 1 / faculty($acceptable_length - $wordcount);    # normaliser mot fakultet av differansen 
  } else {
    return 1;                                  # ellers alt ok - returner 1
  }
}

# sammenlign på unigramnivå:
sub compare_unigrams {
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);
  my($word);
  my $attested = 0;
  my $unattested = 0;
  my %attested_kladd = ();
  foreach $word (@words) {       # iterer ovevr ordene og 
      next if ($word eq "§START§");
      $attested_kladd{$word}++;  # .. ta vare på antallet forekomster
  }  
  foreach $word (keys %attested_kladd) {                    # iterer ovevr ordene som er identifisert
    if (exists($unigramhash{$word})) {                      # finnes i referanseoversettelsene
      if ($unigramhash{$word} <= $attested_kladd{$word}) {   # antall referanseoversettelser mindre enn i oversettelsen
        $attested = $attested + $unigramhash{$word};        # legg til maks-verdi fra unigramhash
      } else {
        $attested = $attested + $attested_kladd{$word};     # ellers - ta vare på antallet i oversettelsen
      }  
    } else {
      $unattested = $unattested + $attested_kladd{$word};   # ordet er ikke blant referanseoversettelsene
    }
  }
  my($value);
  if ($attested == 0) {                                     # ingen gjenkjent 
     #$value = (1 / $missing_unigram_penalty);
     $value = 0;
  } else {
    $value =  ($attested / ($attested + $unattested));         # returner forholdet mellom de som er funnet og de som er i kandidatsetningen
  }
  return $value;
}

sub compare_bigrams {
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);
  my($word);
  my $attested = 0;
  my $unattested = 0;
  my($i,$bigram);
  for ($i = 0; $i < (scalar(@words) -1); $i++) {
    $bigram = $words[$i] . "\t" . $words[$i+1];
    if (exists($bigramhash{$bigram})) {
      $attested++; 
    } else {
      $unattested++;
    }
  }
  my($value);
  if ($attested == 0) {
     $value = (1 / $missing_bigram_penalty);
  } else {
    $value = ($attested / ($attested + $unattested));
  }
  return $value;
}

sub compare_trigrams {
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);
  my($word);
  my $attested = 0;
  my $unattested = 0;
  my($i,$trigram);
  for ($i = 0; $i < (scalar(@words) -2); $i++) {
    $trigram = $words[$i] . "\t" . $words[$i+1] . "\t" . $words[$i+2];
    if (exists($trigramhash{$trigram})) {
      $attested++; 
      #print STDERR "Trigram attested: $trigram \n";
    } else {
      $unattested++;
      #print STDERR "Trigram unattested: $trigram \n";
    }
  }
  my($value);
  if ($attested == 0) {
    $value = (1 / $missing_trigram_penalty);
  } else {
    $value = ($attested / ($attested + $unattested));
  }
  #print STDERR "TRIGRAM VALUE $value \n";
  return $value;
}

sub compare_fourgrams {
  my $sentence = shift;
  my @words = split(/\s+/,$sentence);
  my($word);
  my $attested = 0;
  my $unattested = 0;
  my($i,$fourgram);
  for ($i = 0; $i < (scalar(@words) -3); $i++) {
    $fourgram = $words[$i] . "\t" . $words[$i+1] . "\t" . $words[$i+2] . "\t" . $words[$i+3];  
    if (exists($fourgramhash{$fourgram})) {
      $attested++; 
    } else {
      $unattested++;
    }
  }
  my($value);
  if ($attested == 0) {
      $value = (1 / $missing_trigram_penalty);
  } else {
      $value = ($attested / ($attested + $unattested));
  }
  return $value;
}

sub faculty {
  my $val = shift;
  if ($val < 2) {
    return 1;
  } else {
    return $val * faculty($val - 1);
  }
}

