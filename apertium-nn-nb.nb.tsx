<?xml version="1.0" encoding="UTF-8"?>
<tagger name="Norwegian Bokmål">
  <tagset>
    <def-label name="NOMF">
      <tags-item tags="n.f.*"/>
    </def-label>
    <def-label name="NOMM">
      <tags-item tags="n.m.*"/>
    </def-label>
    <def-label name="NOMNT">
      <tags-item tags="n.nt.*"/>
    </def-label>

    <def-label name="NUM">
      <tags-item tags="num"/>
      <tags-item tags="num.*"/>
    </def-label>

    <def-label name="DET">
      <tags-item tags="det.*"/>
    </def-label>

    <def-label name="DETDEM">
      <tags-item tags="det.dem.*"/>
    </def-label>
   
    <def-label name="PRNPERS">
      <tags-item tags="prn.p1.*"/>
      <tags-item tags="prn.p2.*"/>
      <tags-item tags="prn.p3.*"/>
    </def-label>

    <def-label name="ADJ">
      <tags-item tags="adj.*"/>
    </def-label>

    <def-label name="ADV">
      <tags-item tags="adv"/>
    </def-label>

    <def-label name="PREP">
      <tags-item tags="pr"/>
    </def-label>

    <def-label name="CNJSUB">
      <tags-item tags="cnjsub"/>
    </def-label>

    <def-label name="VBLEX">
      <tags-item tags="vblex.*"/>
    </def-label>

    <def-label name="VBLEXINF">
      <tags-item tags="vblex.inf"/>
    </def-label>

  </tagset>

  <forbid>
    <label-sequence>
      <label-item label="CNJSUB"> 
      <label-item label="CNJSUB">
    </label-sequence>
  </forbid>

</tagger>

