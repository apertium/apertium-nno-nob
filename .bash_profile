apert ()
{
  echo "$1" | apertium -d. nob-nno_e$2 | cg-conv -a
}
